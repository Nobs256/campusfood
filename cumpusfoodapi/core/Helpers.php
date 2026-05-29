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

/**
 * Automatically casts database strings to correct PHP types for JSON response.
 * Prevents Flutter "type 'String' is not a subtype of type 'num'" errors.
 */
function formatResponseItem(array &$item): void {
    $ints = ['id', 'user_id', 'vendor_id', 'category_id', 'total_ratings', 'views', 'calories', 'stars', 'count', 'food_count', 'food_id', 'expires_in', 'sort_order', 'total_items', 'available_items', 'views_today', 'item_count'];
    $floats = ['price', 'avg_rating', 'budget', 'min_price', 'max_price', 'avg_site_rating'];
    
    foreach ($item as $key => $val) {
        if ($val === null) continue;

        if (in_array($key, $ints)) {
            $item[$key] = (int)$val;
        } elseif (in_array($key, $floats)) {
            $item[$key] = (float)$val;
        } elseif (strpos($key, 'is_') === 0) {
            $item[$key] = (bool)$val;
        } elseif ($key === 'tags' && is_string($val)) {
            $item[$key] = $val ? explode(',', $val) : [];
        }
    }

    // Automatically calculate is_open if time fields are present
    if (isset($item['opening_time']) && isset($item['closing_time'])) {
        $item['is_open'] = isVendorOpen((string)$item['opening_time'], (string)$item['closing_time']);
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