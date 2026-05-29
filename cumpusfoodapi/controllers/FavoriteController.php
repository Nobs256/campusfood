<?php
class FavoriteController {
    private $auth;

    public function __construct(?array $auth)
    {
        $this->auth = $auth;
    }

    public function index(): void {
        $db = Database::getInstance();
        $stmt = $db->prepare("SELECT f.id as favorite_id, fi.*, v.business_name as vendor_name FROM favorites f JOIN food_items fi ON fi.id = f.food_id JOIN vendors v ON v.id = fi.vendor_id WHERE f.user_id = ? ORDER BY f.created_at DESC");
        $stmt->execute([$this->auth['uid']]);
        Response::json($stmt->fetchAll());
    }

    public function toggle(string $foodId): void {
        $db = Database::getInstance();
        $uid = $this->auth['uid'];
        $fid = (int)$foodId;

        $check = $db->prepare("SELECT id FROM favorites WHERE user_id = ? AND food_id = ?");
        $check->execute([$uid, $fid]);
        $fav = $check->fetch();

        if ($fav) {
            $db->prepare("DELETE FROM favorites WHERE id = ?")->execute([$fav['id']]);
            Response::json(['favorited' => false]);
        } else {
            $db->prepare("INSERT INTO favorites (user_id, food_id) VALUES (?, ?)")->execute([$uid, $fid]);
            Response::json(['favorited' => true]);
        }
    }
}