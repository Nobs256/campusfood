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