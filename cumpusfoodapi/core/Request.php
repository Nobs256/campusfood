<?php
class Request {
    public static function json(): array {
        $body = file_get_contents('php://input');
        return json_decode($body, true) ?? [];
    }

    public static function get(string $key, $default = null) {
        return $_GET[$key] ?? $default;
    }
}