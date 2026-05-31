import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campusfood/core/constants/app_colors.dart';
import 'package:campusfood/core/constants/app_strings.dart';
import 'package:campusfood/core/constants/app_text_styles.dart';
import 'package:campusfood/core/utils/validators.dart';
import 'package:campusfood/features/auth/presentation/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:gap/gap.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _locationController = TextEditingController();

  XFile? _avatarFile;
  XFile? _profileImageFile;
  XFile? _bannerImageFile;

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _businessNameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source, String type) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: source, maxWidth: 1024);
    if (file != null) {
      setState(() {
        if (type == 'avatar') _avatarFile = file;
        if (type == 'profile') _profileImageFile = file;
        if (type == 'banner') _bannerImageFile = file;
      });
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final bool isVendor = _tabController.index == 1;
      await ref
          .read(authStateProvider.notifier)
          .register(
            fullName: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
            type: isVendor ? 'vendor' : 'student',
            phone: _phoneController.text.trim(),
            businessName: isVendor ? _businessNameController.text.trim() : null,
            location: isVendor ? _locationController.text.trim() : null,
            avatarPath: _avatarFile?.path,
            profileImagePath: _profileImageFile?.path,
            bannerImagePath: _bannerImageFile?.path,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful! Please login.'),
          ),
        );
        context.go('/login');
      }
    } on DioException catch (e) {
      String message = 'Registration failed. Please try again.';
      if (e.response?.data is Map) {
        message = e.response?.data['message'] ?? message;
      }
      setState(() => _errorMessage = message);
    } catch (e) {
      setState(
        () => _errorMessage = 'An unexpected error occurred. Please try again.',
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.register),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          tabs: const [Tab(text: 'Student'), Tab(text: 'Vendor')],
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_errorMessage != null) ...[
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: AppColors.error),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(16),
                ],
                // Profile Image Selection
                Center(
                  child: GestureDetector(
                    onTap: () => _pickImage(ImageSource.gallery, 'avatar'),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: AppColors.background,
                          backgroundImage:
                              _avatarFile != null
                                  ? FileImage(File(_avatarFile!.path))
                                  : null,
                          child:
                              _avatarFile == null
                                  ? const Icon(Icons.add_a_photo, size: 40)
                                  : null,
                        ),
                        if (_avatarFile != null)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const Gap(24),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: AppStrings.fullName,
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (v) => AppValidators.validateRequired(v, 'Full Name'),
                ),
                const Gap(16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: AppStrings.email,
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: AppValidators.validateEmail,
                ),
                const Gap(16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: AppStrings.password,
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: AppValidators.validatePassword,
                ),
                const Gap(16),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: AppStrings.phone,
                    prefixIcon: Icon(Icons.phone_outlined),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: AppValidators.validatePhone,
                ),

                // Vendor specific fields
                AnimatedBuilder(
                  animation: _tabController,
                  builder: (context, _) {
                    if (_tabController.index == 0) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      children: [
                        const Gap(16),
                        const Text('Vendor Images', style: AppTextStyles.label),
                        const Gap(8),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  const Text(
                                    'Profile',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  const Gap(4),
                                  GestureDetector(
                                    onTap:
                                        () => _pickImage(
                                          ImageSource.gallery,
                                          'profile',
                                        ),
                                    child: Container(
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: AppColors.background,
                                        borderRadius: BorderRadius.circular(8),
                                        image:
                                            _profileImageFile != null
                                                ? DecorationImage(
                                                  image: FileImage(
                                                    File(
                                                      _profileImageFile!.path,
                                                    ),
                                                  ),
                                                  fit: BoxFit.cover,
                                                )
                                                : null,
                                      ),
                                      child:
                                          _profileImageFile == null
                                              ? const Icon(
                                                Icons.add_photo_alternate,
                                              )
                                              : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(16),
                            Expanded(
                              child: Column(
                                children: [
                                  const Text(
                                    'Banner',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  const Gap(4),
                                  GestureDetector(
                                    onTap:
                                        () => _pickImage(
                                          ImageSource.gallery,
                                          'banner',
                                        ),
                                    child: Container(
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: AppColors.background,
                                        borderRadius: BorderRadius.circular(8),
                                        image:
                                            _bannerImageFile != null
                                                ? DecorationImage(
                                                  image: FileImage(
                                                    File(
                                                      _bannerImageFile!.path,
                                                    ),
                                                  ),
                                                  fit: BoxFit.cover,
                                                )
                                                : null,
                                      ),
                                      child:
                                          _bannerImageFile == null
                                              ? const Icon(
                                                Icons.add_photo_alternate,
                                              )
                                              : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Gap(16),
                        TextFormField(
                          controller: _businessNameController,
                          decoration: const InputDecoration(
                            labelText: AppStrings.businessName,
                            prefixIcon: Icon(Icons.storefront_outlined),
                            border: OutlineInputBorder(),
                          ),
                          validator:
                              (v) =>
                                  _tabController.index == 1
                                      ? AppValidators.validateRequired(
                                        v,
                                        'Business Name',
                                      )
                                      : null,
                        ),
                        const Gap(16),
                        TextFormField(
                          controller: _locationController,
                          decoration: const InputDecoration(
                            labelText: AppStrings.location,
                            prefixIcon: Icon(Icons.location_on_outlined),
                            border: OutlineInputBorder(),
                          ),
                          validator:
                              (v) =>
                                  _tabController.index == 1
                                      ? AppValidators.validateRequired(
                                        v,
                                        'Location',
                                      )
                                      : null,
                        ),
                      ],
                    );
                  },
                ),

                const Gap(32),
                ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child:
                      _isLoading
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Text(AppStrings.register),
                ),
                const Gap(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
