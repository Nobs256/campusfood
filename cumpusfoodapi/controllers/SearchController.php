<?php
class SearchController {
    private $auth;

    public function __construct(?array $auth)
    {
        $this->auth = $auth;
    }

    public function search(): void {
        $db         = Database::getInstance();
        $q          = sanitize(Request::get('q', ''));
        $categoryId = (int)Request::get('category_id');
        $minPrice   = (float)Request::get('min_price', 0);
        $maxPrice   = (float)Request::get('max_price', 0);
        $available  = Request::get('available');
        $vendorId   = (int)Request::get('vendor_id');
        $sort       = Request::get('sort', 'newest');
        $page       = max(1,(int)Request::get('page',1));

        $cond   = ["v.status='approved'"];
        $params = [];

        if ($q) {
            $cond[]   = '(fi.name LIKE ? OR fi.description LIKE ? OR fi.tags LIKE ? OR v.business_name LIKE ?)';
            $like     = "%$q%";
            $params   = array_merge($params, [$like, $like, $like, $like]);
        }
        if ($categoryId) { $cond[] = 'fi.category_id=?';   $params[] = $categoryId; }
        if ($minPrice)   { $cond[] = 'fi.price >= ?';       $params[] = $minPrice; }
        if ($maxPrice)   { $cond[] = 'fi.price <= ?';       $params[] = $maxPrice; }
        if ($vendorId)   { $cond[] = 'fi.vendor_id=?';      $params[] = $vendorId; }
        if ($available !== null) $cond[] = 'fi.is_available=1';

        $where = 'WHERE ' . implode(' AND ', $cond);
        $countStmt = $db->prepare("SELECT COUNT(*) FROM food_items fi JOIN vendors v ON v.id=fi.vendor_id $where");
        $countStmt->execute($params);
        $total = (int)$countStmt->fetchColumn();

        $orderBy = 'fi.created_at DESC';
        switch($sort) {
            case 'price_asc':  $orderBy = 'fi.price ASC'; break;
            case 'price_desc': $orderBy = 'fi.price DESC'; break;
            case 'rating':     $orderBy = 'fi.avg_rating DESC'; break;
            case 'popular':    $orderBy = 'fi.views DESC'; break;
        }

        $stmt = $db->prepare("
            SELECT fi.id, fi.name, fi.description, fi.price, fi.image_url, fi.is_featured,
                   fi.is_available, fi.avg_rating, fi.total_ratings, fi.views, fi.tags, 
                   c.name AS category_name, c.icon AS category_icon,
                   v.id AS vendor_id, v.business_name AS vendor_name, v.slug AS vendor_slug, v.location,
                   v.opening_time, v.closing_time
            FROM food_items fi
            JOIN vendors v ON v.id=fi.vendor_id
            JOIN categories c ON c.id=fi.category_id
            $where ORDER BY $orderBy LIMIT ? OFFSET ?
        ");
        $params[] = ITEMS_PER_PAGE;
        $params[] = paginationOffset($page);
        $stmt->execute($params);
        $items = $stmt->fetchAll();

        Response::paginated($items, $total, $page, ITEMS_PER_PAGE);
    }

    public function autocomplete(): void {
        $db = Database::getInstance();
        $q  = sanitize(Request::get('q', ''));
        if (strlen($q) < 2) Response::json([]);

        $like = "%$q%";
        $stmt = $db->prepare("
            (SELECT 'food' AS type, fi.id, fi.name AS label, fi.image_url FROM food_items fi JOIN vendors v ON v.id=fi.vendor_id WHERE fi.name LIKE ? AND v.status='approved' LIMIT 5)
            UNION
            (SELECT 'vendor' AS type, v.id, v.business_name AS label, v.profile_image AS image_url FROM vendors v WHERE v.business_name LIKE ? AND v.status='approved' LIMIT 3)
        ");
        $stmt->execute([$like, $like]);
        Response::json($stmt->fetchAll());
    }

    public function recommend(): void {
        $db         = Database::getInstance();
        $budget     = (float)Request::get('budget', 0);
        $categoryId = (int)Request::get('category_id');
        if (!$budget) Response::error('budget is required', 422);

        $cond = ["v.status='approved'", "fi.is_available=1", "fi.price <= ?"];
        $params = [$budget];
        if ($categoryId) { $cond[] = 'fi.category_id=?'; $params[] = $categoryId; }
        $where = 'WHERE ' . implode(' AND ', $cond);

        $sql = "SELECT fi.*, c.name as category_name, c.icon as category_icon, v.business_name as vendor_name, v.slug as vendor_slug, v.location as vendor_location, v.opening_time, v.closing_time FROM food_items fi JOIN vendors v ON v.id=fi.vendor_id JOIN categories c ON c.id=fi.category_id $where";

        $bestValue = $db->prepare("$sql ORDER BY fi.avg_rating DESC LIMIT 10");
        $bestValue->execute($params);

        $cheapest = $db->prepare("$sql ORDER BY fi.price ASC LIMIT 10");
        $cheapest->execute($params);

        Response::json([
            'budget' => $budget,
            'best_value' => $bestValue->fetchAll(),
            'cheapest' => $cheapest->fetchAll()
        ]);
    }

    public function compare(): void {
        $db  = Database::getInstance();
        $ids = array_filter(array_map('intval', explode(',', Request::get('ids', ''))));
        if (empty($ids)) Response::error('Provide food IDs', 422);

        $placeholders = implode(',', array_fill(0, count($ids), '?'));
        $stmt = $db->prepare("SELECT fi.*, c.name as category_name, v.business_name as vendor_name, v.slug as vendor_slug FROM food_items fi JOIN vendors v ON v.id=fi.vendor_id JOIN categories c ON c.id=fi.category_id WHERE fi.id IN ($placeholders)");
        $stmt->execute($ids);
        $items = $stmt->fetchAll();

        if ($items) {
            $minPrice = min(array_column($items, 'price'));
            foreach ($items as &$i) { 
                $i['is_cheapest'] = $i['price'] == $minPrice; 
            }
        }
        Response::json($items);
    }
}