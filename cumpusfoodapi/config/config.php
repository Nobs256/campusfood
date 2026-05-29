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