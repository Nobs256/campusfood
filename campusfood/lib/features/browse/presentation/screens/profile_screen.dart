import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campusfood/core/constants/app_colors.dart';
import 'package:campusfood/features/auth/presentation/providers/auth_provider.dart';
import 'package:campusfood/core/services/auth_service.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider);
    final isLoggedIn = user != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Gap(32),
            // Profile Header Section
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primaryLight,
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: AppColors.primary,
                    ),
                  ),
                  const Gap(16),
                  if (isLoggedIn) ...[
                    Text(
                      user.fullName,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      user.email,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const Gap(8),
                    Chip(
                      label: Text(user.role.toUpperCase()),
                      backgroundColor: AppColors.primaryLight,
                      labelStyle: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold),
                    ),
                  ] else ...[
                    const Text(
                      'Guest User',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                      child: Text(
                        'Log in to save favorites and rate your meals!',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Gap(32),
            const Divider(height: 1),
            
            // Menu Section
            _buildTile(
              icon: Icons.share_outlined,
              title: 'Share BSU FoodHub',
              onTap: () {
                Share.share('Find the best food at BSU with BSU FoodHub! Download now: https://bsufoodhub.ac.ug');
              },
            ),
            _buildTile(
              icon: Icons.info_outline,
              title: 'About the App',
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'BSU FoodHub',
                  applicationVersion: '1.0.0',
                  applicationLegalese: '© 2024 Bishop Stuart University',
                  applicationIcon: const Icon(Icons.restaurant, color: AppColors.primary),
                );
              },
            ),
            _buildTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              onTap: () async {
                final url = Uri.parse('https://bsufoodhub.ac.ug/privacy');
                if (await canLaunchUrl(url)) await launchUrl(url);
              },
            ),
            
            if (isLoggedIn)
              _buildTile(
                icon: Icons.logout,
                title: 'Logout',
                textColor: AppColors.error,
                onTap: () async {
                  await ref.read(authServiceProvider).logout();
                  if (context.mounted) context.go('/login');
                },
              )
            else
              _buildTile(
                icon: Icons.login,
                title: 'Login or Register',
                textColor: AppColors.primary,
                onTap: () => context.push('/login'),
              ),
              
            _buildTile(
              icon: Icons.exit_to_app,
              title: 'Exit App',
              onTap: () => SystemNavigator.pop(),
            ),
            
            const Gap(40),
            const Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }

  Widget _buildTile({required IconData icon, required String title, required VoidCallback onTap, Color? textColor}) {
    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}