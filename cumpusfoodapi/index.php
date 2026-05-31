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

// $uri    = preg_replace('#^/api/v1#', '', strtok(parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH), '?'));
$uri    = strtok(parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH), '?');

// Remove the base project directory from the URI (e.g., /meditrack-api)
$basePath = dirname($_SERVER['SCRIPT_NAME']);
if ($basePath !== '/' && strpos($uri, $basePath) === 0) {
    $uri = substr($uri, strlen($basePath));
}

$uri    = preg_replace('#^/api/v1#', '', $uri);
$method = $_SERVER['REQUEST_METHOD'];

// Support method spoofing for multipart PUT/PATCH requests via POST
if ($method === 'POST' && isset($_REQUEST['_method'])) {
    $method = strtoupper($_REQUEST['_method']);
}

// Route table: [METHOD, pattern, controller, action, auth_required, roles]
$routes = [
  // Auth
  ['POST', '/auth/login',              'AuthController',        'login',            false, []],
  ['POST', '/auth/register',           'AuthController',        'register',         false, []],
  ['POST', '/auth/refresh',            'AuthController',        'refresh',          false, []],
  ['POST', '/auth/logout',             'AuthController',        'logout',           true,  []],
  ['POST', '/auth/change-password',    'AuthController',        'changePassword',   true,  []],

  // Vendors
  ['GET',  '/vendors',                 'VendorController',      'index',            false, []],
  ['GET',  '/vendors/{id}',            'VendorController',      'show',             false, []],
  ['POST', '/vendors',                 'VendorController',      'store',            false, []],
  ['PUT',  '/vendors/me',              'VendorController',      'updateProfile',    true,  ['vendor']],
  ['POST', '/vendors/me/images',       'VendorController',      'uploadImages',     true,  ['vendor']],

  // Food Items
  ['GET',  '/foods',                   'FoodController',        'index',            false, []],
  ['GET',  '/foods/featured',          'FoodController',        'featured',         false, []],
  ['GET',  '/foods/{id}',              'FoodController',        'show',             false, []],
  ['POST', '/foods',                   'FoodController',        'store',            true,  ['vendor']],
  ['PUT',  '/foods/{id}',              'FoodController',        'update',           true,  ['vendor']],
  ['DELETE','/foods/{id}',             'FoodController',        'destroy',          true,  ['vendor']],
  ['PATCH','/foods/{id}/availability', 'FoodController',        'toggleAvailability',true, ['vendor']],

  // Dashboard & Menu
  ['GET',  '/vendor/dashboard',        'VendorController',      'dashboard',        true,  ['vendor']],
  ['GET',  '/vendor/menu',             'VendorController',      'myMenu',           true,  ['vendor']],
  ['GET',  '/vendor/feedback',         'VendorController',      'feedback',         true,  ['vendor']],
  ['GET',  '/vendor/notifications',    'VendorController',      'notifications',    true,  ['vendor']],

  // Categories
  ['GET',  '/categories',              'CategoryController',    'index',            false, []],
  ['POST', '/categories',              'CategoryController',    'store',            true,  ['admin']],
  ['PUT',  '/categories/{id}',         'CategoryController',    'update',           true,  ['admin']],
  ['DELETE','/categories/{id}',        'CategoryController',    'destroy',          true,  ['admin']],

  // Search & Discovery
  ['GET',  '/search',                  'SearchController',      'search',           false, []],
  ['GET',  '/search/autocomplete',     'SearchController',      'autocomplete',     false, []],
  ['GET',  '/recommend',               'SearchController',      'recommend',        false, []],
  ['GET',  '/compare',                 'SearchController',      'compare',          false, []],

  // Ratings
  ['GET',  '/foods/{id}/ratings',      'RatingController',      'index',            false, []],
  ['POST', '/foods/{id}/ratings',      'RatingController',      'store',            false, []],

  // Favorites
  ['GET',  '/favorites',               'FavoriteController',    'index',            true,  ['student']],
  ['POST', '/favorites/{foodId}',      'FavoriteController',    'toggle',           true,  ['student']],

  // Student Profile
  ['GET',  '/student/profile',         'AuthController',        'profile',          true,  ['student']],
  ['PUT',  '/student/profile',         'AuthController',        'updateProfile',    true,  ['student']],
  ['GET',  '/student/ratings',         'RatingController',      'myRatings',        true,  ['student']],

  // Notifications
  ['GET',  '/notifications',           'NotificationController','index',            true,  []],
  ['POST', '/notifications/{id}/read', 'NotificationController','markRead',         true,  []],
  ['POST', '/notifications/read-all',  'NotificationController','markAllRead',      true,  []],

  // Admin
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

    $controllerPath = "controllers/{$ctrl}.php";
    if (file_exists($controllerPath)) {
        require_once $controllerPath;
        $instance = new $ctrl($auth);
        call_user_func_array([$instance, $action], $matches);
        exit;
    } else {
        Response::error("Controller $ctrl not found", 500);
    }
}

Response::error('Not found', 404);