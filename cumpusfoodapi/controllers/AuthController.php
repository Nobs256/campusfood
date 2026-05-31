<?php
class AuthController {
    private $auth;

    public function __construct(?array $auth)
    {
        $this->auth = $auth;
    }

    public function login(): void {
        $body  = Request::json();
        $email = sanitize($body['email'] ?? '');
        $pass  = $body['password'] ?? '';
        if (!$email || !$pass) Response::error('Email and password required', 422);

        $db   = Database::getInstance();
        $stmt = $db->prepare("SELECT * FROM users WHERE email=? AND is_active=1");
        $stmt->execute([$email]);
        $user = $stmt->fetch();

        if (!$user || !password_verify($pass, $user['password']))
            Response::error('Invalid email or password', 401);

        $vendorData = null;
        if ($user['role'] === 'vendor') {
            $vs = $db->prepare("SELECT * FROM vendors WHERE user_id=?");
            $vs->execute([$user['id']]);
            $vendorData = $vs->fetch();
        }

        // Nest vendor data inside user for model consistency on the frontend
        if ($vendorData) {
            $user['vendor'] = $vendorData;
        }

        $db->prepare("UPDATE users SET last_login=NOW() WHERE id=?")->execute([$user['id']]);
        $tokens = Auth::issueTokens($user);
        unset($user['password']);

        Response::json(array_merge($tokens, ['user' => $user]));
    }

    public function register(): void {
        $db   = Database::getInstance();

        // Detect if post size limit was exceeded. PHP wipes $_POST/$_FILES if limit is hit for multipart data.
        // We only trigger this for multipart/form-data requests.
        $contentType = $_SERVER['CONTENT_TYPE'] ?? '';
        if ($_SERVER['REQUEST_METHOD'] === 'POST' && 
            strpos($contentType, 'multipart/form-data') !== false &&
            empty($_POST) && empty($_FILES) && 
            ($_SERVER['CONTENT_LENGTH'] ?? 0) > 0) {
            Response::error('Upload limit exceeded. Try smaller images.', 413);
        }

        // Support both JSON (student registration) and multipart/form-data (image uploads)
        $body = !empty($_POST) ? $_POST : Request::json();
        $type = sanitize($body['type'] ?? '');

        $missing = validateRequired($body, ['full_name', 'email', 'password', 'type']);
        if ($missing) Response::error('Missing fields: ' . implode(', ', $missing), 422);
        if (!in_array($type, ['student','vendor'])) Response::error('Type must be student or vendor', 422);
        if (strlen($body['password']) < 8) Response::error('Password must be at least 8 characters', 422);

        // Pre-validate vendor requirements before starting database operations
        if ($type === 'vendor') {
            $missingVendor = validateRequired($body, ['business_name', 'location']);
            if ($missingVendor) Response::error('Vendor requires business_name and location', 422);
        }

        $ex = $db->prepare("SELECT id FROM users WHERE email=?");
        $ex->execute([sanitize($body['email'])]);
        if ($ex->fetch()) Response::error('Email already registered', 409);

        try {
            $db->beginTransaction();

            // Handle user profile avatar upload inside the transaction block
            $avatarUrl = null;
            $avatarKey = !empty($_FILES['avatar']) ? 'avatar' : (!empty($_FILES['avatar_url']) ? 'avatar_url' : (!empty($_FILES['profile_image']) && $type === 'student' ? 'profile_image' : null));
            
            if ($avatarKey) {
                try { $avatarUrl = uploadImage($_FILES[$avatarKey], 'users'); }
                catch (Exception $e) { throw new Exception("Avatar upload failed: " . $e->getMessage()); }
            }

            $db->prepare("INSERT INTO users (full_name, email, password, role, phone, avatar_url) VALUES (?,?,?,?,?,?)")
               ->execute([sanitize($body['full_name']), sanitize($body['email']), password_hash($body['password'], PASSWORD_BCRYPT, ['cost'=>12]), $type, sanitize($body['phone'] ?? ''), $avatarUrl]);
            $userId = (int)$db->lastInsertId();

            $vendorData = null;
            if ($type === 'vendor') {
                // Handle vendor images
                $profileImg = null;
                $bannerImg = null;
                try {
                    if (!empty($_FILES['profile_image'])) $profileImg = uploadImage($_FILES['profile_image'], 'vendors');
                    if (!empty($_FILES['banner_image']))  $bannerImg  = uploadImage($_FILES['banner_image'], 'vendors');
                } catch (Exception $e) {
                    throw new Exception("Vendor image upload failed: " . $e->getMessage());
                }

                $slug = generateSlug($db, $body['business_name']);
                $db->prepare("INSERT INTO vendors (user_id, business_name, slug, description, location, phone, whatsapp, opening_time, closing_time, profile_image, banner_image, status) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)")
                   ->execute([
                        $userId, sanitize($body['business_name']), $slug, sanitize($body['description'] ?? ''), 
                        sanitize($body['location']), sanitize($body['phone'] ?? ''), sanitize($body['whatsapp'] ?? ''), 
                        $body['opening_time'] ?? null, $body['closing_time'] ?? null, $profileImg, $bannerImg, 'pending'
                    ]);

                $vs = $db->prepare("SELECT * FROM vendors WHERE user_id=?");
                $vs->execute([$userId]);
                $vendorData = $vs->fetch();
                if ($vendorData) {
                    // Cast to ensure compatibility with Dart models
                    $vendorData['id'] = (int)$vendorData['id'];
                    $vendorData['user_id'] = (int)$vendorData['user_id'];
                    $vendorData['avg_rating'] = (float)($vendorData['avg_rating'] ?? 0);
                    $vendorData['total_ratings'] = (int)($vendorData['total_ratings'] ?? 0);
                }
            }

            $userStmt = $db->prepare("SELECT * FROM users WHERE id=?");
            $userStmt->execute([$userId]);
            $user = $userStmt->fetch();
            if ($user) {
                $user['id'] = (int)$user['id']; // Cast ID to int for Flutter
                unset($user['password']);
                // Nest vendor data inside user for model consistency on the frontend
                if ($vendorData) {
                    $user['vendor'] = $vendorData;
                }
            }
            $tokens = Auth::issueTokens($user);

            $db->commit();
            Response::json(array_merge($tokens, ['user' => $user]), 201);
        } catch (Throwable $e) {
            if ($db->inTransaction()) {
                $db->rollBack();
            }
            Response::error($e->getMessage(), 500);
        }
    }

    public function refresh(): void {
        $body  = Request::json();
        $token = $body['refresh_token'] ?? '';
        if (!$token) Response::error('refresh_token required', 422);

        $db   = Database::getInstance();
        $hash = hash('sha256', $token);
        $stmt = $db->prepare("SELECT * FROM refresh_tokens WHERE token=? AND revoked=0 AND expires_at > NOW()");
        $stmt->execute([$hash]);
        $rt = $stmt->fetch();
        if (!$rt) Response::error('Invalid or expired refresh token', 401);

        $db->prepare("UPDATE refresh_tokens SET revoked=1 WHERE id=?")->execute([$rt['id']]);

        $userStmt = $db->prepare("SELECT * FROM users WHERE id=? AND is_active=1");
        $userStmt->execute([$rt['user_id']]);
        $user = $userStmt->fetch();
        if (!$user) Response::error('User not found', 404);
        unset($user['password']);
        Response::json(Auth::issueTokens($user));
    }

    public function logout(): void {
        $body  = Request::json();
        $token = $body['refresh_token'] ?? '';
        if ($token) {
            Database::getInstance()->prepare("UPDATE refresh_tokens SET revoked=1 WHERE token=?")
                ->execute([hash('sha256', $token)]);
        }
        Response::json(['logged_out' => true]);
    }

    public function profile(): void {
        $db   = Database::getInstance();
        $stmt = $db->prepare("SELECT id, full_name, email, phone, avatar_url, role, created_at FROM users WHERE id=?");
        $stmt->execute([$this->auth['uid']]);
        $user = $stmt->fetch();
        Response::json($user);
    }

    public function updateProfile(): void {
        $db   = Database::getInstance();
        $body = Request::json();
        $db->prepare("UPDATE users SET full_name=?, phone=? WHERE id=?")
           ->execute([sanitize($body['full_name'] ?? ''), sanitize($body['phone'] ?? ''), $this->auth['uid']]);
        Response::json(['updated' => true]);
    }
}