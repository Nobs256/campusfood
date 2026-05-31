<?php
class FoodController {
    private $auth;

    public function __construct(?array $auth)
    {
        $this->auth = $auth;
    }

    public function index(): void {
        $db         = Database::getInstance();
        $vendorId   = (int)Request::get('vendor_id');
        $categoryId = (int)Request::get('category_id');
        $available  = Request::get('available');
        $page       = max(1,(int)Request::get('page',1));
        $perPage    = ITEMS_PER_PAGE;

        $cond   = ["v.status='approved'"];
        $params = [];
        if ($vendorId)   { $cond[] = 'fi.vendor_id=?';   $params[] = $vendorId; }
        if ($categoryId) { $cond[] = 'fi.category_id=?'; $params[] = $categoryId; }
        if ($available !== null) { $cond[] = 'fi.is_available=1'; }

        $where  = 'WHERE ' . implode(' AND ', $cond);
        $countStmt = $db->prepare("SELECT COUNT(*) FROM food_items fi JOIN vendors v ON v.id=fi.vendor_id $where");
        $countStmt->execute($params); 
        $total = (int)$countStmt->fetchColumn();

        $sortQuery = Request::get('sort', 'newest');
        $sort = 'fi.created_at DESC';
        switch($sortQuery) {
            case 'price_asc':  $sort = 'fi.price ASC'; break;
            case 'price_desc': $sort = 'fi.price DESC'; break;
            case 'rating':     $sort = 'fi.avg_rating DESC'; break;
            case 'popular':    $sort = 'fi.views DESC'; break;
        }

        $stmt = $db->prepare("
            SELECT fi.*, c.name AS category_name, c.icon AS category_icon,
                   v.business_name AS vendor_name, v.slug AS vendor_slug, v.location AS vendor_location,
                   v.opening_time, v.closing_time
            FROM food_items fi
            JOIN vendors v ON v.id=fi.vendor_id
            JOIN categories c ON c.id=fi.category_id
            $where ORDER BY $sort LIMIT ? OFFSET ?
        ");
        $params[] = $perPage;
        $params[] = paginationOffset($page, $perPage);
        $stmt->execute($params);
        $items = $stmt->fetchAll();

        Response::paginated($items, $total, $page, $perPage);
    }

    public function featured(): void {
        $db   = Database::getInstance();
        $stmt = $db->query("
            SELECT fi.*, v.business_name AS vendor_name, v.slug AS vendor_slug, c.name AS category_name 
            FROM food_items fi 
            JOIN vendors v ON v.id=fi.vendor_id 
            JOIN categories c ON c.id=fi.category_id 
            WHERE fi.is_featured=1 AND v.status='approved' 
            ORDER BY fi.avg_rating DESC LIMIT 20
        ");
        Response::json($stmt->fetchAll());
    }

    public function show(string $id): void {
        $db   = Database::getInstance();
        $stmt = $db->prepare("
            SELECT fi.*, c.name AS category_name, v.business_name AS vendor_name, v.slug AS vendor_slug,
                   v.location AS vendor_location, v.opening_time, v.closing_time
            FROM food_items fi
            JOIN vendors v ON v.id=fi.vendor_id
            JOIN categories c ON c.id=fi.category_id
            WHERE fi.id=? AND v.status='approved'
        ");
        $stmt->execute([(int)$id]);
        $item = $stmt->fetch();
        if (!$item) Response::error('Food item not found', 404);

        recordView($db, (int)$id, (int)$item['vendor_id'], $_SERVER['REMOTE_ADDR'] ?? '');
        Response::json($item);
    }

    public function store(): void {
        $db   = Database::getInstance();
        // Combine JSON input and POST data to support both application/json and multipart/form-data
        $body = array_merge(Request::json(), $_POST);

        $vendorStmt = $db->prepare("SELECT id FROM vendors WHERE user_id=? AND status='approved'");
        $vendorStmt->execute([$this->auth['uid']]);
        $v = $vendorStmt->fetch();
        if (!$v) Response::error('Unauthorized or vendor not approved', 403);

        $missing = validateRequired($body, ['name','price','category_id']);
        if ($missing) Response::error('Missing: ' . implode(', ', $missing), 422);

        $imageUrl = null;
        if (!empty($_FILES['image'])) {
            try { $imageUrl = uploadImage($_FILES['image'], 'foods'); }
            catch (Exception $e) { Response::error($e->getMessage(), 422); }
        }

        $db->prepare("INSERT INTO food_items (vendor_id, category_id, name, description, price, image_url, is_available, is_featured, serving_size, calories, tags) VALUES (?,?,?,?,?,?,?,?,?,?,?)")
           ->execute([
                $v['id'], (int)$body['category_id'], sanitize($body['name']), sanitize($body['description'] ?? ''), 
                (float)$body['price'], $imageUrl, (int)($body['is_available'] ?? 1), (int)($body['is_featured'] ?? 0),
                sanitize($body['serving_size'] ?? ''), $body['calories'] ?? null, sanitize($body['tags'] ?? '')
            ]);

        Response::json(['id' => $db->lastInsertId()], 201);
    }

    public function update(string $id): void {
        $db   = Database::getInstance();
        $body = array_merge(Request::json(), $_POST);

        $stmt = $db->prepare("SELECT fi.id, fi.image_url FROM food_items fi JOIN vendors v ON v.id=fi.vendor_id WHERE fi.id=? AND v.user_id=?");
        $stmt->execute([(int)$id, $this->auth['uid']]);
        $existing = $stmt->fetch();
        if (!$existing) Response::error('Forbidden or not found', 403);

        $missing = validateRequired($body, ['name','price','category_id']);
        if ($missing) Response::error('Missing: ' . implode(', ', $missing), 422);

        $imageUrl = $existing['image_url']; // Default to current image URL
        if (!empty($_FILES['image'])) {
            try { $imageUrl = uploadImage($_FILES['image'], 'foods'); }
            catch (Exception $e) { Response::error($e->getMessage(), 422); }
        }

        $db->prepare("UPDATE food_items SET category_id=?, name=?, description=?, price=?, image_url=?, is_available=?, is_featured=?, serving_size=?, calories=?, tags=? WHERE id=?")
           ->execute([
                (int)$body['category_id'], sanitize($body['name']), sanitize($body['description'] ?? ''), 
                (float)$body['price'], $imageUrl, (int)($body['is_available'] ?? 1), (int)($body['is_featured'] ?? 0),
                sanitize($body['serving_size'] ?? ''), $body['calories'] ?? null, sanitize($body['tags'] ?? ''), (int)$id
            ]);

        Response::json(['updated' => true]);
    }

    public function destroy(string $id): void {
        $db = Database::getInstance();
        $check = $db->prepare("SELECT fi.id FROM food_items fi JOIN vendors v ON v.id=fi.vendor_id WHERE fi.id=? AND v.user_id=?");
        $check->execute([(int)$id, $this->auth['uid']]);
        if (!$check->fetch()) Response::error('Forbidden', 403);

        $db->prepare("DELETE FROM food_items WHERE id=?")->execute([(int)$id]);
        Response::json(['deleted' => true]);
    }

    public function toggleAvailability(string $id): void {
        $db = Database::getInstance();
        $db->prepare("UPDATE food_items fi JOIN vendors v ON v.id=fi.vendor_id SET fi.is_available = NOT fi.is_available WHERE fi.id=? AND v.user_id=?")
           ->execute([(int)$id, $this->auth['uid']]);
        Response::json(['updated' => true]);
    }
    
    public function compare(): void {
        $db  = Database::getInstance();
        $ids = array_filter(array_map('intval', explode(',', Request::get('ids', ''))));
        if (empty($ids) || count($ids) > 4) Response::error('Provide 1–4 food IDs', 422);

        $placeholders = implode(',', array_fill(0, count($ids), '?'));
        $stmt = $db->prepare("
            SELECT fi.*, c.name AS category_name, c.icon AS category_icon,
                   v.business_name AS vendor_name, v.slug AS vendor_slug, v.location AS vendor_location
            FROM food_items fi
            JOIN vendors v ON v.id=fi.vendor_id
            JOIN categories c ON c.id=fi.category_id
            WHERE fi.id IN ($placeholders) AND v.status='approved'
        ");
        $stmt->execute($ids);
        $items = $stmt->fetchAll();

        if ($items) {
            $minPrice  = min(array_column($items, 'price'));
            $maxRating = max(array_column($items, 'avg_rating'));
            foreach ($items as &$i) {
                $i['is_cheapest']      = (float)$i['price'] == (float)$minPrice;
                $i['is_highest_rated'] = (float)$i['avg_rating'] == (float)$maxRating && (float)$i['avg_rating'] > 0;
            }
        }
        Response::json($items);
    }
}
