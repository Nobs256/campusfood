// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:campusfood/core/services/auth_service.dart';
import 'package:campusfood/features/auth/presentation/providers/auth_provider.dart';
import 'package:campusfood/features/auth/presentation/screens/splash_screen.dart';
import 'package:campusfood/features/auth/presentation/screens/login_screen.dart';
import 'package:campusfood/features/auth/presentation/screens/register_screen.dart';
import 'package:campusfood/features/browse/presentation/screens/home_screen.dart';
import 'package:campusfood/features/browse/presentation/screens/vendor_profile_screen.dart';
import 'package:campusfood/features/browse/presentation/screens/food_detail_screen.dart';
import 'package:campusfood/features/browse/presentation/screens/search_screen.dart';
import 'package:campusfood/features/browse/presentation/screens/budget_screen.dart';
import 'package:campusfood/features/browse/presentation/screens/compare_screen.dart';
import 'package:campusfood/features/vendor/presentation/screens/vendor_dashboard_screen.dart';
import 'package:campusfood/features/vendor/presentation/screens/my_menu_screen.dart';
import 'package:campusfood/features/vendor/presentation/screens/availability_screen.dart';
import 'package:campusfood/features/vendor/presentation/screens/add_edit_food_screen.dart';
import 'package:campusfood/features/vendor/presentation/screens/feedback_screen.dart';
import 'package:campusfood/features/vendor/presentation/screens/vendor_profile_edit_screen.dart';
import 'package:campusfood/features/student/presentation/screens/student_dashboard_screen.dart';
import 'package:campusfood/features/student/presentation/screens/favorites_screen.dart';
import 'package:campusfood/features/student/presentation/screens/my_ratings_screen.dart';
import 'package:campusfood/features/admin/presentation/screens/vendor_list_screen.dart';
import 'package:campusfood/features/admin/presentation/screens/vendor_detail_screen.dart';
import 'package:campusfood/features/admin/presentation/screens/categories_screen.dart';
import 'package:campusfood/features/admin/presentation/screens/reports_screen.dart';

import '../features/admin/presentation/screens/admin_dashboard_screen.dart';
import '../features/browse/presentation/screens/compare_bottom_bar.dart';
import '../features/browse/presentation/screens/profile_screen.dart';
import '../features/sharedWidgets/app_shell.dart';

part 'app_router.g.dart';

final navigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  final authService = ref.watch(authServiceProvider);
  // Watch authState to trigger redirects on login/logout
  ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/splash',
    redirect: (context, state) async {
      final loggedIn = await authService.isLoggedIn();
      final path = state.matchedLocation;

      if (path == '/splash') return null;

      final loggingIn = path == '/login' || path == '/register';

      // Allow access to public routes even if not logged in
      final publicRoutes = ['/home', '/search', '/budget', '/profile'];
      final isPublic = publicRoutes.any((route) => path.startsWith(route));

      // Vendor and Food details are also public browse routes
      if (path.startsWith('/vendors/') || path.startsWith('/foods/'))
        return null;

      if (!loggedIn && !loggingIn && !isPublic) return '/login';
      if (loggedIn && loggingIn) return '/home';

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/vendors/:slug',
            builder:
                (_, s) => VendorProfileScreen(slug: s.pathParameters['slug']!),
          ),
          GoRoute(
            path: '/foods/:id',
            builder:
                (_, s) => FoodDetailScreen(
                  foodId: int.parse(s.pathParameters['id']!),
                ),
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: '/budget',
            builder: (context, state) => const BudgetScreen(),
          ),
          GoRoute(
            path: '/compare',
            builder: (context, state) => const CompareScreen(),
          ),
          GoRoute(
            path: '/comparebar',
            builder: (context, state) => const CompareBottomBar(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          // Vendor Routes
          GoRoute(
            path: '/vendor/dashboard',
            builder: (context, state) => const VendorDashboardScreen(),
          ),
          GoRoute(
            path: '/vendor/menu',
            builder: (context, state) => const MyMenuScreen(),
          ),
          GoRoute(
            path: '/vendor/foods/add',
            builder: (context, state) => const AddEditFoodScreen(),
          ),
          GoRoute(
            path: '/vendor/foods/:id/edit',
            builder:
                (context, state) => AddEditFoodScreen(
                  foodId: int.parse(state.pathParameters['id']!),
                ),
          ),
          GoRoute(
            path: '/vendor/availability',
            builder: (context, state) => const AvailabilityScreen(),
          ),
          GoRoute(
            path: '/vendor/feedback',
            builder: (context, state) => const FeedbackScreen(),
          ),
          GoRoute(
            path: '/vendor/profile',
            builder: (context, state) => const VendorProfileEditScreen(),
          ),
          // Admin Routes
          GoRoute(
            path: '/admin/dashboard',
            builder: (context, state) => const AdminDashboardScreen(),
          ),
          GoRoute(
            path: '/admin/vendors',
            builder: (context, state) => const VendorListScreen(),
          ),
          GoRoute(
            path: '/admin/vendors/:id',
            builder:
                (context, state) => VendorDetailScreen(
                  vendorId: int.parse(state.pathParameters['id']!),
                ),
          ),
          GoRoute(
            path: '/admin/categories',
            builder: (context, state) => const CategoriesScreen(),
          ),
          GoRoute(
            path: '/admin/reports',
            builder: (context, state) => const ReportsScreen(),
          ),
          // Student Routes
          GoRoute(
            path: '/student/dashboard',
            builder: (context, state) => const StudentDashboardScreen(),
          ),
          GoRoute(
            path: '/student/favorites',
            builder: (context, state) => const FavoritesScreen(),
          ),
          GoRoute(
            path: '/student/ratings',
            builder: (context, state) => const MyRatingsScreen(),
          ),
        ],
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
    ],
  );
}
