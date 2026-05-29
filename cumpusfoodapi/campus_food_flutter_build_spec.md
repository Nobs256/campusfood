# Build Specification: BSU FoodHub — Campus Food Information System
# Bishop Stuart University
# (Revised: Flutter Mobile App + PHP REST API + MySQL)

> **For AI Agent Use:** This is the single source of truth for BSU FoodHub. Read every section fully before writing any code. Build in the phase order defined at the end. Never skip a phase. The backend is a PHP REST API. The frontend is Flutter. They communicate exclusively via JSON over HTTPS.

---

## 1. Project Overview

**App Name:** BSU FoodHub  
**Institution:** Bishop Stuart University (BSU)  
**Mobile Platform:** Flutter (iOS + Android)  
**Backend:** PHP 7.4+ REST API (pure PHP with PDO — no framework)  
**Database:** MySQL 8.0+  
**Auth:** JWT (JSON Web Tokens) for vendor/student/admin; guest browsing without a token  
**File Storage:** Local server filesystem served via PHP  
**Purpose:** A centralized food discovery app where registered restaurants/vendors manage menus, and students browse, compare prices, get budget recommendations, and leave ratings.

### No ordering. No payments. Information + discovery only.

### Architecture
```
┌──────────────────┐       HTTPS/JSON        ┌─────────────────────────┐
│  Flutter App     │ ◄──────────────────────► │  PHP REST API           │
│  (iOS/Android)   │                          │  /api/v1/...            │
│                  │                          ├─────────────────────────┤
│  Guest browsing  │                          │  MySQL 8.0+             │
│  (no token)      │                          │  bsu_foodhub database   │
│                  │                          ├─────────────────────────┤
│  Vendor login    │                          │  /uploads/              │
│  Student login   │                          │  (images served via PHP)│
│  Admin login     │                          └─────────────────────────┘
└──────────────────┘
```

### User Roles
| Role | Can do |
|------|--------|
| **Guest** | Browse vendors, view foods, search, filter, compare, budget recommend |
| **Student** | Guest + register/login, save favorites, submit ratings + comments |
| **Vendor** | Register, manage own menu (add/edit/delete foods), toggle availability, view feedback |
| **Admin** | Approve/reject/block vendors, manage categories, view all reports |

---

## 2. Tech Stack

### PHP Backend
- **PHP:** 7.4+
- **Database:** MySQL 8.0+ via PDO
- **Auth:** JWT — `firebase/php-jwt` via Composer
- **No framework:** Pure PHP, class-based controllers
- **Image serving:** PHP file endpoint (no direct `/uploads/` access)

### Flutter Frontend
- **Flutter SDK:** Latest stable (≥ 3.19)
- **State Management:** Riverpod
- **Navigation:** GoRouter
- **HTTP:** Dio with JWT interceptor
- **Secure storage:** flutter_secure_storage
- **UI:** Custom widgets — no UI kits

### Flutter Packages
```yaml
dependencies:
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5
  go_router: ^13.2.0
  dio: ^5.4.3
  flutter_secure_storage: ^9.0.0
  intl: ^0.19.0
  image_picker: ^1.0.7
  cached_network_image: ^3.3.1
  fl_chart: ^0.67.0
  shimmer: ^3.0.0
  gap: ^3.0.1
  timeago: ^3.6.1
  logger: ^2.2.0
  freezed_annotation: ^2.4.1
  json_annotation: ^4.9.0
  share_plus: ^9.0.0

dev_dependencies:
  build_runner: ^2.4.9
  riverpod_generator: ^2.3.11
  freezed: ^2.5.2
  json_serializable: ^6.8.0
  flutter_lints: ^3.0.0
```

### PHP Composer Packages
```json
{
  "require": {
    "firebase/php-jwt": "^6.10",
    "vlucas/phpdotenv": "^5.6"
    "firebase/php-jwt": "^5.5",
    "vlucas/phpdotenv": "^4.2"
  }
}
```

---

## 3. PHP Backend — Project Structure

```
cumpusfoodapi/
├── composer.json
├── vendor/
├── .env
├── .env.example
├── .htaccess
├── index.php                        # Router entry point
├── config/
│   └── config.php                   # Load .env, constants
├── core/
│   ├── Database.php                 # PDO singleton
│   ├── Router.php                   # URL pattern matcher
│   ├── Request.php                  # JSON body + query param helpers
│   ├── Response.php                 # json(), error(), paginated()
│   ├── Auth.php                     # JWT issue + verify
│   ├── Upload.php                   # Image upload + MIME validation
│   └── Helpers.php                  # sanitize(), recalculateRatings(), etc.
├── middleware/
│   ├── AuthMiddleware.php           # requireAuth() — verifies JWT
│   └── RoleMiddleware.php           # requireRole('admin') etc.
├── controllers/
│   ├── AuthController.php
│   ├── VendorController.php
│   ├── FoodController.php
│   ├── CategoryController.php
│   ├── RatingController.php
│   ├── FavoriteController.php
│   ├── NotificationController.php
│   ├── SearchController.php
│   └── AdminController.php
├── uploads/
│   ├── vendors/                     # Vendor profile + banner images
│   └── foods/                       # Food item images
└── database/
    ├── schema.sql
    └── seed.sql
```

---

## 4. MySQL Database Schema

> Run all SQL in order. All tables InnoDB, utf8mb4.

```sql
CREATE DATABASE IF NOT EXISTS bsu_foodhub CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE bsu_foodhub;
```

### 4.1 `users`
```sql
CREATE TABLE users (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  full_name   VARCHAR(150) NOT NULL,
  email       VARCHAR(150) NOT NULL UNIQUE,
  password    VARCHAR(255) NOT NULL,
  role        ENUM('admin','vendor','student') NOT NULL DEFAULT 'student',
  phone       VARCHAR(20),
  avatar_url  VARCHAR(255),
  is_active   TINYINT(1) DEFAULT 1,
  last_login  DATETIME,
  created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### 4.2 `vendors`
```sql
CREATE TABLE vendors (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  user_id         INT NOT NULL UNIQUE,
  business_name   VARCHAR(200) NOT NULL,
  slug            VARCHAR(200) NOT NULL UNIQUE,
  description     TEXT,
  location        VARCHAR(255) NOT NULL,
  phone           VARCHAR(20),
  whatsapp        VARCHAR(20),
  opening_time    TIME,
  closing_time    TIME,
  profile_image   VARCHAR(255),
  banner_image    VARCHAR(255),
  status          ENUM('pending','approved','rejected','blocked') DEFAULT 'pending',
  avg_rating      DECIMAL(3,2) DEFAULT 0.00,
  total_ratings   INT DEFAULT 0,
  created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

### 4.3 `categories`
```sql
CREATE TABLE categories (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(100) NOT NULL UNIQUE,
  icon        VARCHAR(10),
  sort_order  INT DEFAULT 0,
  created_at  DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO categories (name, icon, sort_order) VALUES
  ('Local Dishes','🍚',1), ('Breakfast','🍳',2), ('Beverages','☕',3),
  ('Snacks','🥪',4), ('Fast Food','🍟',5), ('Fruits','🍎',6),
  ('Vegetarian','🥗',7), ('Specials','⭐',8);
```

### 4.4 `food_items`
```sql
CREATE TABLE food_items (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  vendor_id     INT NOT NULL,
  category_id   INT NOT NULL,
  name          VARCHAR(200) NOT NULL,
  description   TEXT,
  price         DECIMAL(10,2) NOT NULL,
  image_url     VARCHAR(255),
  is_available  TINYINT(1) DEFAULT 1,
  is_featured   TINYINT(1) DEFAULT 0,
  serving_size  VARCHAR(100),
  calories      INT,
  tags          VARCHAR(255),
  avg_rating    DECIMAL(3,2) DEFAULT 0.00,
  total_ratings INT DEFAULT 0,
  views         INT DEFAULT 0,
  created_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (vendor_id) REFERENCES vendors(id) ON DELETE CASCADE,
  FOREIGN KEY (category_id) REFERENCES categories(id),
  INDEX idx_vendor_available (vendor_id, is_available),
  INDEX idx_price (price),
  FULLTEXT idx_search (name, description, tags)
);
```

### 4.5 `ratings`
```sql
CREATE TABLE ratings (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  food_id     INT NOT NULL,
  vendor_id   INT NOT NULL,
  user_id     INT,
  ip_address  VARCHAR(45),
  stars       TINYINT NOT NULL CHECK (stars BETWEEN 1 AND 5),
  comment     TEXT,
  created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY unique_user_food (user_id, food_id),
  FOREIGN KEY (food_id) REFERENCES food_items(id) ON DELETE CASCADE,
  FOREIGN KEY (vendor_id) REFERENCES vendors(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);
```

### 4.6 `favorites`
```sql
CREATE TABLE favorites (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  user_id     INT NOT NULL,
  food_id     INT NOT NULL,
  created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY unique_fav (user_id, food_id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (food_id) REFERENCES food_items(id) ON DELETE CASCADE
);
```

### 4.7 `notifications`
```sql
CREATE TABLE notifications (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  user_id     INT NOT NULL,
  title       VARCHAR(200) NOT NULL,
  message     TEXT NOT NULL,
  type        ENUM('approval','rejection','warning','info') DEFAULT 'info',
  is_read     TINYINT(1) DEFAULT 0,
  created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

### 4.8 `item_views`
```sql
CREATE TABLE item_views (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  food_id     INT,
  vendor_id   INT,
  ip_address  VARCHAR(45),
  viewed_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (food_id) REFERENCES food_items(id) ON DELETE SET NULL,
  FOREIGN KEY (vendor_id) REFERENCES vendors(id) ON DELETE SET NULL
);
```

### 4.9 `refresh_tokens`
```sql
CREATE TABLE refresh_tokens (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  user_id     INT NOT NULL,
  token       VARCHAR(512) NOT NULL UNIQUE,
  expires_at  DATETIME NOT NULL,
  revoked     TINYINT(1) DEFAULT 0,
  created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

---

## 5. PHP Backend — Core Files

### 5.1 `.env`
```ini
APP_URL=https://api.yourdomain.com

DB_HOST=localhost
DB_NAME=bsu_foodhub
DB_USER=root
DB_PASS=your_password

JWT_SECRET=your_64_char_random_secret_here
JWT_ACCESS_TTL=900
JWT_REFRESH_TTL=2592000

UPLOAD_PATH=/var/www/bsu-foodhub-api/uploads
UPLOAD_URL=https://api.yourdomain.com/uploads
MAX_UPLOAD_MB=3
```

### 5.2 `config/config.php`
```php
<?php
require_once __DIR__ . '/../vendor/autoload.php';
$dotenv = Dotenv\Dotenv::createImmutable(__DIR__ . '/..');
$dotenv->load();

define('APP_URL',         $_ENV['APP_URL']);
define('JWT_SECRET',      $_ENV['JWT_SECRET']);
define('JWT_ACCESS_TTL',  (int)$_ENV['JWT_ACCESS_TTL']);
define('JWT_REFRESH_TTL', (int)$_ENV['JWT_REFRESH_TTL']);
define('UPLOAD_PATH',     $_ENV['UPLOAD_PATH']);
define('UPLOAD_URL',      $_ENV['UPLOAD_URL']);
define('MAX_UPLOAD_BYTES',(int)$_ENV['MAX_UPLOAD_MB'] * 1024 * 1024);
define('ITEMS_PER_PAGE',  15);
```

### 5.3 `core/Database.php`
```php
<?php
class Database {
    private static ?PDO $instance = null;
    public static function getInstance(): PDO {
        if (self::$instance === null) {
            $dsn = "mysql:host={$_ENV['DB_HOST']};dbname={$_ENV['DB_NAME']};charset=utf8mb4";
            self::$instance = new PDO($dsn, $_ENV['DB_USER'], $_ENV['DB_PASS'], [
                PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_EMULATE_PREPARES   => false,
            ]);
        }
        return self::$instance;
    }
}
```

### 5.4 `core/Auth.php`
```php
<?php
use Firebase\JWT\JWT;
use Firebase\JWT\Key;

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
            return (array) JWT::decode($token, new Key(JWT_SECRET, 'HS256'));
        } catch (Exception) {
            return null;
        }
    }

    public static function fromRequest(): ?array {
        $header = $_SERVER['HTTP_AUTHORIZATION'] ?? '';
        if (!preg_match('/Bearer\s+(.+)/i', $header, $m)) return null;
        return self::verify($m[1]);
    }

    // Optional auth — returns token data if present, null if not (for guest endpoints)
    public static function optional(): ?array {
        return self::fromRequest();
    }

    // Strict auth — returns token data or sends 401
    public static function required(): array {
        $auth = self::fromRequest();
        if (!$auth) Response::error('Unauthorized', 401);
        return $auth;
    }
}
```

### 5.5 `core/Response.php`
```php
<?php
class Response {
    public static function json(mixed $data, int $code = 200): never {
        http_response_code($code);
        header('Content-Type: application/json');
        echo json_encode(['success' => true, 'data' => $data]);
        exit;
    }
    public static function error(string $message, int $code = 400, array $errors = []): never {
        http_response_code($code);
        header('Content-Type: application/json');
        echo json_encode(['success' => false, 'message' => $message, 'errors' => $errors]);
        exit;
    }
    public static function paginated(array $data, int $total, int $page, int $perPage): never {
        http_response_code(200);
        header('Content-Type: application/json');
        echo json_encode([
            'success' => true,
            'data'    => $data,
            'meta'    => [
                'total'     => $total,
                'page'      => $page,
                'per_page'  => $perPage,
                'last_page' => (int)ceil($total / $perPage),
            ],
        ]);
        exit;
    }
}
```

### 5.6 `core/Helpers.php`
```php
<?php
function sanitize(string $v): string {
    return htmlspecialchars(strip_tags(trim($v)), ENT_QUOTES, 'UTF-8');
}

function validateRequired(array $data, array $fields): array {
    return array_filter($fields, fn($f) => empty(trim((string)($data[$f] ?? ''))));
}

function generateSlug(PDO $db, string $name): string {
    $base = strtolower(preg_replace('/[^a-z0-9]+/i', '-', trim($name)));
    $slug = trim($base, '-');
    $i    = 1;
    while ($db->prepare("SELECT id FROM vendors WHERE slug=?")->execute([$slug])->fetch()) {
        $slug = $base . '-' . $i++;
    }
    return $slug;
}

function recalculateRatings(PDO $db, int $foodId): void {
    $db->prepare("
        UPDATE food_items
        SET avg_rating    = (SELECT COALESCE(AVG(stars),0) FROM ratings WHERE food_id=?),
            total_ratings = (SELECT COUNT(*) FROM ratings WHERE food_id=?)
        WHERE id = ?
    ")->execute([$foodId, $foodId, $foodId]);

    // Recalculate vendor avg rating
    $row = $db->prepare("SELECT vendor_id FROM food_items WHERE id=?");
    $row->execute([$foodId]);
    $r = $row->fetch();
    if ($r) {
        $db->prepare("
            UPDATE vendors
            SET avg_rating    = (SELECT COALESCE(AVG(avg_rating),0) FROM food_items WHERE vendor_id=? AND total_ratings > 0),
                total_ratings = (SELECT COALESCE(SUM(total_ratings),0) FROM food_items WHERE vendor_id=?)
            WHERE id = ?
        ")->execute([$r['vendor_id'], $r['vendor_id'], $r['vendor_id']]);
    }
}

function recordView(PDO $db, ?int $foodId, ?int $vendorId, string $ip): void {
    $db->prepare("INSERT INTO item_views (food_id, vendor_id, ip_address) VALUES (?,?,?)")
       ->execute([$foodId, $vendorId, $ip]);
    if ($foodId) $db->prepare("UPDATE food_items SET views = views + 1 WHERE id=?")->execute([$foodId]);
}

function isVendorOpen(string $open, string $close): bool {
    $now = date('H:i');
    return $open && $close && $now >= $open && $now <= $close;
}

function formatPrice(float $price): string {
    return number_format($price, 0) . ' UGX';
}

function paginationOffset(int $page, int $perPage = 15): int {
    return max(0, ($page - 1) * $perPage);
}
```

### 5.7 `core/Upload.php`
```php
<?php
function uploadImage(array $file, string $subfolder): string {
    if ($file['error'] !== UPLOAD_ERR_OK) throw new Exception('Upload error');
    if ($file['size'] > MAX_UPLOAD_BYTES)  throw new Exception('File exceeds ' . (MAX_UPLOAD_BYTES/1024/1024) . 'MB limit');

    $finfo   = new finfo(FILEINFO_MIME_TYPE);
    $mime    = $finfo->file($file['tmp_name']);
    $allowed = ['image/jpeg' => 'jpg', 'image/png' => 'png', 'image/webp' => 'webp'];
    if (!isset($allowed[$mime])) throw new Exception('Invalid file type. JPEG, PNG or WebP only.');

    $dir  = UPLOAD_PATH . '/' . $subfolder;
    if (!is_dir($dir)) mkdir($dir, 0755, true);

    $name = uniqid('img_', true) . '.' . $allowed[$mime];
    if (!move_uploaded_file($file['tmp_name'], "$dir/$name"))
        throw new Exception('Failed to save file');

    return UPLOAD_URL . '/' . $subfolder . '/' . $name;
}

function deleteImage(string $url): void {
    $path = str_replace(UPLOAD_URL, UPLOAD_PATH, $url);
    if (file_exists($path)) unlink($path);
}
```

### 5.8 `index.php` — Router
```php
<?php
require_once 'config/config.php';
require_once 'core/Database.php';
require_once 'core/Auth.php';
require_once 'core/Request.php';
require_once 'core/Response.php';
require_once 'core/Helpers.php';
require_once 'core/Upload.php';

// CORS
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, PATCH, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') { http_response_code(204); exit; }

$uri    = preg_replace('#^/api/v1#', '', strtok(parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH), '?'));
$method = $_SERVER['REQUEST_METHOD'];

// Route table: [METHOD, pattern, controller, action, auth_required, roles]
// roles=[] means any authenticated user; roles=['*'] means guest allowed
$routes = [
  // ── Auth (public) ──────────────────────────────────────────────────
  ['POST', '/auth/login',              'AuthController',        'login',            false, []],
  ['POST', '/auth/register',           'AuthController',        'register',         false, []],
  ['POST', '/auth/refresh',            'AuthController',        'refresh',          false, []],
  ['POST', '/auth/logout',             'AuthController',        'logout',           true,  []],
  ['POST', '/auth/change-password',    'AuthController',        'changePassword',   true,  []],

  // ── Vendors (public read) ───────────────────────────────────────────
  ['GET',  '/vendors',                 'VendorController',      'index',            false, []],
  ['GET',  '/vendors/{id}',            'VendorController',      'show',             false, []],
  ['POST', '/vendors',                 'VendorController',      'store',            false, []],  // self-register
  ['PUT',  '/vendors/me',              'VendorController',      'updateProfile',    true,  ['vendor']],
  ['POST', '/vendors/me/images',       'VendorController',      'uploadImages',     true,  ['vendor']],

  // ── Food Items (public read) ────────────────────────────────────────
  ['GET',  '/foods',                   'FoodController',        'index',            false, []],
  ['GET',  '/foods/featured',          'FoodController',        'featured',         false, []],
  ['GET',  '/foods/{id}',              'FoodController',        'show',             false, []],
  ['POST', '/foods',                   'FoodController',        'store',            true,  ['vendor']],
  ['PUT',  '/foods/{id}',              'FoodController',        'update',           true,  ['vendor']],
  ['DELETE','/foods/{id}',             'FoodController',        'destroy',          true,  ['vendor']],
  ['PATCH','/foods/{id}/availability', 'FoodController',        'toggleAvailability',true, ['vendor']],

  // ── Vendor Dashboard ────────────────────────────────────────────────
  ['GET',  '/vendor/dashboard',        'VendorController',      'dashboard',        true,  ['vendor']],
  ['GET',  '/vendor/menu',             'VendorController',      'myMenu',           true,  ['vendor']],
  ['GET',  '/vendor/feedback',         'VendorController',      'feedback',         true,  ['vendor']],
  ['GET',  '/vendor/notifications',    'VendorController',      'notifications',    true,  ['vendor']],

  // ── Categories (public read) ────────────────────────────────────────
  ['GET',  '/categories',              'CategoryController',    'index',            false, []],
  ['POST', '/categories',              'CategoryController',    'store',            true,  ['admin']],
  ['PUT',  '/categories/{id}',         'CategoryController',    'update',           true,  ['admin']],
  ['DELETE','/categories/{id}',        'CategoryController',    'destroy',          true,  ['admin']],

  // ── Search & Discover ───────────────────────────────────────────────
  ['GET',  '/search',                  'SearchController',      'search',           false, []],
  ['GET',  '/search/autocomplete',     'SearchController',      'autocomplete',     false, []],
  ['GET',  '/recommend',               'SearchController',      'recommend',        false, []],
  ['GET',  '/compare',                 'SearchController',      'compare',          false, []],

  // ── Ratings ─────────────────────────────────────────────────────────
  ['GET',  '/foods/{id}/ratings',      'RatingController',      'index',            false, []],
  ['POST', '/foods/{id}/ratings',      'RatingController',      'store',            false, []],  // guest or student

  // ── Favorites ───────────────────────────────────────────────────────
  ['GET',  '/favorites',               'FavoriteController',    'index',            true,  ['student']],
  ['POST', '/favorites/{foodId}',      'FavoriteController',    'toggle',           true,  ['student']],

  // ── Student ─────────────────────────────────────────────────────────
  ['GET',  '/student/profile',         'AuthController',        'profile',          true,  ['student']],
  ['PUT',  '/student/profile',         'AuthController',        'updateProfile',    true,  ['student']],
  ['GET',  '/student/ratings',         'RatingController',      'myRatings',        true,  ['student']],

  // ── Notifications ───────────────────────────────────────────────────
  ['GET',  '/notifications',           'NotificationController','index',            true,  []],
  ['POST', '/notifications/{id}/read', 'NotificationController','markRead',         true,  []],
  ['POST', '/notifications/read-all',  'NotificationController','markAllRead',      true,  []],

  // ── Admin ───────────────────────────────────────────────────────────
  ['GET',  '/admin/dashboard',         'AdminController',       'dashboard',        true,  ['admin']],
  ['GET',  '/admin/vendors',           'AdminController',       'vendors',          true,  ['admin']],
  ['GET',  '/admin/vendors/{id}',      'AdminController',       'vendorDetail',     true,  ['admin']],
  ['POST', '/admin/vendors/{id}/action','AdminController',      'vendorAction',     true,  ['admin']],
  ['GET',  '/admin/students',          'AdminController',       'students',         true,  ['admin']],
  ['POST', '/admin/students/{id}/toggle','AdminController',     'toggleStudent',    true,  ['admin']],
  ['GET',  '/admin/reports',           'AdminController',       'reports',          true,  ['admin']],
  ['GET',  '/admin/reports/export',    'AdminController',       'exportCsv',        true,  ['admin']],
];

foreach ($routes as [$rm, $pattern, $ctrl, $action, $needsAuth, $roles]) {
    $regex = '#^' . preg_replace('#\{[^}]+\}#', '([^/]+)', $pattern) . '$#';
    if ($method !== $rm || !preg_match($regex, $uri, $matches)) continue;
    array_shift($matches);

    $auth = null;
    if ($needsAuth) {
        $auth = Auth::required();
        if ($roles && $roles !== ['*'] && !in_array($auth['role'], $roles))
            Response::error('Forbidden', 403);
    }

    require_once "controllers/{$ctrl}.php";
    $instance = new $ctrl($auth);
    call_user_func_array([$instance, $action], $matches);
    exit;
}

Response::error('Not found', 404);
```

### 5.9 `.htaccess`
```apache
Options -Indexes
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^(.*)$ index.php [L,QSA]
Header set X-Content-Type-Options "nosniff"
Header set X-Frame-Options "DENY"
```

---

## 6. API Endpoints Reference

All endpoints prefixed `/api/v1`. Responses always JSON.

### Auth
| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| POST | `/auth/login` | None | Login → access_token + refresh_token + user |
| POST | `/auth/register` | None | Student or vendor self-registration |
| POST | `/auth/refresh` | None | Refresh access token |
| POST | `/auth/logout` | JWT | Revoke refresh token |
| POST | `/auth/change-password` | JWT | Update password |

### Vendors & Foods (Public)
| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/vendors?status=approved&page=1` | None | List approved vendors |
| GET | `/vendors/{id}` | None | Vendor profile + open/closed status |
| GET | `/foods?vendor_id=X&category_id=X&page=1` | None | List food items |
| GET | `/foods/featured` | None | Featured food strip |
| GET | `/foods/{id}` | None | Full food detail + vendor info |

### Search & Discovery (Public)
| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/search?q=chapati&category_id=2&min_price=1000&max_price=5000&available=1&sort=price_asc` | None | Full search + filter |
| GET | `/search/autocomplete?q=mat` | None | Autocomplete suggestions |
| GET | `/recommend?budget=3000&category_id=1` | None | Budget-based food list |
| GET | `/compare?ids=1,2,3,4` | None | Side-by-side comparison data |

### Ratings (Guests + Students)
| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/foods/{id}/ratings?page=1` | None | Paginated ratings for a food |
| POST | `/foods/{id}/ratings` | Optional | Submit rating (student: by user_id; guest: by IP) |

### Student
| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/favorites` | student | My saved food items |
| POST | `/favorites/{foodId}` | student | Toggle favorite (add/remove) |
| GET | `/student/profile` | student | My profile |
| PUT | `/student/profile` | student | Update profile |
| GET | `/student/ratings` | student | My submitted ratings |

### Vendor
| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| POST | `/vendors` | None | Register new vendor (status=pending) |
| GET | `/vendor/dashboard` | vendor | Stats: views, items, ratings |
| GET | `/vendor/menu` | vendor | My food items list |
| POST | `/foods` | vendor | Add food item |
| PUT | `/foods/{id}` | vendor | Edit food item |
| DELETE | `/foods/{id}` | vendor | Delete food item |
| PATCH | `/foods/{id}/availability` | vendor | Toggle available/sold out |
| PUT | `/vendors/me` | vendor | Edit vendor profile |
| POST | `/vendors/me/images` | vendor | Upload profile/banner images |
| GET | `/vendor/feedback` | vendor | All ratings on my food |
| GET | `/vendor/notifications` | vendor | Admin notifications (approval, etc.) |

### Admin
| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/admin/dashboard` | admin | Platform-wide stats |
| GET | `/admin/vendors?status=pending` | admin | Vendor list with filters |
| GET | `/admin/vendors/{id}` | admin | Full vendor detail |
| POST | `/admin/vendors/{id}/action` | admin | approve / reject / block / unblock |
| GET | `/admin/students` | admin | Student list |
| POST | `/admin/students/{id}/toggle` | admin | Activate/deactivate student |
| GET | `/admin/reports` | admin | Report data (views, ratings, top foods) |
| GET | `/admin/reports/export` | admin | Download CSV |
| GET | `/categories` | None | List categories |
| POST | `/categories` | admin | Add category |
| PUT | `/categories/{id}` | admin | Edit category |
| DELETE | `/categories/{id}` | admin | Delete category |

---

## 7. Key Controller Implementations

### 7.1 `controllers/AuthController.php`
```php
<?php
class AuthController {
    public function __construct(private ?array $auth) {}

    public function login(): void {
        $body  = Request::json();
        $email = sanitize($body['email'] ?? '');
        $pass  = $body['password'] ?? '';
        if (!$email || !$pass) Response::error('Email and password required', 422);

        $db   = Database::getInstance();
        $stmt = $db->prepare("SELECT * FROM users WHERE email=? AND is_active=1");
        $stmt->execute([$email]);
        $user = $stmt->fetch();

        if (!$user || !password_verify($pass, $user['password']))
            Response::error('Invalid email or password', 401);

        // If vendor, load vendor data too
        $vendorData = null;
        if ($user['role'] === 'vendor') {
            $vs = $db->prepare("SELECT * FROM vendors WHERE user_id=?");
            $vs->execute([$user['id']]);
            $vendorData = $vs->fetch();
        }

        $db->prepare("UPDATE users SET last_login=NOW() WHERE id=?")->execute([$user['id']]);
        $tokens = Auth::issueTokens($user);
        unset($user['password']);

        Response::json([...$tokens, 'user' => $user, 'vendor' => $vendorData]);
    }

    public function register(): void {
        $db   = Database::getInstance();
        $body = Request::json();
        $type = sanitize($body['type'] ?? '');  // 'student' or 'vendor'

        $missing = validateRequired($body, ['full_name','email','password','type']);
        if ($missing) Response::error('Missing fields: ' . implode(', ', $missing), 422);
        if (!in_array($type, ['student','vendor'])) Response::error('type must be student or vendor', 422);
        if (strlen($body['password']) < 8) Response::error('Password must be at least 8 characters', 422);

        // Check email unique
        $ex = $db->prepare("SELECT id FROM users WHERE email=?");
        $ex->execute([sanitize($body['email'])]);
        if ($ex->fetch()) Response::error('Email already registered', 409);

        $db->prepare("INSERT INTO users (full_name, email, password, role, phone) VALUES (?,?,?,?,?)")
           ->execute([sanitize($body['full_name']), sanitize($body['email']), password_hash($body['password'], PASSWORD_BCRYPT, ['cost'=>12]), $type, sanitize($body['phone'] ?? '')]);
        $userId = $db->lastInsertId();

        if ($type === 'vendor') {
            $missing2 = validateRequired($body, ['business_name','location']);
            if ($missing2) Response::error('Vendor requires business_name and location', 422);
            $slug = generateSlug($db, $body['business_name']);
            $db->prepare("INSERT INTO vendors (user_id, business_name, slug, description, location, phone, whatsapp, opening_time, closing_time) VALUES (?,?,?,?,?,?,?,?,?)")
               ->execute([$userId, sanitize($body['business_name']), $slug, sanitize($body['description'] ?? ''), sanitize($body['location']), sanitize($body['phone'] ?? ''), sanitize($body['whatsapp'] ?? ''), $body['opening_time'] ?? null, $body['closing_time'] ?? null]);
        }

        $user = $db->prepare("SELECT * FROM users WHERE id=?")->execute([$userId])->fetch();
        unset($user['password']);
        $tokens = Auth::issueTokens($user);
        Response::json([...$tokens, 'user' => $user], 201);
    }

    public function refresh(): void {
        $body  = Request::json();
        $token = $body['refresh_token'] ?? '';
        if (!$token) Response::error('refresh_token required', 422);

        $db   = Database::getInstance();
        $hash = hash('sha256', $token);
        $stmt = $db->prepare("SELECT * FROM refresh_tokens WHERE token=? AND revoked=0 AND expires_at > NOW()");
        $stmt->execute([$hash]);
        $rt = $stmt->fetch();
        if (!$rt) Response::error('Invalid or expired refresh token', 401);

        // Revoke old token
        $db->prepare("UPDATE refresh_tokens SET revoked=1 WHERE id=?")->execute([$rt['id']]);

        $user = $db->prepare("SELECT * FROM users WHERE id=? AND is_active=1")->execute([$rt['user_id']])->fetch();
        if (!$user) Response::error('User not found', 404);
        unset($user['password']);
        Response::json(Auth::issueTokens($user));
    }

    public function logout(): void {
        $body  = Request::json();
        $token = $body['refresh_token'] ?? '';
        if ($token) {
            Database::getInstance()->prepare("UPDATE refresh_tokens SET revoked=1 WHERE token=?")
                ->execute([hash('sha256', $token)]);
        }
        Response::json(['logged_out' => true]);
    }

    public function changePassword(): void {
        $db   = Database::getInstance();
        $body = Request::json();
        if (empty($body['current_password']) || empty($body['new_password']))
            Response::error('current_password and new_password required', 422);
        if (strlen($body['new_password']) < 8) Response::error('Password must be at least 8 characters', 422);

        $user = $db->prepare("SELECT password FROM users WHERE id=?")->execute([$this->auth['uid']])->fetch();
        if (!password_verify($body['current_password'], $user['password']))
            Response::error('Current password is incorrect', 401);

        $db->prepare("UPDATE users SET password=? WHERE id=?")
           ->execute([password_hash($body['new_password'], PASSWORD_BCRYPT, ['cost'=>12]), $this->auth['uid']]);
        Response::json(['updated' => true]);
    }

    public function profile(): void {
        $db   = Database::getInstance();
        $user = $db->prepare("SELECT id, full_name, email, phone, avatar_url, role, created_at FROM users WHERE id=?")
                   ->execute([$this->auth['uid']])->fetch();
        Response::json($user);
    }

    public function updateProfile(): void {
        $db   = Database::getInstance();
        $body = Request::json();
        $db->prepare("UPDATE users SET full_name=?, phone=? WHERE id=?")
           ->execute([sanitize($body['full_name'] ?? ''), sanitize($body['phone'] ?? ''), $this->auth['uid']]);
        Response::json(['updated' => true]);
    }
}
```

### 7.2 `controllers/FoodController.php`
```php
<?php
class FoodController {
    public function __construct(private ?array $auth) {}

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
        $count  = $db->prepare("SELECT COUNT(*) FROM food_items fi JOIN vendors v ON v.id=fi.vendor_id $where");
        $count->execute($params); $total = (int)$count->fetchColumn();

        $sort = match(Request::get('sort','newest')) {
            'price_asc'  => 'fi.price ASC',
            'price_desc' => 'fi.price DESC',
            'rating'     => 'fi.avg_rating DESC',
            'popular'    => 'fi.views DESC',
            default      => 'fi.created_at DESC',
        };

        $stmt = $db->prepare("
            SELECT fi.id, fi.name, fi.description, fi.price, fi.image_url, fi.is_available,
                   fi.is_featured, fi.serving_size, fi.calories, fi.tags,
                   fi.avg_rating, fi.total_ratings, fi.views, fi.created_at,
                   c.name AS category_name, c.icon AS category_icon,
                   v.id AS vendor_id, v.business_name AS vendor_name, v.slug AS vendor_slug,
                   v.location AS vendor_location, v.opening_time, v.closing_time
            FROM food_items fi
            JOIN vendors v ON v.id=fi.vendor_id
            JOIN categories c ON c.id=fi.category_id
            $where ORDER BY $sort LIMIT ? OFFSET ?
        ");
        $params[] = $perPage;
        $params[] = paginationOffset($page, $perPage);
        $stmt->execute($params);
        $items = $stmt->fetchAll();

        foreach ($items as &$i) {
            $i['is_available'] = (bool)$i['is_available'];
            $i['price']        = (float)$i['price'];
            $i['avg_rating']   = (float)$i['avg_rating'];
            $i['total_ratings']= (int)$i['total_ratings'];
            $i['views']         = (int)$i['views'];
            if (isset($i['calories'])) $i['calories'] = (int)$i['calories'];
            $i['is_open']      = isVendorOpen($i['opening_time'] ?? '', $i['closing_time'] ?? '');
            $i['tags']         = $i['tags'] ? explode(',', $i['tags']) : [];
        }
        Response::paginated($items, $total, $page, $perPage);
    }

    public function featured(): void {
        $db   = Database::getInstance();
        $stmt = $db->query("
            SELECT fi.id, fi.name, fi.price, fi.image_url, fi.avg_rating, fi.is_available,
                   v.business_name AS vendor_name, v.slug AS vendor_slug,
                   c.name AS category_name, c.icon AS category_icon
            FROM food_items fi
            JOIN vendors v ON v.id=fi.vendor_id
            JOIN categories c ON c.id=fi.category_id
            WHERE fi.is_featured=1 AND v.status='approved'
            ORDER BY fi.avg_rating DESC LIMIT 20
        ");
        $items = $stmt->fetchAll();
        foreach ($items as &$i) {
            $i['price']      = (float)$i['price'];
            $i['avg_rating'] = (float)$i['avg_rating'];
            $i['is_available'] = (bool)$i['is_available'];
        }
        Response::json($items);
    }

    public function show(string $id): void {
        $db   = Database::getInstance();
        $stmt = $db->prepare("
            SELECT fi.*, c.name AS category_name, c.icon AS category_icon,
                   v.id AS vendor_id, v.business_name AS vendor_name, v.slug AS vendor_slug,
                   v.location, v.phone AS vendor_phone, v.whatsapp,
                   v.opening_time, v.closing_time, v.avg_rating AS vendor_avg_rating,
                   v.profile_image AS vendor_image
            FROM food_items fi
            JOIN vendors v ON v.id=fi.vendor_id
            JOIN categories c ON c.id=fi.category_id
            WHERE fi.id=? AND v.status='approved'
        ");
        $stmt->execute([(int)$id]);
        $item = $stmt->fetch();
        if (!$item) Response::error('Food item not found', 404);

        $item['is_available'] = (bool)$item['is_available'];
        $item['price']        = (float)$item['price'];
        $item['avg_rating']   = (float)$item['avg_rating'];
        $item['total_ratings']= (int)$item['total_ratings'];
        $item['views']         = (int)$item['views'];
        if (isset($item['calories'])) $item['calories'] = (int)$item['calories'];
        $item['is_open']      = isVendorOpen($item['opening_time'] ?? '', $item['closing_time'] ?? '');
        $item['tags']         = $item['tags'] ? explode(',', $item['tags']) : [];

        // Record view
        recordView($db, (int)$id, (int)$item['vendor_id'], $_SERVER['REMOTE_ADDR'] ?? '');

        Response::json($item);
    }

    public function store(): void {
        $db   = Database::getInstance();
        $body = Request::json();

        // Get vendor row for this user
        $vendor = $db->prepare("SELECT * FROM vendors WHERE user_id=? AND status='approved'");
        $vendor->execute([$this->auth['uid']]);
        $v = $vendor->fetch();
        if (!$v) Response::error('Your vendor account is not approved yet', 403);

        $missing = validateRequired($body, ['name','price','category_id']);
        if ($missing) Response::error('Missing: ' . implode(', ', $missing), 422);

        $imageUrl = null;
        if (!empty($_FILES['image'])) {
            try { $imageUrl = uploadImage($_FILES['image'], 'foods'); }
            catch (Exception $e) { Response::error($e->getMessage(), 422); }
        }

        $tags = isset($body['tags']) ? implode(',', array_map('trim', explode(',', $body['tags']))) : '';

        $db->prepare("INSERT INTO food_items (vendor_id, category_id, name, description, price, image_url, is_available, is_featured, serving_size, calories, tags) VALUES (?,?,?,?,?,?,?,?,?,?,?)")
           ->execute([$v['id'], (int)$body['category_id'], sanitize($body['name']), sanitize($body['description'] ?? ''), (float)$body['price'], $imageUrl, isset($body['is_available']) ? (int)$body['is_available'] : 1, isset($body['is_featured']) ? (int)$body['is_featured'] : 0, sanitize($body['serving_size'] ?? ''), $body['calories'] ? (int)$body['calories'] : null, sanitize($tags)]);

        Response::json(['food_id' => $db->lastInsertId()], 201);
    }

    public function update(string $id): void {
        $db   = Database::getInstance();
        $body = Request::json();

        // Verify ownership via vendor
        $check = $db->prepare("SELECT fi.id FROM food_items fi JOIN vendors v ON v.id=fi.vendor_id WHERE fi.id=? AND v.user_id=?");
        $check->execute([(int)$id, $this->auth['uid']]);
        if (!$check->fetch()) Response::error('Not found or forbidden', 404);

        $imageUrl = null;
        if (!empty($_FILES['image'])) {
            try {
                $imageUrl = uploadImage($_FILES['image'], 'foods');
                // Delete old image
                $old = $db->prepare("SELECT image_url FROM food_items WHERE id=?"); $old->execute([(int)$id]);
                $o   = $old->fetch();
                if ($o && $o['image_url']) deleteImage($o['image_url']);
            } catch (Exception $e) { Response::error($e->getMessage(), 422); }
        }

        $tags = isset($body['tags']) ? implode(',', array_map('trim', explode(',', $body['tags']))) : null;
        $sql  = "UPDATE food_items SET name=?, description=?, price=?, category_id=?, serving_size=?, calories=?, tags=?, is_featured=?";
        $prms = [sanitize($body['name'] ?? ''), sanitize($body['description'] ?? ''), (float)($body['price'] ?? 0), (int)($body['category_id'] ?? 0), sanitize($body['serving_size'] ?? ''), $body['calories'] ? (int)$body['calories'] : null, sanitize($tags ?? ''), (int)($body['is_featured'] ?? 0)];
        if ($imageUrl) { $sql .= ', image_url=?'; $prms[] = $imageUrl; }
        $sql .= ' WHERE id=?'; $prms[] = (int)$id;
        $db->prepare($sql)->execute($prms);
        Response::json(['updated' => true]);
    }

    public function destroy(string $id): void {
        $db    = Database::getInstance();
        $check = $db->prepare("SELECT fi.id, fi.image_url FROM food_items fi JOIN vendors v ON v.id=fi.vendor_id WHERE fi.id=? AND v.user_id=?");
        $check->execute([(int)$id, $this->auth['uid']]);
        $item  = $check->fetch();
        if (!$item) Response::error('Not found or forbidden', 404);

        if ($item['image_url']) deleteImage($item['image_url']);
        $db->prepare("DELETE FROM food_items WHERE id=?")->execute([(int)$id]);
        Response::json(['deleted' => true]);
    }

    public function toggleAvailability(string $id): void {
        $db    = Database::getInstance();
        $check = $db->prepare("SELECT fi.id, fi.is_available FROM food_items fi JOIN vendors v ON v.id=fi.vendor_id WHERE fi.id=? AND v.user_id=?");
        $check->execute([(int)$id, $this->auth['uid']]);
        $item  = $check->fetch();
        if (!$item) Response::error('Not found or forbidden', 404);

        $newStatus = $item['is_available'] ? 0 : 1;
        $db->prepare("UPDATE food_items SET is_available=? WHERE id=?")->execute([$newStatus, (int)$id]);
        Response::json(['is_available' => (bool)$newStatus]);
    }
}
```

### 7.3 `controllers/SearchController.php`
```php
<?php
class SearchController {
    public function __construct(private ?array $auth) {}

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

        $orderBy = match($sort) {
            'price_asc'  => 'fi.price ASC',
            'price_desc' => 'fi.price DESC',
            'rating'     => 'fi.avg_rating DESC',
            'popular'    => 'fi.views DESC',
            default      => 'fi.created_at DESC',
        };

        $stmt = $db->prepare("
            SELECT fi.id, fi.name, fi.description, fi.price, fi.image_url,
                   fi.is_available, fi.avg_rating, fi.total_ratings, fi.views, fi.tags,
                   c.name AS category_name, c.icon AS category_icon,
                   v.id AS vendor_id, v.business_name AS vendor_name, v.slug AS vendor_slug, v.location
            FROM food_items fi
            JOIN vendors v ON v.id=fi.vendor_id
            JOIN categories c ON c.id=fi.category_id
            $where ORDER BY $orderBy LIMIT ? OFFSET ?
        ");
        $params[] = ITEMS_PER_PAGE;
        $params[] = paginationOffset($page);
        $stmt->execute($params);
        $items = $stmt->fetchAll();

        foreach ($items as &$i) {
            $i['is_available'] = (bool)$i['is_available'];
            $i['price']        = (float)$i['price'];
            $i['avg_rating']   = (float)$i['avg_rating'];
            $i['total_ratings']= (int)$i['total_ratings'];
            $i['views']         = (int)$i['views'];
            $i['tags']         = $i['tags'] ? explode(',', $i['tags']) : [];
        }

        Response::paginated($items, $total, $page, ITEMS_PER_PAGE);
    }

    public function autocomplete(): void {
        $db = Database::getInstance();
        $q  = sanitize(Request::get('q', ''));
        if (strlen($q) < 2) Response::json([]);

        $like = "%$q%";
        $stmt = $db->prepare("
            (SELECT 'food' AS type, fi.id, fi.name AS label, fi.image_url
             FROM food_items fi JOIN vendors v ON v.id=fi.vendor_id
             WHERE fi.name LIKE ? AND v.status='approved' LIMIT 5)
            UNION
            (SELECT 'vendor' AS type, v.id, v.business_name AS label, v.profile_image AS image_url
             FROM vendors v WHERE v.business_name LIKE ? AND v.status='approved' LIMIT 3)
        ");
        $stmt->execute([$like, $like]);
        Response::json($stmt->fetchAll());
    }

    public function recommend(): void {
        $db         = Database::getInstance();
        $budget     = (float)Request::get('budget', 0);
        $categoryId = (int)Request::get('category_id');
        if (!$budget) Response::error('budget is required', 422);

        $cond   = ["v.status='approved'", "fi.is_available=1", "fi.price <= ?"];
        $params = [$budget];
        if ($categoryId) { $cond[] = 'fi.category_id=?'; $params[] = $categoryId; }

        $where = 'WHERE ' . implode(' AND ', $cond);

        // Best value (highest rating within budget)
        $bestValue = $db->prepare("SELECT fi.id, fi.name, fi.price, fi.image_url, fi.avg_rating, fi.total_ratings, v.business_name AS vendor_name, v.slug, c.name AS category FROM food_items fi JOIN vendors v ON v.id=fi.vendor_id JOIN categories c ON c.id=fi.category_id $where ORDER BY fi.avg_rating DESC, fi.price ASC LIMIT 10");
        $bestValue->execute($params);
        $bv = $bestValue->fetchAll();
        foreach($bv as &$item) { $item['price'] = (float)$item['price']; $item['avg_rating'] = (float)$item['avg_rating']; $item['total_ratings'] = (int)$item['total_ratings']; }

        // Cheapest
        $cheapest = $db->prepare("SELECT fi.id, fi.name, fi.price, fi.image_url, fi.avg_rating, fi.total_ratings, v.business_name AS vendor_name, v.slug, c.name AS category FROM food_items fi JOIN vendors v ON v.id=fi.vendor_id JOIN categories c ON c.id=fi.category_id $where ORDER BY fi.price ASC LIMIT 10");
        $cheapest->execute($params);
        $ch = $cheapest->fetchAll();
        foreach($ch as &$item) { $item['price'] = (float)$item['price']; $item['avg_rating'] = (float)$item['avg_rating']; $item['total_ratings'] = (int)$item['total_ratings']; }

        // Most popular
        $popular = $db->prepare("SELECT fi.id, fi.name, fi.price, fi.image_url, fi.avg_rating, fi.total_ratings, v.business_name AS vendor_name, v.slug, c.name AS category FROM food_items fi JOIN vendors v ON v.id=fi.vendor_id JOIN categories c ON c.id=fi.category_id $where ORDER BY fi.views DESC LIMIT 10");
        $popular->execute($params);
        $pop = $popular->fetchAll();
        foreach($pop as &$item) { $item['price'] = (float)$item['price']; $item['avg_rating'] = (float)$item['avg_rating']; $item['total_ratings'] = (int)$item['total_ratings']; }

        Response::json([
            'budget'    => $budget,
            'best_value'=> $bv,
            'cheapest'  => $ch,
            'popular'   => $pop,
        ]);
    }

    public function compare(): void {
        $db  = Database::getInstance();
        $ids = array_filter(array_map('intval', explode(',', Request::get('ids', ''))));
        if (empty($ids) || count($ids) > 4) Response::error('Provide 1–4 food IDs', 422);

        $placeholders = implode(',', array_fill(0, count($ids), '?'));
        $stmt = $db->prepare("
            SELECT fi.id, fi.name, fi.price, fi.image_url, fi.avg_rating, fi.total_ratings,
                   fi.serving_size, fi.calories, fi.is_available, fi.tags,
                   c.name AS category_name, c.icon AS category_icon,
                   v.business_name AS vendor_name, v.slug AS vendor_slug, v.location
            FROM food_items fi
            JOIN vendors v ON v.id=fi.vendor_id
            JOIN categories c ON c.id=fi.category_id
            WHERE fi.id IN ($placeholders) AND v.status='approved'
        ");
        $stmt->execute($ids);
        $items = $stmt->fetchAll();

        // Mark cheapest + highest rated
        if ($items) {
            $minPrice    = min(array_column($items, 'price'));
            $maxRating   = max(array_column($items, 'avg_rating'));
            foreach ($items as &$i) {
                $i['price']            = (float)$i['price'];
                $i['avg_rating']       = (float)$i['avg_rating'];
                $i['is_cheapest']      = $i['price'] == $minPrice;
                $i['is_highest_rated'] = $i['avg_rating'] == $maxRating;
                $i['is_available']     = (bool)$i['is_available'];
                $i['tags']             = $i['tags'] ? explode(',', $i['tags']) : [];
            }
        }
        Response::json($items);
    }
}
```

### 7.4 `controllers/RatingController.php`
```php
<?php
class RatingController {
    public function __construct(private ?array $auth) {}

    public function index(string $foodId): void {
        $db      = Database::getInstance();
        $page    = max(1,(int)Request::get('page',1));
        $perPage = 10;

        // Distribution
        $dist = $db->prepare("SELECT stars, COUNT(*) AS count FROM ratings WHERE food_id=? GROUP BY stars ORDER BY stars DESC");
        $dist->execute([(int)$foodId]);

        $total = $db->prepare("SELECT COUNT(*) FROM ratings WHERE food_id=?");
        $total->execute([(int)$foodId]);
        $count = (int)$total->fetchColumn();

        $stmt = $db->prepare("
            SELECT r.id, r.stars, r.comment, r.created_at,
                   u.full_name AS reviewer_name, u.avatar_url AS reviewer_avatar
            FROM ratings r LEFT JOIN users u ON u.id=r.user_id
            WHERE r.food_id=?
            ORDER BY r.created_at DESC LIMIT ? OFFSET ?
        ");
        $stmt->execute([(int)$foodId, $perPage, paginationOffset($page, $perPage)]);

        Response::json([
            'distribution' => $dist->fetchAll(),
            'ratings'      => $stmt->fetchAll(),
            'total'        => $count,
            'page'         => $page,
            'last_page'    => (int)ceil($count / $perPage),
        ]);
    }

    public function store(string $foodId): void {
        $db   = Database::getInstance();
        $body = Request::json();
        $ip   = $_SERVER['REMOTE_ADDR'] ?? '0.0.0.0';
        $uid  = $this->auth['uid'] ?? null;
        $stars = (int)($body['stars'] ?? 0);

        if ($stars < 1 || $stars > 5) Response::error('Stars must be between 1 and 5', 422);

        // Verify food exists
        $food = $db->prepare("SELECT vendor_id FROM food_items WHERE id=?"); $food->execute([(int)$foodId]);
        $f    = $food->fetch();
        if (!$f) Response::error('Food not found', 404);

        // Check duplicate
        if ($uid) {
            $dup = $db->prepare("SELECT id FROM ratings WHERE food_id=? AND user_id=?");
            $dup->execute([(int)$foodId, $uid]);
            if ($dup->fetch()) Response::error('You have already rated this item', 409);
        } else {
            $dup = $db->prepare("SELECT id FROM ratings WHERE food_id=? AND ip_address=? AND user_id IS NULL");
            $dup->execute([(int)$foodId, $ip]);
            if ($dup->fetch()) Response::error('You have already rated this item', 409);
        }

        $db->prepare("INSERT INTO ratings (food_id, vendor_id, user_id, ip_address, stars, comment) VALUES (?,?,?,?,?,?)")
           ->execute([(int)$foodId, $f['vendor_id'], $uid, $ip, $stars, sanitize($body['comment'] ?? '')]);

        recalculateRatings($db, (int)$foodId);
        Response::json(['rated' => true], 201);
    }

    public function myRatings(): void {
        $db   = Database::getInstance();
        $stmt = $db->prepare("
            SELECT r.id, r.stars, r.comment, r.created_at,
                   fi.name AS food_name, fi.image_url AS food_image, fi.id AS food_id,
                   v.business_name AS vendor_name
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
```

### 7.5 `controllers/AdminController.php`
```php
<?php
class AdminController {
    public function __construct(private ?array $auth) {}

    public function dashboard(): void {
        $db = Database::getInstance();
        $s1 = $db->query("SELECT COUNT(*) FROM vendors WHERE status='approved'")->fetchColumn();
        $s2 = $db->query("SELECT COUNT(*) FROM vendors WHERE status='pending'")->fetchColumn();
        $s3 = $db->query("SELECT COUNT(*) FROM users WHERE role='student' AND is_active=1")->fetchColumn();
        $s4 = $db->query("SELECT COUNT(*) FROM food_items")->fetchColumn();
        $s5 = $db->query("SELECT COUNT(*) FROM item_views WHERE DATE(viewed_at)=CURDATE()")->fetchColumn();
        $s6 = $db->query("SELECT ROUND(AVG(avg_rating),2) FROM vendors WHERE status='approved' AND total_ratings>0")->fetchColumn();

        $pending = $db->query("SELECT v.id, v.business_name, v.location, v.created_at, u.email, u.full_name FROM vendors v JOIN users u ON u.id=v.user_id WHERE v.status='pending' ORDER BY v.created_at ASC LIMIT 10")->fetchAll();

        $topFoods = $db->query("SELECT fi.id, fi.name, fi.image_url, fi.avg_rating, fi.views, v.business_name AS vendor FROM food_items fi JOIN vendors v ON v.id=fi.vendor_id ORDER BY fi.views DESC LIMIT 5")->fetchAll();

        Response::json([
            'stats' => ['approved_vendors'=>$s1,'pending_vendors'=>$s2,'students'=>$s3,'food_items'=>$s4,'views_today'=>$s5,'avg_site_rating'=>$s6],
            'pending_vendors' => $pending,
            'top_foods'       => $topFoods,
        ]);
    }

    public function vendors(): void {
        $db     = Database::getInstance();
        $status = Request::get('status', '');
        $page   = max(1,(int)Request::get('page',1));
        $cond   = $status ? "WHERE v.status=?" : "WHERE 1";
        $params = $status ? [$status] : [];

        $count = $db->prepare("SELECT COUNT(*) FROM vendors v $cond"); $count->execute($params);
        $total = (int)$count->fetchColumn();

        $stmt  = $db->prepare("
            SELECT v.id, v.business_name, v.slug, v.location, v.status, v.avg_rating,
                   v.total_ratings, v.created_at, v.opening_time, v.closing_time,
                   u.full_name AS owner_name, u.email AS owner_email, u.phone AS owner_phone,
                   (SELECT COUNT(*) FROM food_items fi WHERE fi.vendor_id=v.id) AS food_count
            FROM vendors v JOIN users u ON u.id=v.user_id $cond
            ORDER BY v.created_at DESC LIMIT ? OFFSET ?
        ");
        $params[] = ITEMS_PER_PAGE; $params[] = paginationOffset($page);
        $stmt->execute($params);
        Response::paginated($stmt->fetchAll(), $total, $page, ITEMS_PER_PAGE);
    }

    public function vendorDetail(string $id): void {
        $db   = Database::getInstance();
        $stmt = $db->prepare("SELECT v.*, u.full_name AS owner_name, u.email, u.phone FROM vendors v JOIN users u ON u.id=v.user_id WHERE v.id=?");
        $stmt->execute([(int)$id]);
        $vendor = $stmt->fetch();
        if (!$vendor) Response::error('Vendor not found', 404);

        $foods = $db->prepare("SELECT fi.id, fi.name, fi.price, fi.avg_rating, fi.views, fi.is_available, c.name AS category FROM food_items fi JOIN categories c ON c.id=fi.category_id WHERE fi.vendor_id=? ORDER BY fi.name ASC");
        $foods->execute([(int)$id]);
        $vendor['foods'] = $foods->fetchAll();

        Response::json($vendor);
    }

    public function vendorAction(string $id): void {
        $db     = Database::getInstance();
        $body   = Request::json();
        $action = sanitize($body['action'] ?? '');
        $reason = sanitize($body['reason'] ?? '');

        if (!in_array($action, ['approve','reject','block','unblock']))
            Response::error('Invalid action', 422);

        $statusMap = ['approve'=>'approved','reject'=>'rejected','block'=>'blocked','unblock'=>'approved'];
        $newStatus = $statusMap[$action];

        $db->beginTransaction();
        try {
            $db->prepare("UPDATE vendors SET status=? WHERE id=?")->execute([$newStatus, (int)$id]);

            $vendor = $db->prepare("SELECT v.user_id, v.business_name FROM vendors v WHERE v.id=?");
            $vendor->execute([(int)$id]);
            $v = $vendor->fetch();

            $messages = [
                'approve' => ['title'=>'✅ Application Approved', 'type'=>'approval',
                              'message'=>"Congratulations! '{$v['business_name']}' has been approved. You can now add your menu."],
                'reject'  => ['title'=>'❌ Application Rejected', 'type'=>'rejection',
                              'message'=>"Your application was not approved." . ($reason ? " Reason: $reason" : '')],
                'block'   => ['title'=>'⚠️ Account Suspended', 'type'=>'warning',
                              'message'=>"Your account has been suspended." . ($reason ? " Reason: $reason" : '')],
                'unblock' => ['title'=>'✅ Account Reinstated', 'type'=>'approval',
                              'message'=>"Your account has been reinstated. You can start uploading your menu again."],
            ];
            $msg = $messages[$action];
            $db->prepare("INSERT INTO notifications (user_id, title, message, type) VALUES (?,?,?,?)")
               ->execute([$v['user_id'], $msg['title'], $msg['message'], $msg['type']]);

            $db->commit();
            Response::json(['action' => $action, 'new_status' => $newStatus]);
        } catch (Exception $e) {
            $db->rollBack();
            Response::error('Action failed: ' . $e->getMessage(), 500);
        }
    }

    public function students(): void {
        $db   = Database::getInstance();
        $page = max(1,(int)Request::get('page',1));
        $count = $db->query("SELECT COUNT(*) FROM users WHERE role='student'")->fetchColumn();
        $stmt  = $db->prepare("SELECT id, full_name, email, phone, is_active, last_login, created_at FROM users WHERE role='student' ORDER BY created_at DESC LIMIT ? OFFSET ?");
        $stmt->execute([ITEMS_PER_PAGE, paginationOffset($page)]);
        Response::paginated($stmt->fetchAll(), (int)$count, $page, ITEMS_PER_PAGE);
    }

    public function toggleStudent(string $id): void {
        $db = Database::getInstance();
        $db->prepare("UPDATE users SET is_active = NOT is_active WHERE id=? AND role='student'")->execute([(int)$id]);
        Response::json(['toggled' => true]);
    }

    public function reports(): void {
        $db   = Database::getInstance();
        $from = Request::get('from', date('Y-m-01'));
        $to   = Request::get('to', date('Y-m-d'));

        $topViewed = $db->prepare("SELECT fi.id, fi.name, fi.views, v.business_name FROM food_items fi JOIN vendors v ON v.id=fi.vendor_id WHERE v.status='approved' ORDER BY fi.views DESC LIMIT 10");
        $topViewed->execute();

        $topRated = $db->prepare("SELECT fi.id, fi.name, fi.avg_rating, fi.total_ratings, v.business_name FROM food_items fi JOIN vendors v ON v.id=fi.vendor_id WHERE fi.total_ratings>0 AND v.status='approved' ORDER BY fi.avg_rating DESC LIMIT 10");
        $topRated->execute();

        $categoryStats = $db->query("SELECT c.name, c.icon, COUNT(fi.id) AS item_count, ROUND(AVG(fi.avg_rating),2) AS avg_rating FROM categories c LEFT JOIN food_items fi ON fi.category_id=c.id GROUP BY c.id ORDER BY item_count DESC");

        $vendorStats = $db->query("SELECT v.id, v.business_name, v.avg_rating, v.total_ratings, COUNT(fi.id) AS food_count FROM vendors v LEFT JOIN food_items fi ON fi.vendor_id=v.id WHERE v.status='approved' GROUP BY v.id ORDER BY v.avg_rating DESC LIMIT 15");

        $dailyViews = $db->prepare("SELECT DATE(viewed_at) AS date, COUNT(*) AS views FROM item_views WHERE DATE(viewed_at) BETWEEN ? AND ? GROUP BY DATE(viewed_at) ORDER BY date ASC");
        $dailyViews->execute([$from, $to]);

        Response::json([
            'top_viewed'    => $topViewed->fetchAll(),
            'top_rated'     => $topRated->fetchAll(),
            'category_stats'=> $categoryStats->fetchAll(),
            'vendor_stats'  => $vendorStats->fetchAll(),
            'daily_views'   => $dailyViews->fetchAll(),
            'period'        => ['from' => $from, 'to' => $to],
        ]);
    }

    public function exportCsv(): void {
        $db   = Database::getInstance();
        $stmt = $db->query("SELECT fi.id, fi.name AS food_name, fi.price, fi.avg_rating, fi.total_ratings, fi.views, fi.is_available, c.name AS category, v.business_name AS vendor, v.location, v.status AS vendor_status FROM food_items fi JOIN vendors v ON v.id=fi.vendor_id JOIN categories c ON c.id=fi.category_id ORDER BY fi.views DESC");
        $rows = $stmt->fetchAll();

        header('Content-Type: text/csv');
        header('Content-Disposition: attachment; filename="bsu_foodhub_report_' . date('Y-m-d') . '.csv"');
        $out = fopen('php://output', 'w');
        fputcsv($out, ['ID','Food Name','Price (UGX)','Avg Rating','Total Ratings','Views','Available','Category','Vendor','Location','Vendor Status']);
        foreach ($rows as $r) {
            fputcsv($out, [$r['id'], $r['food_name'], $r['price'], $r['avg_rating'], $r['total_ratings'], $r['views'], $r['is_available'] ? 'Yes' : 'No', $r['category'], $r['vendor'], $r['location'], $r['vendor_status']]);
        }
        fclose($out);
        exit;
    }
}
```

---

## 8. Flutter App — Project Structure

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   └── app_strings.dart
│   ├── services/
│   │   ├── api_service.dart          # Dio + JWT interceptor
│   │   ├── auth_service.dart         # Login, register, token storage
│   │   └── storage_service.dart      # flutter_secure_storage wrapper
│   └── utils/
│       ├── formatters.dart           # formatPrice(), timeAgo()
│       └── validators.dart
├── features/
│   ├── auth/
│   │   ├── domain/models/
│   │   │   ├── user.dart             # freezed
│   │   │   └── vendor_profile.dart
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── splash_screen.dart
│   │       │   ├── login_screen.dart
│   │       │   └── register_screen.dart
│   │       └── providers/auth_provider.dart
│   ├── browse/
│   │   ├── domain/models/
│   │   │   ├── food_item.dart
│   │   │   ├── vendor.dart
│   │   │   └── category.dart
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── home_screen.dart
│   │       │   ├── vendor_profile_screen.dart
│   │       │   ├── food_detail_screen.dart
│   │       │   ├── search_screen.dart
│   │       │   ├── budget_screen.dart
│   │       │   └── compare_screen.dart
│   │       ├── providers/
│   │       │   ├── vendors_provider.dart
│   │       │   ├── foods_provider.dart
│   │       │   └── search_provider.dart
│   │       └── widgets/
│   │           ├── food_card.dart
│   │           ├── vendor_card.dart
│   │           ├── star_rating_widget.dart
│   │           ├── category_chip.dart
│   │           └── compare_bottom_bar.dart
│   ├── vendor/
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── vendor_dashboard_screen.dart
│   │       │   ├── my_menu_screen.dart
│   │       │   ├── add_edit_food_screen.dart
│   │       │   ├── availability_screen.dart
│   │       │   ├── feedback_screen.dart
│   │       │   └── vendor_profile_edit_screen.dart
│   │       └── providers/vendor_provider.dart
│   ├── student/
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── student_dashboard_screen.dart
│   │       │   ├── favorites_screen.dart
│   │       │   └── my_ratings_screen.dart
│   │       └── providers/student_provider.dart
│   ├── admin/
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── admin_dashboard_screen.dart
│   │       │   ├── vendor_list_screen.dart
│   │       │   ├── vendor_detail_screen.dart
│   │       │   ├── categories_screen.dart
│   │       │   └── reports_screen.dart
│   │       └── providers/admin_provider.dart
│   └── sharedWidgets
│       ├── app_shell.dart
│       ├── shimmer_loader.dart
│       ├── empty_state_widget.dart
│       ├── error_widget.dart
│       └── availability_badge.dart
└── router/
    └── app_router.dart
```

---

## 9. Flutter — Core Services

### 9.1 `api_service.dart`
```dart
class ApiService {
  static const baseUrl = 'https://api.yourdomain.com/api/v1';
  late final Dio _dio;
  final FlutterSecureStorage _storage;

  ApiService(this._storage) {
    _dio = Dio(BaseOptions(baseUrl: baseUrl, connectTimeout: const Duration(seconds: 15)));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'access_token');
        if (token != null) options.headers['Authorization'] = 'Bearer $token';
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          if (await _refreshToken()) {
            final token = await _storage.read(key: 'access_token');
            error.requestOptions.headers['Authorization'] = 'Bearer $token';
            return handler.resolve(await _dio.fetch(error.requestOptions));
          }
        }
        return handler.next(error);
      },
    ));
  }

  Future<bool> _refreshToken() async {
    try {
      final rt  = await _storage.read(key: 'refresh_token');
      if (rt == null) return false;
      final res = await Dio().post('$baseUrl/auth/refresh', data: {'refresh_token': rt});
      await _storage.write(key: 'access_token',  value: res.data['data']['access_token']);
      await _storage.write(key: 'refresh_token', value: res.data['data']['refresh_token']);
      return true;
    } catch (_) { return false; }
  }

  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? params}) async {
    final res = await _dio.get(path, queryParameters: params);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> post(String path, {dynamic data}) async {
    final res = await _dio.post(path, data: data);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> put(String path, {dynamic data}) async {
    final res = await _dio.put(path, data: data);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> patch(String path, {dynamic data}) async {
    final res = await _dio.patch(path, data: data);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> delete(String path) async {
    final res = await _dio.delete(path);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> uploadFile(String path, File file, String field, {Map<String, dynamic>? extra}) async {
    final form = FormData.fromMap({
      field: await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
      ...?extra,
    });
    final res = await _dio.post(path, data: form);
    return res.data as Map<String, dynamic>;
  }
}
```

---

## 10. Flutter — Data Models (Freezed)

```dart
// lib/features/browse/domain/models/vendor.dart
@freezed
class Vendor with _$Vendor {
  const factory Vendor({
    required int id,
    required String businessName,
    required String slug,
    String? description,
    required String location,
    String? phone,
    String? whatsapp,
    String? openingTime,
    String? closingTime,
    String? profileImage,
    String? bannerImage,
    required String status,
    required double avgRating,
    required int totalRatings,
    bool? isOpen,
    int? foodCount,
  }) = _Vendor;
  factory Vendor.fromJson(Map<String, dynamic> json) => _$VendorFromJson(json);
}

// lib/features/browse/domain/models/food_item.dart
@freezed
class FoodItem with _$FoodItem {
  const factory FoodItem({
    required int id,
    required String name,
    String? description,
    required double price,
    String? imageUrl,
    required bool isAvailable,
    bool? isFeatured,
    String? servingSize,
    int? calories,
    List<String>? tags,
    required double avgRating,
    required int totalRatings,
    required int views,
    required String categoryName,
    String? categoryIcon,
    required int vendorId,
    required String vendorName,
    required String vendorSlug,
    String? vendorLocation,
    bool? isOpen,
    bool? isCheapest,
    bool? isHighestRated,
  }) = _FoodItem;
  factory FoodItem.fromJson(Map<String, dynamic> json) => _$FoodItemFromJson(json);
}

// lib/features/browse/domain/models/category.dart
@freezed
class Category with _$Category {
  const factory Category({
    required int id,
    required String name,
    String? icon,
    int? sortOrder,
  }) = _Category;
  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
}

// lib/features/auth/domain/models/user.dart
@freezed
class AppUser with _$AppUser {
  const factory AppUser({
    required int id,
    required String fullName,
    required String email,
    String? phone,
    required String role,
    String? avatarUrl,
    Vendor? vendor,
  }) = _AppUser;
  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);
}

// lib/features/browse/domain/models/rating.dart
@freezed
class Rating with _$Rating {
  const factory Rating({
    required int id,
    required int stars,
    String? comment,
    String? reviewerName,
    String? reviewerAvatar,
    required String createdAt,
  }) = _Rating;
  factory Rating.fromJson(Map<String, dynamic> json) => _$RatingFromJson(json);
}
```

---

## 11. Flutter — GoRouter

```dart
// lib/router/app_router.dart
final navigatorKey = GlobalKey<NavigatorState>();

GoRouter buildRouter(WidgetRef ref) => GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/splash',
  redirect: (ctx, state) async {
    final auth     = ref.read(authServiceProvider);
    final loggedIn = await auth.isLoggedIn();
    final path     = state.matchedLocation;
    final open     = ['/splash', '/login', '/register'];
    if (!loggedIn && !open.contains(path)) return '/login';
    return null;
  },
  routes: [
    // Public / guest
    GoRoute(path: '/splash',   builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/login',    builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),

    // Browse (guest + all roles)
    ShellRoute(
      builder: (_, __, child) => AppShell(child: child),
      routes: [
        GoRoute(path: '/home',              builder: (_, __) => const HomeScreen()),
        GoRoute(path: '/vendors/:slug',     builder: (_, s)  => VendorProfileScreen(slug: s.pathParameters['slug']!)),
        GoRoute(path: '/foods/:id',         builder: (_, s)  => FoodDetailScreen(foodId: int.parse(s.pathParameters['id']!))),
        GoRoute(path: '/search',            builder: (_, __) => const SearchScreen()),
        GoRoute(path: '/budget',            builder: (_, __) => const BudgetScreen()),
        GoRoute(path: '/compare',           builder: (_, __) => const CompareScreen()),
      ],
    ),

    // Student
    ShellRoute(
      builder: (_, __, child) => AppShell(child: child),
      routes: [
        GoRoute(path: '/student/dashboard', builder: (_, __) => const StudentDashboardScreen()),
        GoRoute(path: '/student/favorites', builder: (_, __) => const FavoritesScreen()),
        GoRoute(path: '/student/ratings',   builder: (_, __) => const MyRatingsScreen()),
      ],
    ),

    // Vendor
    ShellRoute(
      builder: (_, __, child) => AppShell(child: child),
      routes: [
        GoRoute(path: '/vendor/dashboard',  builder: (_, __) => const VendorDashboardScreen()),
        GoRoute(path: '/vendor/menu',       builder: (_, __) => const MyMenuScreen()),
        GoRoute(path: '/vendor/foods/add',  builder: (_, __) => const AddEditFoodScreen()),
        GoRoute(path: '/vendor/foods/:id/edit', builder: (_, s) => AddEditFoodScreen(foodId: int.parse(s.pathParameters['id']!))),
        GoRoute(path: '/vendor/availability', builder: (_, __) => const AvailabilityScreen()),
        GoRoute(path: '/vendor/feedback',   builder: (_, __) => const FeedbackScreen()),
        GoRoute(path: '/vendor/profile',    builder: (_, __) => const VendorProfileEditScreen()),
      ],
    ),

    // Admin
    ShellRoute(
      builder: (_, __, child) => AppShell(child: child),
      routes: [
        GoRoute(path: '/admin/dashboard',   builder: (_, __) => const AdminDashboardScreen()),
        GoRoute(path: '/admin/vendors',     builder: (_, __) => const VendorListScreen()),
        GoRoute(path: '/admin/vendors/:id', builder: (_, s)  => VendorDetailScreen(vendorId: int.parse(s.pathParameters['id']!))),
        GoRoute(path: '/admin/categories',  builder: (_, __) => const CategoriesScreen()),
        GoRoute(path: '/admin/reports',     builder: (_, __) => const ReportsScreen()),
      ],
    ),
  ],
);
```

---

## 12. Flutter Design System

### Color Palette
```dart
// lib/core/constants/app_colors.dart
class AppColors {
  static const primary       = Color(0xFFE8820C);   // Warm saffron
  static const primaryLight  = Color(0xFFFEF3E2);
  static const primaryDark   = Color(0xFFB5620A);
  static const accent        = Color(0xFF2D7D46);   // Fresh green
  static const accentLight   = Color(0xFFE8F5ED);
  static const success       = Color(0xFF16A34A);
  static const error         = Color(0xFFDC2626);
  static const warning       = Color(0xFFD97706);
  static const info          = Color(0xFF2563EB);
  static const background    = Color(0xFFFAFAF9);
  static const surface       = Color(0xFFFFFFFF);
  static const border        = Color(0xFFE7E5E4);
  static const textPrimary   = Color(0xFF1C1917);
  static const textSecondary = Color(0xFF78716C);
  static const textMuted     = Color(0xFFA8A29E);
  static const adminColor    = Color(0xFF7C3AED);
  static const vendorColor   = Color(0xFF0369A1);
  static const studentColor  = Color(0xFF059669);
}
```

### Typography
- Font: `Plus Jakarta Sans` (Google Fonts package)
- Sizes: 12, 14, 16, 18, 20, 24, 28, 32

### Component Rules
- **Cards:** `borderRadius: 16`, `elevation: 0`, thin border `AppColors.border`
- **Food Card:** 16:9 image → category chip → name → price + availability badge → rating → vendor name → ♡ Save / Compare + buttons
- **Vendor Card:** Banner image → overlapping profile circle → name → location → hours + Open/Closed chip → rating
- **Buttons:** Primary = filled orange | Secondary = outlined | Danger = filled red
- **Availability badges:** Green pill `● Available` | Red pill `● Sold Out`
- **Status badges:** Pending = orange | Approved = green | Rejected = red | Blocked = grey
- **Bottom Nav:** Home | Search | [role-specific tab] | Profile — 4 items max

### AppShell
Shared shell widget wrapping all screens:
- Top app bar: BSU FoodHub logo | screen title | notification bell (vendor/admin only)
- Bottom navigation bar — items differ by role:
  - **Guest/Student:** Home | Search | Budget | Favorites (if student)
  - **Vendor:** Dashboard | My Menu | Availability | Feedback
  - **Admin:** Dashboard | Vendors | Reports | Categories

---

## 13. Screen Feature Specs

### 13.1 Home Screen (`/home`)
- **Search bar** (prominent, top) → navigates to `/search?q=...`
- **Category chips** horizontal scroll → filter foods by category
- **Vendor grid** (2-column cards) — approved vendors only, with Open/Closed badge based on current time
- **Featured foods strip** — horizontal scroll from `GET /foods/featured`
- **Budget widget** — "What's your budget?" text field + button → `/budget?budget=X`
- Pull-to-refresh on vendor list

### 13.2 Vendor Profile Screen (`/vendors/:slug`)
- Banner image (full width) + circular profile photo overlapping
- Business name, location, phone, WhatsApp deep link
- Open/Closed chip (computed from opening_time/closing_time vs current device time)
- Star rating avg + count
- **Category filter tabs** (horizontal): All | Local Dishes | Breakfast | ...
- **Food grid** filtered by selected tab — lazy loaded from `GET /foods?vendor_id=X&category_id=Y`
- **Ratings section:** star distribution bars + recent comments (last 5)

### 13.3 Food Detail Screen (`/foods/:id`)
- Large food image (hero animation from card)
- Name, category badge, price (formatted UGX)
- Description, serving size, calories
- Vendor info mini-card (tap → vendor profile)
- Availability badge
- Tag chips
- **Rate this meal:** interactive 1–5 star tap widget + comment text field
  - Student: POST `/foods/{id}/ratings` with JWT
  - Guest: POST without JWT (tracked by IP on server)
  - Show "You've already rated this" if duplicate
- **Add to Favorites** heart button — students only (POST `/favorites/{id}`)
- **All ratings list** paginated, load more button
- **Compare +** floating button → adds this food to compare list (stored in Riverpod state, max 4)

### 13.4 Search Screen (`/search`)
- Search bar (auto-focused, keyboard open on arrive)
- Filter panel (slide up from bottom on filter icon tap):
  - Category multi-select chips
  - Price range slider (0 → 20,000 UGX)
  - Availability toggle
  - Vendor dropdown
  - Sort selector: Newest | Price ↑ | Price ↓ | Rating | Popular
- Results list (food cards) with total count header
- "No results" empty state with "Try a different search" button
- Autocomplete suggestions while typing (from `GET /search/autocomplete?q=...`)

### 13.5 Budget Screen (`/budget`)
- Large budget input (numeric keyboard, UGX suffix)
- Category filter (optional)
- On search: `GET /recommend?budget=X&category_id=Y`
- Three sections displayed as horizontal scroll strips:
  - **Best Value** (highest rated within budget)
  - **Cheapest** (lowest price first)
  - **Most Popular** (most views)
- Each food card shows "Saves X UGX vs budget" green badge

### 13.6 Compare Screen (`/compare`)
- Horizontal scroll of up to 4 food comparison columns
- Row comparison table:
  - Image thumbnail
  - Food name
  - Price — cheapest highlighted in green
  - Vendor name
  - Category
  - Rating — highest highlighted in amber
  - Availability
  - Serving size
  - Calories
- Remove × button per column
- "View Details" button per column → food detail screen
- **Compare Bottom Bar:** sticky bottom bar visible on any screen when 1+ item added to compare list, shows count + "Compare" button → navigates to `/compare`

### 13.7 Vendor Dashboard (`/vendor/dashboard`)
- Stats row: Total items | Available | Sold out | Avg rating | Views today
- Recent ratings (last 5) — food name, stars, comment preview
- Quick availability toggle table (all items listed with toggle switch)
- Notification card if admin sent approval/warning notification

### 13.8 My Menu Screen (`/vendor/menu`)
- List of own food items with: image thumbnail | name | category | price | availability switch | views | rating | edit/delete actions
- Filter by: category, availability
- Sort by: name, price, rating, views
- FAB → `/vendor/foods/add`

### 13.9 Add / Edit Food Screen (`/vendor/foods/add` or `/vendor/foods/:id/edit`)
Form fields:
- Food name (required)
- Category (dropdown — from `GET /categories`)
- Price in UGX (number input, required)
- Description (multiline)
- Serving size
- Calories (optional)
- Tags (comma-separated chips input)
- Is Featured toggle
- Food image (image_picker → upload via multipart)
- Availability toggle (default: on)

On submit: POST `/foods` or PUT `/foods/{id}` depending on mode

### 13.10 Availability Screen (`/vendor/availability`)
- Full list of own food items
- Each row: image + name + price + toggle switch (green=available, red=sold out)
- Toggle fires PATCH `/foods/{id}/availability`
- Instant visual feedback with Riverpod state update (optimistic update)

### 13.11 Feedback Screen (`/vendor/feedback`)
- List of all ratings on vendor's food from `GET /vendor/feedback`
- Grouped by food item (expandable sections)
- Star distribution mini-chart per food
- Filter by: food item, star count, date

### 13.12 Student Dashboard (`/student/dashboard`)
- Personalized greeting "Good morning, [Name]!"
- Saved favorites grid (GET `/favorites` — first 4, "See all" link)
- My recent ratings list (last 3)
- "Discover something new" — random featured food card

### 13.13 Admin Dashboard (`/admin/dashboard`)
- Stats cards: Approved vendors | Pending approval (amber badge) | Students | Food items | Views today | Avg site rating
- **Pending vendor applications** urgent list — each has Approve / Reject buttons inline
- Top 5 most viewed foods this week

### 13.14 Vendor List Screen (`/admin/vendors`)
- Tab bar: All | Pending | Approved | Rejected | Blocked
- Each tab fetches `GET /admin/vendors?status=X`
- Vendor cards: name, owner, location, status badge, food count, avg rating
- Actions: Approve | Reject (with reason dialog) | Block | Unblock | View Details

### 13.15 Reports Screen (`/admin/reports`)
- Date range picker
- Charts (fl_chart):
  - Bar chart: top 10 most viewed foods
  - Bar chart: top 10 highest rated foods
  - Doughnut: category distribution
  - Line chart: daily views over selected period
- Vendor ranking table
- Download CSV button → opens API URL `GET /admin/reports/export` in browser

---

## 14. Database Seed SQL

```sql
-- database/seed.sql
USE bsu_foodhub;

-- Default admin (password: Admin@1234)
INSERT INTO users (full_name, email, password, role) VALUES
  ('System Admin', 'admin@bsu.ac.ug', '$2y$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin');

-- Sample vendor user (password: Admin@1234)
INSERT INTO users (full_name, email, password, role, phone) VALUES
  ('Mary Nalwanga', 'mary@bsu.ug', '$2y$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'vendor', '0772123456');

-- Vendor profile
INSERT INTO vendors (user_id, business_name, slug, description, location, phone, opening_time, closing_time, status) VALUES
  (2, "Mary's Kitchen", 'marys-kitchen', 'Home-cooked local meals at student-friendly prices', 'Near Main Gate, Left Side', '0772123456', '07:00', '20:00', 'approved');

-- Sample student (password: Admin@1234)
INSERT INTO users (full_name, email, password, role) VALUES
  ('John Student', 'student@bsu.ac.ug', '$2y$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'student');

-- Sample food items (vendor_id=1 = Mary's Kitchen)
INSERT INTO food_items (vendor_id, category_id, name, description, price, is_available, is_featured, serving_size, tags) VALUES
  (1, 1, 'Matooke & Groundnut Sauce', 'Steamed green bananas with rich groundnut sauce', 3500, 1, 1, '1 plate', 'popular,local'),
  (1, 1, 'Rice & Beans',              'White rice with well-seasoned mixed beans',       3000, 1, 0, '1 plate', 'popular'),
  (1, 2, 'Chapati & Tea',             'Freshly fried chapati with hot milk tea',         2500, 1, 1, '2 chapatis + tea', 'breakfast'),
  (1, 3, 'Fresh Passion Juice',       'Freshly squeezed passion fruit juice',            2000, 1, 0, 'per glass', 'healthy,fresh'),
  (1, 4, 'Rolex',                     'Ugandan egg chapati roll with vegetables',        1500, 1, 1, '1 roll', 'popular,street food');
```

---

## 15. Implementation Phases

### Phase 1 — Backend Foundation (Day 1–2)
- [ ] Create MySQL database, run schema.sql then seed.sql
- [ ] Composer init, install firebase/php-jwt and phpdotenv
- [ ] `.env`, `config/config.php`, `core/Database.php`
- [ ] `core/Auth.php` — JWT issue + verify
- [ ] `core/Response.php`, `core/Request.php`, `core/Helpers.php`, `core/Upload.php`
- [ ] `index.php` router with full route table
- [ ] `.htaccess`
- [ ] Test with Postman: POST `/auth/login`, POST `/auth/register`, GET `/categories`

### Phase 2 — Public API Endpoints (Day 2–3)
- [ ] `VendorController` — `index()`, `show()`
- [ ] `FoodController` — `index()`, `featured()`, `show()`
- [ ] `CategoryController` — `index()`
- [ ] `SearchController` — `search()`, `autocomplete()`, `recommend()`, `compare()`
- [ ] `RatingController` — `index()` (read ratings)
- [ ] Test all public endpoints without JWT

### Phase 3 — Auth + Student Endpoints (Day 3)
- [ ] `AuthController` — `login()`, `register()`, `refresh()`, `logout()`, `changePassword()`, `profile()`, `updateProfile()`
- [ ] `RatingController` — `store()` (guest by IP + student by JWT), `myRatings()`
- [ ] `FavoriteController` — `index()`, `toggle()`
- [ ] `refresh_tokens` table + token revocation logic

### Phase 4 — Vendor Endpoints (Day 3–4)
- [ ] `FoodController` — `store()`, `update()`, `destroy()`, `toggleAvailability()`
- [ ] `VendorController` — `store()` (self-register), `updateProfile()`, `uploadImages()`, `dashboard()`, `myMenu()`, `feedback()`, `notifications()`
- [ ] Image upload to `/uploads/foods/` and `/uploads/vendors/`
- [ ] Test: register vendor → add food → toggle availability → view feedback

### Phase 5 — Admin Endpoints (Day 4)
- [ ] `AdminController` — `dashboard()`, `vendors()`, `vendorDetail()`, `vendorAction()`, `students()`, `toggleStudent()`, `reports()`, `exportCsv()`
- [ ] `CategoryController` — `store()`, `update()`, `destroy()` (admin only)
- [ ] `NotificationController` — `index()`, `markRead()`, `markAllRead()`
- [ ] Test: admin approves vendor → vendor gets notification → admin sees reports

### Phase 6 — Flutter Foundation (Day 5–6)
- [ ] Initialize Flutter project, add all packages, `dart run build_runner build`
- [ ] `ApiService` with Dio + JWT interceptor + auto-refresh
- [ ] `AuthService` with flutter_secure_storage
- [ ] All Freezed models + JSON serializable
- [ ] `AppColors`, `AppTextStyles`, `AppStrings`
- [ ] GoRouter with all routes
- [ ] `SplashScreen` → role-based redirect
- [ ] `LoginScreen`, `RegisterScreen` (student + vendor tabs)
- [ ] Shared widgets: `AppShell`, shimmer, empty state, error widget

### Phase 7 — Browse Screens (Day 6–7)
- [ ] `HomeScreen` — vendor grid, featured foods, search bar, budget widget, category chips
- [ ] `VendorProfileScreen` — full detail, category tabs, foods, ratings
- [ ] `FoodDetailScreen` — hero image, info, rating widget, favorites button
- [ ] `SearchScreen` — search bar, filter bottom sheet, results list, autocomplete
- [ ] `BudgetScreen` — budget input, three results strips
- [ ] `CompareScreen` — side-by-side table + compare bottom bar widget

### Phase 8 — Vendor Screens (Day 7–8)
- [ ] `VendorDashboardScreen` — stats, recent ratings, quick availability
- [ ] `MyMenuScreen` — list with filter/sort + FAB
- [ ] `AddEditFoodScreen` — full form + image picker + category dropdown
- [ ] `AvailabilityScreen` — toggle switches, optimistic UI update
- [ ] `FeedbackScreen` — grouped by food, distribution chart
- [ ] `VendorProfileEditScreen` — edit profile + upload images

### Phase 9 — Student + Admin Screens (Day 8–9)
- [ ] `StudentDashboardScreen`
- [ ] `FavoritesScreen` — grid, remove, "unavailable" flag
- [ ] `MyRatingsScreen`
- [ ] `AdminDashboardScreen` — stats + pending vendors inline actions
- [ ] `VendorListScreen` — tabs, approve/reject/block with reason dialog
- [ ] `VendorDetailScreen` — full info + food list
- [ ] `CategoriesScreen` — CRUD with bottom sheet forms
- [ ] `ReportsScreen` — fl_chart charts + CSV download

### Phase 10 — Polish & Security (Day 9–10)
- [ ] Shimmer loading on all list screens
- [ ] Empty state widgets on all lists
- [ ] Pull-to-refresh on home, search, vendor menu, favorites
- [ ] Offline detection banner (connectivity_plus)
- [ ] Image placeholder/fallback for all CachedNetworkImage
- [ ] Form validation on all forms (client-side + show server errors)
- [ ] Sold Out overlay on food cards when `is_available = false`
- [ ] Open/Closed badge computed from current device time vs vendor hours
- [ ] All SQL: prepared statements audit
- [ ] Rate limiting on login endpoint (5 failures → 15 min block)
- [ ] PHP upload .htaccess blocks script execution
- [ ] End-to-end test: admin approves vendor → vendor adds 5 foods → guest browses → student rates → vendor sees feedback → admin reports show data

---

## 16. Deliverables Checklist

- [ ] Complete PHP API (`bsu-foodhub-api/`) — all controllers
- [ ] `database/schema.sql` — all 9 tables
- [ ] `database/seed.sql` — admin, vendor, student, foods
- [ ] Complete Flutter app (`bsu-foodhub-app/`) — all screens
- [ ] All 3 roles + guest working end-to-end
- [ ] Search, filter, budget recommendation, price comparison working
- [ ] Ratings working — students (by user ID) + guests (by IP)
- [ ] Favorites working (students only)
- [ ] Image uploads working (food + vendor images)
- [ ] JWT refresh flow working (access token auto-renewed)
- [ ] Admin vendor approval flow with in-app notifications
- [ ] Reports screen with fl_chart charts + CSV export
- [ ] Fully responsive on all Flutter device sizes
- [ ] README.md: API setup, Flutter setup, test credentials

---

## 17. README.md

```markdown
# BSU FoodHub — Setup Guide
# Bishop Stuart University Campus Food Discovery App

## Server Requirements (PHP API)
- PHP 8.2+ with: pdo_mysql, mbstring, json, curl, fileinfo
- MySQL 8.0+
- Apache with mod_rewrite (or Nginx)
- Composer

## API Setup
git clone ... bsu-foodhub-api && cd bsu-foodhub-api
composer install
cp .env.example .env  # Fill in DB credentials and JWT_SECRET
mysql -u root -p -e "CREATE DATABASE bsu_foodhub CHARACTER SET utf8mb4"
mysql -u root -p bsu_foodhub < database/schema.sql
mysql -u root -p bsu_foodhub < database/seed.sql
mkdir -p uploads/vendors uploads/foods && chmod 755 uploads/

## Flutter Setup
cd bsu-foodhub-app
# Set baseUrl in lib/core/services/api_service.dart
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run

## Test Accounts
| Role    | Email                 | Password    |
|---------|-----------------------|-------------|
| Admin   | admin@bsu.ac.ug       | Admin@1234  |
| Vendor  | mary@bsu.ug           | Admin@1234  |
| Student | student@bsu.ac.ug     | Admin@1234  |

Guests can browse without logging in.
```

---

*End of Build Specification — BSU FoodHub v2.0 (Flutter + PHP API + MySQL)*  
*Bishop Stuart University — Faculty of Applied Engineering & Sciences Technology*
