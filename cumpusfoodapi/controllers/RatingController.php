<?php
class RatingController {
    private $auth;

    public function __construct(?array $auth)
    {
        $this->auth = $auth;
    }

    public function index(string $foodId): void {
        $db = Database::getInstance();
        $dist = $db->prepare("SELECT stars, COUNT(*) AS count FROM ratings WHERE food_id=? GROUP BY stars ORDER BY stars DESC");
        $dist->execute([(int)$foodId]);
        
        $stmt = $db->prepare("SELECT r.*, u.full_name as reviewer_name FROM ratings r LEFT JOIN users u ON u.id=r.user_id WHERE r.food_id=? ORDER BY r.created_at DESC LIMIT 10");
        $stmt->execute([(int)$foodId]);

        Response::json([
            'distribution' => $dist->fetchAll(),
            'ratings'      => $stmt->fetchAll()
        ]);
    }

    public function store(string $foodId): void {
        $db   = Database::getInstance();
        $body = Request::json();
        $uid  = $this->auth['uid'] ?? null;
        $stars = (int)($body['stars'] ?? 0);

        if ($stars < 1 || $stars > 5) Response::error('Stars must be between 1 and 5', 422);

        $food = $db->prepare("SELECT vendor_id FROM food_items WHERE id=?"); 
        $food->execute([(int)$foodId]);
        $f = $food->fetch();
        if (!$f) Response::error('Food not found', 404);

        if ($uid) {
            $dup = $db->prepare("SELECT id FROM ratings WHERE food_id=? AND user_id=?");
            $dup->execute([(int)$foodId, $uid]);
            if ($dup->fetch()) Response::error('Already rated', 409);
        }

        $db->prepare("INSERT INTO ratings (food_id, vendor_id, user_id, ip_address, stars, comment) VALUES (?,?,?,?,?,?)")
           ->execute([(int)$foodId, $f['vendor_id'], $uid, $_SERVER['REMOTE_ADDR'] ?? '0.0.0.0', $stars, sanitize($body['comment'] ?? '')]);

        recalculateRatings($db, (int)$foodId);
        Response::json(['rated' => true], 201);
    }

    public function myRatings(): void {
        $db   = Database::getInstance();
        $stmt = $db->prepare("
            SELECT r.*, fi.name AS food_name, v.business_name AS vendor_name
            FROM ratings r
            JOIN food_items fi ON fi.id=r.food_id
            JOIN vendors v ON v.id=fi.vendor_id
            WHERE r.user_id=?
            ORDER BY r.created_at DESC
        ");
        $stmt->execute([$this->auth['uid']]);

        Response::json($stmt->fetchAll());
    }
}