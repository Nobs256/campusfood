<?php
class CategoryController {
    private $auth;

    public function __construct(?array $auth)
    {
        $this->auth = $auth;
    }

    public function index(): void {
        $db   = Database::getInstance();
        $stmt = $db->query("SELECT * FROM categories ORDER BY sort_order ASC, name ASC");
        Response::json($stmt->fetchAll());
    }

    public function store(): void {
        $db   = Database::getInstance();
        $body = Request::json();
        $name = sanitize($body['name'] ?? '');
        $icon = sanitize($body['icon'] ?? '');
        $sort = (int)($body['sort_order'] ?? 0);

        if (!$name) Response::error('Category name required', 422);

        $db->prepare("INSERT INTO categories (name, icon, sort_order) VALUES (?,?,?)")
           ->execute([$name, $icon, $sort]);

        Response::json(['id' => $db->lastInsertId()], 201);
    }

    public function update(string $id): void {
        $db   = Database::getInstance();
        $body = Request::json();
        $name = sanitize($body['name'] ?? '');
        $icon = sanitize($body['icon'] ?? '');
        $sort = (int)($body['sort_order'] ?? 0);

        if (!$name) Response::error('Category name required', 422);

        $db->prepare("UPDATE categories SET name=?, icon=?, sort_order=? WHERE id=?")
           ->execute([$name, $icon, $sort, (int)$id]);

        Response::json(['updated' => true]);
    }

    public function destroy(string $id): void {
        $db = Database::getInstance();
        $db->prepare("DELETE FROM categories WHERE id=?")->execute([(int)$id]);
        Response::json(['deleted' => true]);
    }
}