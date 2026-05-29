<?php
class Response {
    public static function json($data, int $code = 200) {
        $data = self::formatData($data);
        http_response_code($code);
        header('Content-Type: application/json');
        echo json_encode(['success' => true, 'data' => $data]);
        exit;
    }
    public static function error(string $message, int $code = 400, array $errors = []) {
        http_response_code($code);
        header('Content-Type: application/json');
        echo json_encode(['success' => false, 'message' => $message, 'errors' => $errors]);
        exit;
    }
    public static function paginated(array $data, int $total, int $page, int $perPage) {
        $data = self::formatData($data);
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

    /**
     * Recursively traverses data to apply type casting and formatting via helpers.
     * This ensures database strings are converted to proper PHP types (int, float, bool)
     * automatically even in nested response structures.
     */
    private static function formatData($data) {
        if (!is_array($data)) {
            return $data;
        }

        // Detect if array is associative (represents a record object) or sequential (a list)
        $isAssoc = (array() !== $data) && (array_keys($data) !== range(0, count($data) - 1));

        if ($isAssoc) {
            // Use global helper to cast types for this specific item
            formatResponseItem($data);
            
            // Recurse into properties to format nested objects or lists
            foreach ($data as $key => $value) {
                $data[$key] = self::formatData($value);
            }
        } else {
            // Recurse into each element of a sequential list
            foreach ($data as $key => $value) {
                $data[$key] = self::formatData($value);
            }
        }

        return $data;
    }
}