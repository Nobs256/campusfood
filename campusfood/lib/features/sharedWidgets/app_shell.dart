import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:campusfood/core/constants/app_colors.dart';
import 'package:campusfood/features/auth/presentation/providers/auth_provider.dart';
import 'package:campusfood/features/browse/presentation/widgets/compare_bottom_bar.dart';

class AppShell extends ConsumerWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final role = authState?.role ?? 'guest';

    return Scaffold(
      appBar: AppBar(
        title: const Text('BSU FoodHub'),
        actions: [
          if (role == 'vendor' || role == 'admin')
            IconButton(
              icon: const Icon(Icons.notifications_none),
              onPressed: () {},
            ),
        ],
      ),
      body: child,
      bottomSheet: const CompareBottomBar(),
      bottomNavigationBar: _buildBottomNav(context, role),
    );
  }

  Widget _buildBottomNav(BuildContext context, String role) {
    final int currentIndex = _calculateSelectedIndex(context, role);

    List<BottomNavigationBarItem> items = [];
    if (role == 'admin') {
      items = const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Admin'),
        BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Vendors'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Reports'),
        BottomNavigationBarItem(
          icon: Icon(Icons.category),
          label: 'Categories',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ];
    } else if (role == 'vendor') {
      items = const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant_menu),
          label: 'Menu',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event_available),
          label: 'Availability',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.feedback), label: 'Feedback'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ];
    } else {
      items = [
        const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        const BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_wallet),
          label: 'Budget',
        ),
        if (role == 'student')
          const BottomNavigationBarItem(
            icon: Icon(Icons.compare_arrows),
            label: 'Compare',
          ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ];
    }

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      selectedItemColor: AppColors.primary,
      items: items,
      onTap: (index) => _onItemTapped(context, index, role),
    );
  }

  int _calculateSelectedIndex(BuildContext context, String role) {
    final String location = GoRouterState.of(context).matchedLocation;
    if (role == 'admin') {
      if (location.startsWith('/admin/dashboard')) return 0;
      if (location.startsWith('/admin/vendors')) return 1;
      if (location.startsWith('/admin/reports')) return 2;
      if (location.startsWith('/admin/categories')) return 3;
      if (location.startsWith('/profile')) return 4;
    } else if (role == 'vendor') {
      if (location.startsWith('/vendor/dashboard')) return 0;
      if (location.startsWith('/vendor/menu')) return 1;
      if (location.startsWith('/vendor/availability')) return 2;
      if (location.startsWith('/vendor/feedback')) return 3;
      if (location.startsWith('/profile')) return 4;
    } else {
      if (location.startsWith('/home')) return 0;
      if (location.startsWith('/search')) return 1;
      if (location.startsWith('/budget')) return 2;
      if (role == 'student') {
        // if (location.startsWith('/student/favorites')) return 3;
        if (location.startsWith('/comparebar')) return 3;
        if (location.startsWith('/profile')) return 4;
      } else {
        if (location.startsWith('/profile')) return 3;
      }
    }
    return 0;
  }

  void _onItemTapped(BuildContext context, int index, String role) {
    if (role == 'admin') {
      final paths = [
        '/admin/dashboard',
        '/admin/vendors',
        '/admin/reports',
        '/admin/categories',
        '/profile',
      ];
      context.go(paths[index]);
    } else if (role == 'vendor') {
      final paths = [
        '/vendor/dashboard',
        '/vendor/menu',
        '/vendor/availability',
        '/vendor/feedback',
        '/profile',
      ];
      context.go(paths[index]);
    } else {
      if (role == 'student') {
        // final paths = ['/home', '/search', '/budget', '/student/favorites', '/profile'];
        final paths = ['/home', '/search', '/budget', '/comparebar', '/profile'];
        context.go(paths[index]);
      } else {
        final paths = ['/home', '/search', '/budget', '/profile'];
        context.go(paths[index]);
      }
    }
  }
}
