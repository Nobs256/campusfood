import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campusfood/core/constants/app_colors.dart';
import 'package:campusfood/core/constants/app_text_styles.dart';
import 'package:campusfood/core/services/api_service.dart';
import 'package:campusfood/core/utils/validators.dart';
import 'package:campusfood/features/auth/presentation/providers/auth_provider.dart';
import 'package:campusfood/features/browse/domainModels/vendor.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';

class VendorProfileEditScreen extends ConsumerStatefulWidget {
  const VendorProfileEditScreen({super.key});

  @override
  ConsumerState<VendorProfileEditScreen> createState() =>
      _VendorProfileEditScreenState();
}

class _VendorProfileEditScreenState
    extends ConsumerState<VendorProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _phoneController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _openingTimeController = TextEditingController();
  final _closingTimeController = TextEditingController();

  File? _profileImageFile;
  File? _bannerImageFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadVendorData();
  }

  void _loadVendorData() {
    final vendor = ref.read(authStateProvider)?.vendor;
    if (vendor != null) {
      _descriptionController.text = vendor.description ?? '';
      _locationController.text = vendor.location;
      _phoneController.text = vendor.phone ?? '';
      _whatsappController.text = vendor.whatsapp ?? '';
      _openingTimeController.text = vendor.openingTime ?? '';
      _closingTimeController.text = vendor.closingTime ?? '';
    }
  }

  Future<void> _pickImage(ImageSource source, {required bool isProfile}) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, maxWidth: 1024);
    if (pickedFile != null) {
      setState(() {
        if (isProfile) {
          _profileImageFile = File(pickedFile.path);
        } else {
          _bannerImageFile = File(pickedFile.path);
        }
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final api = ref.read(apiServiceProvider);
      final authNotifier = ref.read(authStateProvider.notifier);
      final currentVendor = authNotifier.state?.vendor;

      // Update text fields
      final Map<String, dynamic> data = {
        'description': _descriptionController.text.trim(),
        'location': _locationController.text.trim(),
        'phone': _phoneController.text.trim(),
        'whatsapp': _whatsappController.text.trim(),
        'opening_time': _openingTimeController.text.trim(),
        'closing_time': _closingTimeController.text.trim(),
      };
      await api.put('/vendors/me', data: data);

      // Upload profile image if selected
      if (_profileImageFile != null) {
        await api.uploadFile(
          '/vendors/me/images',
          _profileImageFile!,
          'profile_image',
        );
      }

      // Upload banner image if selected
      if (_bannerImageFile != null) {
        await api.uploadFile(
          '/vendors/me/images',
          _bannerImageFile!,
          'banner_image',
        );
      }

      // Re-fetch user data to update local state with new vendor info
      await authNotifier.login(
        authNotifier.state!.email,
        '',
      ); // Password not needed for profile refresh

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        context.pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error updating profile: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vendor = ref.watch(authStateProvider)?.vendor;
    if (vendor == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Profile')),
        body: const Center(child: Text('Vendor data not found.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Vendor Profile')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Banner Image
                      GestureDetector(
                        onTap:
                            () => _pickImage(
                              ImageSource.gallery,
                              isProfile: false,
                            ),
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                            image:
                                _bannerImageFile != null
                                    ? DecorationImage(
                                      image: FileImage(_bannerImageFile!),
                                      fit: BoxFit.cover,
                                    )
                                    : (vendor.bannerImage != null
                                        ? DecorationImage(
                                          image: CachedNetworkImageProvider(
                                            vendor.bannerImage!,
                                          ),
                                          fit: BoxFit.cover,
                                        )
                                        : null),
                          ),
                          child:
                              _bannerImageFile == null &&
                                      vendor.bannerImage == null
                                  ? const Icon(
                                    Icons.add_photo_alternate,
                                    size: 40,
                                    color: AppColors.textMuted,
                                  )
                                  : null,
                        ),
                      ),
                      const Gap(16),
                      // Profile Image
                      Center(
                        child: GestureDetector(
                          onTap:
                              () => _pickImage(
                                ImageSource.gallery,
                                isProfile: true,
                              ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: AppColors.background,
                            backgroundImage:
                                _profileImageFile != null
                                    ? FileImage(_profileImageFile!)
                                    : (vendor.profileImage != null
                                            ? CachedNetworkImageProvider(
                                              vendor.profileImage!,
                                            )
                                            : null)
                                        as ImageProvider?,
                            child:
                                _profileImageFile == null &&
                                        vendor.profileImage == null
                                    ? const Icon(
                                      Icons.person,
                                      size: 60,
                                      color: AppColors.textMuted,
                                    )
                                    : null,
                          ),
                        ),
                      ),
                      const Gap(24),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const Gap(16),
                      TextFormField(
                        controller: _locationController,
                        decoration: const InputDecoration(
                          labelText: 'Location',
                          border: OutlineInputBorder(),
                        ),
                        validator:
                            (v) =>
                                AppValidators.validateRequired(v, 'Location'),
                      ),
                      const Gap(16),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const Gap(16),
                      TextFormField(
                        controller: _whatsappController,
                        decoration: const InputDecoration(
                          labelText: 'WhatsApp Number',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const Gap(16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _openingTimeController,
                              decoration: const InputDecoration(
                                labelText: 'Opening Time (HH:MM)',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.datetime,
                            ),
                          ),
                          const Gap(16),
                          Expanded(
                            child: TextFormField(
                              controller: _closingTimeController,
                              decoration: const InputDecoration(
                                labelText: 'Closing Time (HH:MM)',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.datetime,
                            ),
                          ),
                        ],
                      ),
                      const Gap(32),
                      ElevatedButton(
                        onPressed: _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Save Profile'),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
