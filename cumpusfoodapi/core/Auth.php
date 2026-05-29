<?php
use Firebase\JWT\JWT;

class Auth {
    public static function issueTokens(array $user): array {
        $now = time();
        $payload = [
            'iss'   => APP_URL,
            'iat'   => $now,
            'exp'   => $now + JWT_ACCESS_TTL,
            'uid'   => $user['id'],
            'role'  => $user['role'],
            'name'  => $user['full_name'],
            'email' => $user['email'],
        ];
        $accessToken  = JWT::encode($payload, JWT_SECRET, 'HS256');
        $refreshToken = bin2hex(random_bytes(64));

        $db = Database::getInstance();
        $db->prepare("INSERT INTO refresh_tokens (user_id, token, expires_at) VALUES (?,?,?)")
           ->execute([$user['id'], hash('sha256', $refreshToken), date('Y-m-d H:i:s', $now + JWT_REFRESH_TTL)]);

        return [
            'access_token'  => $accessToken,
            'refresh_token' => $refreshToken,
            'expires_in'    => JWT_ACCESS_TTL,
            'token_type'    => 'Bearer',
        ];
    }

    public static function verify(string $token): ?array {
        try {
            return (array) JWT::decode($token, JWT_SECRET, ['HS256']);
        } catch (Exception $e) {
            return null;
        }
    }

    public static function fromRequest(): ?array {
        $header = $_SERVER['HTTP_AUTHORIZATION'] ?? '';
        if (!preg_match('/Bearer\s+(.+)/i', $header, $m)) return null;
        return self::verify($m[1]);
    }

    public static function optional(): ?array {
        return self::fromRequest();
    }

    public static function required(): array {
        $auth = self::fromRequest();
        if (!$auth) Response::error('Unauthorized', 401);
        return $auth;
    }
}