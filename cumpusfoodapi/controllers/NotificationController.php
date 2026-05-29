<?php
class NotificationController {
    private $auth;

    public function __construct(?array $auth)
    {
        $this->auth = $auth;
    }

    public function index(): void {
        $db = Database::getInstance();
        $stmt = $db->prepare("SELECT * FROM notifications WHERE user_id = ? ORDER BY created_at DESC");
        $stmt->execute([$this->auth['uid']]);
        Response::json($stmt->fetchAll());
    }

    public function markRead(string $id): void {
        $db = Database::getInstance();
        $db->prepare("UPDATE notifications SET is_read = 1 WHERE id = ? AND user_id = ?")
           ->execute([(int)$id, $this->auth['uid']]);
        Response::json(['updated' => true]);
    }

    public function markAllRead(): void {
        $db = Database::getInstance();
        $db->prepare("UPDATE notifications SET is_read = 1 WHERE user_id = ?")->execute([$this->auth['uid']]);
        Response::json(['updated' => true]);
    }
}