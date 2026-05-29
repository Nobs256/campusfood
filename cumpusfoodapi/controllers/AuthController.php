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

        $db->prepare("UPDATE users SET last_login=NOW() WHERE id=?")->execute([$user['id']]);
        $tokens = Auth::issueTokens($user);
        unset($user['password']);

        Response::json(array_merge($tokens, ['user' => $user, 'vendor' => $vendorData]));
    }

    public function register(): void {
        $db   = Database::getInstance();
        // Support both JSON (student registration) and multipart/form-data (image uploads)
        $body = !empty($_POST) ? $_POST : Request::json();
        $type = sanitize($body['type'] ?? '');

        $missing = validateRequired($body, ['full_name','email','password','type']);
        if ($missing) Response::error('Missing fields: ' . implode(', ', $missing), 422);
        if (!in_array($type, ['student','vendor'])) Response::error('Type must be student or vendor', 422);
        if (strlen($body['password']) < 8) Response::error('Password must be at least 8 characters', 422);

        $ex = $db->prepare("SELECT id FROM users WHERE email=?");
        $ex->execute([sanitize($body['email'])]);
        if ($ex->fetch()) Response::error('Email already registered', 409);

        // Handle user profile avatar upload
        $avatarUrl = null;
        if (!empty($_FILES['avatar'])) {
            try { $avatarUrl = uploadImage($_FILES['avatar'], 'users'); }
            catch (Exception $e) { Response::error($e->getMessage(), 422); }
        }

        $db->prepare("INSERT INTO users (full_name, email, password, role, phone, avatar_url) VALUES (?,?,?,?,?,?)")
           ->execute([sanitize($body['full_name']), sanitize($body['email']), password_hash($body['password'], PASSWORD_BCRYPT, ['cost'=>12]), $type, sanitize($body['phone'] ?? ''), $avatarUrl]);
        $userId = $db->lastInsertId();

        $vendorData = null;
        if ($type === 'vendor') {
            $missing2 = validateRequired($body, ['business_name','location']);
            if ($missing2) Response::error('Vendor requires business_name and location', 422);

            // Handle vendor specific images
            $profileImage = null;
            $bannerImage  = null;
            try {
                if (!empty($_FILES['profile_image'])) $profileImage = uploadImage($_FILES['profile_image'], 'vendors');
                if (!empty($_FILES['banner_image']))  $bannerImage  = uploadImage($_FILES['banner_image'], 'vendors');
            } catch (Exception $e) { Response::error($e->getMessage(), 422); }

            $slug = generateSlug($db, $body['business_name']);
            $db->prepare("INSERT INTO vendors (user_id, business_name, slug, description, location, phone, whatsapp, opening_time, closing_time, profile_image, banner_image) VALUES (?,?,?,?,?,?,?,?,?,?,?)")
               ->execute([$userId, sanitize($body['business_name']), $slug, sanitize($body['description'] ?? ''), sanitize($body['location']), sanitize($body['phone'] ?? ''), sanitize($body['whatsapp'] ?? ''), $body['opening_time'] ?? null, $body['closing_time'] ?? null, $profileImage, $bannerImage]);

            // Fetch vendor data to return in response
            $vs = $db->prepare("SELECT * FROM vendors WHERE user_id=?");
            $vs->execute([$userId]);
            $vendorData = $vs->fetch();
        }

        $userStmt = $db->prepare("SELECT * FROM users WHERE id=?");
        $userStmt->execute([$userId]);
        $user = $userStmt->fetch();
        unset($user['password']);
        $tokens = Auth::issueTokens($user);
        Response::json(array_merge($tokens, ['user' => $user, 'vendor' => $vendorData]), 201);
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