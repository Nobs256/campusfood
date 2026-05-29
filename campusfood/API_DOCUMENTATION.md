# BSU FoodHub — API Documentation

This document provides a detailed reference for all API endpoints in the BSU FoodHub system.

**Base URL:** `https://api.yourdomain.com/api/v1`  
**Content-Type:** `application/json` (unless specified as `multipart/form-data`)

---

## 1. Authentication

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| POST | `/auth/login` | None | Authenticates a user. Returns `access_token`, `refresh_token`, `user`, and `vendor` data (if applicable). |
| POST | `/auth/register` | None | Registers a new student or vendor. |
| POST | `/auth/refresh` | None | Exchanges a valid `refresh_token` for a new pair of tokens. |
| POST | `/auth/logout` | JWT | Invalidates the provided `refresh_token`. |
| POST | `/auth/change-password` | JWT | Updates the authenticated user's password. |

### Request Payloads (Auth)

- **Login:** `{ "email": "...", "password": "..." }`
- **Register:** `{ "full_name": "...", "email": "...", "password": "...", "type": "student|vendor", "phone": "...", "business_name": "...", "location": "..." }`

---

## 2. Vendors & Foods (Public)

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/vendors` | None | Lists approved vendors. Query params: `status`, `page`. |
| GET | `/vendors/{id}` | None | Fetches full profile for a specific vendor including their menu. |
| GET | `/foods` | None | Lists food items. Query params: `vendor_id`, `category_id`, `available`, `sort`, `page`. |
| GET | `/foods/featured` | None | Returns a list of featured food items. |
| GET | `/foods/{id}` | None | Returns full details for a specific food item and its vendor info. |

---

## 3. Search & Discovery (Public)

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/search` | None | Global search across foods and vendors. Query params: `q`, `category_id`, `min_price`, `max_price`, `available`, `sort`, `page`. |
| GET | `/search/autocomplete` | None | Returns quick suggestions while typing. Query param: `q`. |
| GET | `/recommend` | None | Budget-based recommendations. Query params: `budget`, `category_id`. |
| GET | `/compare` | None | Returns comparison data for up to 4 food items. Query param: `ids` (comma-separated). |

---

## 4. Ratings & Feedback

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/foods/{id}/ratings` | None | Returns paginated reviews for a food item. |
| POST | `/foods/{id}/ratings` | Optional | Submits a rating (1-5 stars) and comment. Tracked by user ID if logged in, otherwise by IP. |

---

## 5. Student Features

| Method | Endpoint | Auth | Role | Description |
|--------|----------|------|------|-------------|
| GET | `/favorites` | JWT | Student | Returns the student's list of saved food items. |
| POST | `/favorites/{foodId}` | JWT | Student | Toggles a food item in/out of the student's favorites. |
| GET | `/student/profile` | JWT | Student | Returns detailed student profile data. |
| PUT | `/student/profile` | JWT | Student | Updates student's basic information. |
| GET | `/student/ratings` | JWT | Student | Returns all ratings submitted by the student. |

---

## 6. Vendor Management

| Method | Endpoint | Auth | Role | Description |
|--------|----------|------|------|-------------|
| GET | `/vendor/dashboard` | JWT | Vendor | Returns vendor-specific stats (views, items, ratings). |
| GET | `/vendor/menu` | JWT | Vendor | Lists all menu items belonging to the vendor. |
| POST | `/foods` | JWT | Vendor | Adds a new food item (supports image upload). |
| PUT | `/foods/{id}` | JWT | Vendor | Updates an existing food item. |
| DELETE | `/foods/{id}` | JWT | Vendor | Removes a food item from the menu. |
| PATCH | `/foods/{id}/availability` | JWT | Vendor | Toggles the `is_available` status of an item. |
| PUT | `/vendors/me` | JWT | Vendor | Updates vendor profile text fields. |
| POST | `/vendors/me/images` | JWT | Vendor | Uploads/updates profile or banner images. |
| GET | `/vendor/feedback` | JWT | Vendor | Returns all ratings left on the vendor's items. |
| GET | `/vendor/notifications` | JWT | Vendor | Returns admin notifications (e.g., approval/warnings). |

---

## 7. Admin Oversight

| Method | Endpoint | Auth | Role | Description |
|--------|----------|------|------|-------------|
| GET | `/admin/dashboard` | JWT | Admin | Returns platform-wide analytics and pending tasks. |
| GET | `/admin/vendors` | JWT | Admin | Lists vendors with filtering by status. |
| GET | `/admin/vendors/{id}` | JWT | Admin | Returns comprehensive vendor detail including owner info. |
| POST | `/admin/vendors/{id}/action` | JWT | Admin | Approve, reject, block, or unblock a vendor. |
| GET | `/admin/students` | JWT | Admin | Lists registered students. |
| POST | `/admin/students/{id}/toggle` | JWT | Admin | Activates/deactivates a student account. |
| GET | `/admin/reports` | JWT | Admin | Returns data for visualization (charts). Query params: `from`, `to`. |
| GET | `/admin/reports/export` | JWT | Admin | Triggers a CSV download of platform data. |
| GET | `/categories` | None | Public | Returns all food categories. |
| POST | `/categories` | JWT | Admin | Creates a new food category. |
| PUT | `/categories/{id}` | JWT | Admin | Updates an existing category. |
| DELETE | `/categories/{id}` | JWT | Admin | Deletes a category. |

---

## 8. Standard Response Structure

All responses return a JSON object with the following top-level keys:

### Success Response
```json
{
  "success": true,
  "data": { ... }
}
```

### Error Response
```json
{
  "success": false,
  "message": "Human-readable error message",
  "errors": [] 
}
```

### Paginated Response
```json
{
  "success": true,
  "data": [ ... ],
  "meta": {
    "total": 100,
    "page": 1,
    "per_page": 15,
    "last_page": 7
  }
}
```

---

## 9. Security

- **Authentication:** Most state-changing operations require a JWT. Include it in the header as:  
  `Authorization: Bearer <access_token>`
- **Sanitization:** All inputs are sanitized on the server to prevent XSS and SQL Injection.
- **Rate Limiting:** Login attempts are limited to 5 failures every 15 minutes.
- **Uploads:** File uploads are limited to 3MB and must be image types (JPEG, PNG, WebP).