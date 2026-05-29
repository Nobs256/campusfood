<?php
class VendorController {
    private $auth;

    public function __construct(?array $auth)
    {
        $this->auth = $auth;
    }

    public function index(): void {
        $db     = Database::getInstance();
        $page   = max(1, (int)Request::get('page', 1));
        $perPage = ITEMS_PER_PAGE;

        $countStmt = $db->prepare("SELECT COUNT(*) FROM vendors WHERE status = 'approved'");
        $countStmt->execute();
        $total = (int)$countStmt->fetchColumn();

        $stmt = $db->prepare("
            SELECT v.*, 
            (SELECT COUNT(*) FROM food_items WHERE vendor_id = v.id) as food_count
            FROM vendors v 
            WHERE v.status = 'approved' 
            ORDER BY v.avg_rating DESC 
            LIMIT ? OFFSET ?
        ");
        $stmt->execute([$perPage, paginationOffset($page, $perPage)]);
        $vendors = $stmt->fetchAll();

        Response::paginated($vendors, $total, $page, $perPage);
    }

    public function show(string $id): void {
        $db = Database::getInstance();
        $stmt = $db->prepare("SELECT * FROM vendors WHERE id = ?");
        $stmt->execute([(int)$id]);
        $vendor = $stmt->fetch();

        if (!$vendor) Response::error('Vendor not found', 404);

        Response::json($vendor);
    }

    public function dashboard(): void {
        $db = Database::getInstance();
        $vStmt = $db->prepare("SELECT id, avg_rating, total_ratings FROM vendors WHERE user_id = ?");
        $vStmt->execute([$this->auth['uid']]);
        $vendor = $vStmt->fetch();
        
        if (!$vendor) Response::error('Vendor record not found', 404);
        $vendorId = $vendor['id'];

        // Fix: Execute statements separately to fetch columns correctly
        $totalStmt = $db->prepare("SELECT COUNT(*) FROM food_items WHERE vendor_id = ?");
        $totalStmt->execute([$vendorId]);
        $totalItems = (int)$totalStmt->fetchColumn();

        $availStmt = $db->prepare("SELECT COUNT(*) FROM food_items WHERE vendor_id = ? AND is_available = 1");
        $availStmt->execute([$vendorId]);
        $availItems = (int)$availStmt->fetchColumn();

        $viewStmt = $db->prepare("SELECT SUM(views) FROM food_items WHERE vendor_id = ?");
        $viewStmt->execute([$vendorId]);
        $totalViews = (int)$viewStmt->fetchColumn() ?? 0;

        // Fetch recent ratings as expected by the frontend
        $ratingStmt = $db->prepare("
            SELECT r.*, fi.name as food_name 
            FROM ratings r 
            JOIN food_items fi ON fi.id = r.food_id 
            WHERE fi.vendor_id = ? 
            ORDER BY r.created_at DESC 
            LIMIT 5
        ");
        $ratingStmt->execute([$vendorId]);
        $recentRatings = $ratingStmt->fetchAll();

        Response::json([
            'stats' => [
                'total_items'     => $totalItems,
                'available_items' => $availItems,
                'views_today'     => $totalViews,
                'avg_rating'      => (float)$vendor['avg_rating'],
                'total_ratings'   => (int)$vendor['total_ratings']
            ],
            'recent_ratings' => $recentRatings
        ]);
    }


    public function myMenu(): void {
        $db = Database::getInstance();
        $vStmt = $db->prepare("SELECT id FROM vendors WHERE user_id = ?");
        $vStmt->execute([$this->auth['uid']]);
        $vendorId = $vStmt->fetchColumn();

        if (!$vendorId) Response::error('Vendor record not found', 404);

        $stmt = $db->prepare("
            SELECT fi.*, c.name as category_name, c.icon as category_icon,
                   v.business_name AS vendor_name, v.slug AS vendor_slug
            FROM food_items fi 
            JOIN categories c ON c.id = fi.category_id 
            JOIN vendors v ON v.id = fi.vendor_id
            WHERE fi.vendor_id = ? ORDER BY fi.created_at DESC");
        $stmt->execute([$vendorId]);
        
        Response::json($stmt->fetchAll());
    }

    public function updateProfile(): void {
        $db = Database::getInstance();
        $body = Request::json();
        
        // $db->prepare("UPDATE vendors SET business_name = ?, description = ?, location = ?, phone = ?, whatsapp = ?, opening_time = ?, closing_time = ? WHERE user_id = ?")
        $db->prepare("UPDATE vendors SET description = ?, location = ?, phone = ?, whatsapp = ?, opening_time = ?, closing_time = ? WHERE user_id = ?")
           ->execute([
                // sanitize($body['business_name'] ?? ''), sanitize($body['description'] ?? ''), 
                sanitize($body['description'] ?? ''),
                sanitize($body['location'] ?? ''), sanitize($body['phone'] ?? ''), 
                sanitize($body['whatsapp'] ?? ''), $body['opening_time'] ?? null, 
                $body['closing_time'] ?? null, $this->auth['uid']
            ]);

        Response::json(['updated' => true]);
    }

    public function uploadImages(): void {
        $db = Database::getInstance();
        $profileUrl = null;
        $bannerUrl = null;

        try {
            if (!empty($_FILES['profile_image'])) {
                $profileUrl = uploadImage($_FILES['profile_image'], 'vendors');
                $db->prepare("UPDATE vendors SET profile_image = ? WHERE user_id = ?")->execute([$profileUrl, $this->auth['uid']]);
            }
            if (!empty($_FILES['banner_image'])) {
                $bannerUrl = uploadImage($_FILES['banner_image'], 'vendors');
                $db->prepare("UPDATE vendors SET banner_image = ? WHERE user_id = ?")->execute([$bannerUrl, $this->auth['uid']]);
            }
            Response::json(['profile_image' => $profileUrl, 'banner_image' => $bannerUrl]);
        } catch (Exception $e) {
            Response::error($e->getMessage(), 422);
        }
    }

    public function feedback(): void { Response::json([]); } // Placeholder for extended feedback logic
}