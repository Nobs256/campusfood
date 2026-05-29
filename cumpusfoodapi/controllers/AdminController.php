<?php
class AdminController {
    private $auth;

    public function __construct(?array $auth)
    {
        $this->auth = $auth;
    }

    public function dashboard(): void {
        $db = Database::getInstance();
        Response::json([
            'stats' => [
                'approved_vendors' => (int)($db->query("SELECT COUNT(*) FROM vendors WHERE status='approved'")->fetchColumn() ?: 0),
                'pending_vendors'  => (int)($db->query("SELECT COUNT(*) FROM vendors WHERE status='pending'")->fetchColumn() ?: 0),
                'students'         => (int)($db->query("SELECT COUNT(*) FROM users WHERE role='student'")->fetchColumn() ?: 0),
                'food_items'       => (int)($db->query("SELECT COUNT(*) FROM food_items")->fetchColumn() ?: 0),
            ],
            'pending_vendors' => $db->query("SELECT v.id, v.business_name, v.location, u.full_name, u.email FROM vendors v JOIN users u ON u.id=v.user_id WHERE v.status='pending' LIMIT 10")->fetchAll() ?: []
        ]);
    }

    public function vendors(): void {
        $db     = Database::getInstance();
        $status = Request::get('status', '');
        $page   = max(1, (int)Request::get('page', 1));
        $perPage = ITEMS_PER_PAGE;

        $cond   = $status ? "WHERE v.status=?" : "WHERE 1";
        
        // Count total for pagination meta
        $countStmt = $db->prepare("SELECT COUNT(*) FROM vendors v $cond");
        $countStmt->execute($status ? [$status] : []);
        $total = (int)$countStmt->fetchColumn();

        // Fetch vendors with owner email (required by frontend)
        $stmt = $db->prepare("
            SELECT v.*, u.full_name, u.email as owner_email 
            FROM vendors v 
            JOIN users u ON u.id=v.user_id 
            $cond 
            ORDER BY v.created_at DESC 
            LIMIT ? OFFSET ?
        ");
        $params = $status ? [$status] : [];
        $params[] = $perPage;
        $params[] = paginationOffset($page, $perPage);
        
        $stmt->execute($params);
        Response::paginated($stmt->fetchAll(), $total, $page, $perPage);
    }

    public function vendorAction(string $id): void {
        $db     = Database::getInstance();
        $body   = Request::json();
        $action = sanitize($body['action'] ?? '');
        
        $statusMap = ['approve'=>'approved','reject'=>'rejected','block'=>'blocked','unblock'=>'approved'];
        if (!isset($statusMap[$action])) Response::error('Invalid action', 422);

        $db->prepare("UPDATE vendors SET status=? WHERE id=?")->execute([$statusMap[$action], (int)$id]);
        
        $vStmt = $db->prepare("SELECT user_id, business_name FROM vendors WHERE id=?");
        $vStmt->execute([(int)$id]);
        $v = $vStmt->fetch();

        if (!$v) Response::error('Vendor not found', 404);

        $db->prepare("INSERT INTO notifications (user_id, title, message, type) VALUES (?,?,?,?)")
           ->execute([$v['user_id'], 'Account Update', "Your vendor account status is now: " . $statusMap[$action], 'info']);

        Response::json(['new_status' => $statusMap[$action]]);
    }

    public function reports(): void {
        $db = Database::getInstance();
        Response::json([
            'top_viewed' => $db->query("SELECT name, views FROM food_items ORDER BY views DESC LIMIT 10")->fetchAll() ?: [],
            'top_rated'  => $db->query("SELECT name, avg_rating FROM food_items WHERE total_ratings > 0 ORDER BY avg_rating DESC LIMIT 10")->fetchAll() ?: [],
            'category_stats' => $db->query("SELECT c.name, COUNT(fi.id) as item_count FROM categories c LEFT JOIN food_items fi ON fi.category_id = c.id GROUP BY c.id")->fetchAll() ?: [],
            'vendor_stats' => $db->query("SELECT business_name, (SELECT COUNT(*) FROM food_items WHERE vendor_id = v.id) as food_count, avg_rating FROM vendors v WHERE status='approved' ORDER BY avg_rating DESC LIMIT 10")->fetchAll() ?: []
        ]);
    }

    public function students(): void {
        $db = Database::getInstance();
        Response::json($db->query("SELECT id, full_name, email, is_active FROM users WHERE role='student' ORDER BY created_at DESC")->fetchAll());
    }

    public function toggleStudent(string $id): void {
        $db = Database::getInstance();
        $db->prepare("UPDATE users SET is_active = NOT is_active WHERE id=? AND role='student'")->execute([(int)$id]);
        Response::json(['toggled' => true]);
    }

    public function exportCsv(): void {
        $db   = Database::getInstance();
        $stmt = $db->query("SELECT fi.name, fi.price, v.business_name FROM food_items fi JOIN vendors v ON v.id=fi.vendor_id");
        $rows = $stmt->fetchAll();

        header('Content-Type: text/csv');
        header('Content-Disposition: attachment; filename="report.csv"');
        $out = fopen('php://output', 'w');
        fputcsv($out, ['Food Name', 'Price', 'Vendor']);
        foreach ($rows as $r) { fputcsv($out, [$r['name'], $r['price'], $r['business_name']]); }
        fclose($out);
        exit;
    }

    public function vendorDetail(string $id): void {
        $db = Database::getInstance();
        $stmt = $db->prepare("SELECT v.*, u.full_name, u.email FROM vendors v JOIN users u ON u.id=v.user_id WHERE v.id = ?");
        $stmt->execute([(int)$id]);
        $vendor = $stmt->fetch();

        if (!$vendor) Response::error('Vendor not found', 404);

        $foodStmt = $db->prepare("SELECT fi.*, c.name as category_name FROM food_items fi JOIN categories c ON c.id = fi.category_id WHERE fi.vendor_id = ?");
        $foodStmt->execute([(int)$id]);
        $vendor['foods'] = $foodStmt->fetchAll();

        Response::json($vendor);
    }
}