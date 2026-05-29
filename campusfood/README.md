# BSU FoodHub — Campus Food Information System

BSU FoodHub is a centralized food discovery platform for Bishop Stuart University (BSU). It allows students to browse vendors, compare prices, and get budget recommendations, while enabling vendors to manage their menus and admins to oversee the platform.

**Note:** This system is for information and discovery only. It does not handle ordering or payments.

---

## 1. Architecture Overview
The project follows a decoupled client-server architecture:
- **Frontend:** Flutter mobile application (iOS & Android).
- **Backend:** Pure PHP 8.2+ REST API using PDO for MySQL interaction.
- **Database:** MySQL 8.0+.
- **Communication:** JSON over HTTPS with JWT-based authentication.

---

## 2. Core Features
- **Food Discovery:** Browse vendors and food items by category.
- **Search & Filters:** Robust search with price range, availability, and category filters.
- **Budget Recommendations:** Get food suggestions based on a specific budget.
- **Comparison Engine:** Side-by-side comparison of up to 4 food items.
- **Ratings & Reviews:** Students and guests can leave feedback on meals.
- **Vendor Management:** Vendors can register, manage menus, and toggle item availability.
- **Admin Oversight:** Admins approve/reject vendors and monitor platform analytics through reports.

---

## 3. User Roles
| Role | Permissions |
|------|-------------|
| **Guest** | Browse, search, compare foods, view budget recommendations. |
| **Student** | Guest features + save favorites, submit ratings/comments. |
| **Vendor** | Manage own profile and menu (add/edit/delete), view feedback. |
| **Admin** | Approve vendors, manage categories, view analytics/reports. |

---

## 4. Tech Stack

### Frontend (Flutter)
- **State Management:** Riverpod (using `riverpod_generator`).
- **Navigation:** GoRouter.
- **Networking:** Dio with JWT Interceptors.
- **Local Storage:** `flutter_secure_storage`.
- **Charts:** `fl_chart`.

### Backend (PHP)
- **Language:** PHP 8.2+.
- **Auth:** JWT (`firebase/php-jwt`).
- **Environment:** `vlucas/phpdotenv`.
- **Image Processing:** Native PHP file handling.

---

## 5. Project Structure

### Flutter App (`/lib`)
- `core/`: Constants (colors, styles), services (API, Auth), and utilities.
- `features/`: Modularized features (auth, browse, vendor, student, admin).
- `router/`: GoRouter configuration and role-based redirects.
- `sharedWidgets/`: Reusable UI components like loaders and cards.

### PHP API (`/bsu-foodhub-api`)
- `core/`: Database singleton, Router, and helper classes.
- `controllers/`: Logic for Auth, Foods, Vendors, Ratings, and Admin actions.
- `middleware/`: Auth and Role verification.
- `database/`: SQL schema and seed files.

---

## 6. Setup Instructions

### Backend Setup
1.  **Requirements:** PHP 8.2+, MySQL 8.0+, Composer.
2.  **Install Dependencies:** Run `composer install` in the API directory.
3.  **Environment:** Copy `.env.example` to `.env` and configure your database and `JWT_SECRET`.
4.  **Database:**
    -   Create a database named `bsu_foodhub`.
    -   Import `database/schema.sql`.
    -   Import `database/seed.sql` for initial data.
5.  **File Permissions:** Ensure `uploads/` directories are writable.

### Flutter Setup
1.  **Dependencies:** Run `flutter pub get`.
2.  **Configuration:** Set the `baseUrl` in `lib/core/services/api_service.dart` to your local or hosted API URL.
3.  **Code Generation:** Run the build runner to generate models and providers:
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```
4.  **Run:** `flutter run`.

---

## 7. Development Guidelines

### Code Generation
This project heavily uses `freezed` for models and `riverpod_generator` for state management. Always run the build runner after modifying classes annotated with `@freezed` or `@riverpod`.

### Authentication Flow
- The `ApiService` automatically attaches JWT tokens to requests.
- If an 401 Unauthorized error occurs, the interceptor attempts to refresh the token using the refresh token stored in secure storage.

### UI & Design System
- Follow the color palette defined in `AppColors`.
- Use the predefined `AppTextStyles` for consistency.
- All cards should have a `borderRadius` of 16 and a thin border instead of heavy elevation.

### API Best Practices
- All API responses follow a standard JSON structure: `{ "success": true, "data": ... }`.
- Use `Auth::required()` in controllers for protected routes.
- Perform input sanitization using the `sanitize()` helper on the backend.

---

## 8. Test Credentials
| Role | Email | Password |
|------|-------|----------|
| **Admin** | `admin@bsu.ac.ug` | `Admin@1234` |
| **Vendor** | `mary@bsu.ug` | `Admin@1234` |
| **Student** | `student@bsu.ac.ug` | `Admin@1234` |

---

*Developed for Bishop Stuart University — Faculty of Applied Engineering & Sciences Technology.*
