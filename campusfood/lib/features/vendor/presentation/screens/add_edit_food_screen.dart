import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campusfood/core/constants/app_colors.dart';
import 'package:campusfood/core/constants/app_text_styles.dart';
import 'package:campusfood/core/services/api_service.dart';
import 'package:campusfood/features/browse/presentation/providers/foods_provider.dart';
import 'package:campusfood/features/vendor/presentation/providers/vendor_provider.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

class AddEditFoodScreen extends ConsumerStatefulWidget {
  final int? foodId;
  const AddEditFoodScreen({super.key, this.foodId});

  @override
  ConsumerState<AddEditFoodScreen> createState() => _AddEditFoodScreenState();
}

class _AddEditFoodScreenState extends ConsumerState<AddEditFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _servingSizeController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _tagsController = TextEditingController();

  int? _selectedCategoryId;
  bool _isAvailable = true;
  bool _isFeatured = false;
  String? _existingImageUrl;
  File? _selectedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.foodId != null) {
      _loadFoodData();
    }
  }

  Future<void> _loadFoodData() async {
    final menu = await ref.read(vendorMenuProvider.future);
    final food = menu.firstWhere((f) => f.id == widget.foodId);
    setState(() {
      _nameController.text = food.name;
      _priceController.text = food.price.toStringAsFixed(0);
      _descriptionController.text = food.description ?? '';
      _servingSizeController.text = food.servingSize ?? '';
      _caloriesController.text = food.calories?.toString() ?? '';
      _tagsController.text = food.tags?.join(', ') ?? '';
      _selectedCategoryId = food.categoryId;
      _isAvailable = food.isAvailable;
      _isFeatured = food.isFeatured ?? false;
      _existingImageUrl = food.imageUrl;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
    );
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a category')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final api = ref.read(apiServiceProvider);

      final Map<String, dynamic> data = {
        'name': _nameController.text.trim(),
        'price': double.parse(_priceController.text),
        'category_id': _selectedCategoryId,
        'description': _descriptionController.text.trim(),
        'serving_size': _servingSizeController.text.trim(),
        'calories': int.tryParse(_caloriesController.text),
        'tags': _tagsController.text.trim(),
        'is_available': _isAvailable ? 1 : 0,
        'is_featured': _isFeatured ? 1 : 0,
      };

      if (_selectedImage != null) {
        final formDataMap = {
          ...data,
          'image': await MultipartFile.fromFile(_selectedImage!.path),
        };
        final formData = FormData.fromMap(formDataMap);
        if (widget.foodId == null) {
          await api.post('/foods', data: formData);
        } else {
          await api.post('/foods/${widget.foodId}?_method=PUT', data: formData);
        }
      } else {
        if (widget.foodId == null) {
          await api.post('/foods', data: data);
        } else {
          await api.put('/foods/${widget.foodId}', data: data);
        }
      }

      ref.invalidate(vendorMenuProvider);
      ref.invalidate(vendorDashboardProvider);
      if (mounted) context.pop();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesListProvider);
    final title = widget.foodId == null ? 'Add Food Item' : 'Edit Food Item';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
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
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: 180,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child:
                              _selectedImage != null
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      _selectedImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                  : _existingImageUrl != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.network(
                                            _existingImageUrl!,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                  : const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_a_photo_outlined,
                                        size: 40,
                                        color: AppColors.textMuted,
                                      ),
                                      Gap(8),
                                      Text('Add Food Image'),
                                    ],
                                  ),
                        ),
                      ),
                      const Gap(24),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Food Name',
                          border: OutlineInputBorder(),
                        ),
                        validator:
                            (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      const Gap(16),
                      categoriesAsync.when(
                        data:
                            (list) => DropdownButtonFormField<int>(
                              value: _selectedCategoryId,
                              decoration: const InputDecoration(
                                labelText: 'Category',
                                border: OutlineInputBorder(),
                              ),
                              items:
                                  list
                                      .map(
                                        (c) => DropdownMenuItem(
                                          value: c.id,
                                          child: Text('${c.icon} ${c.name}'),
                                        ),
                                      )
                                      .toList(),
                              onChanged:
                                  (v) =>
                                      setState(() => _selectedCategoryId = v),
                              validator: (v) => v == null ? 'Required' : null,
                            ),
                        loading: () => const LinearProgressIndicator(),
                        error:
                            (_, __) => const Text('Error loading categories'),
                      ),
                      const Gap(16),
                      TextFormField(
                        controller: _priceController,
                        decoration: const InputDecoration(
                          labelText: 'Price (UGX)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator:
                            (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      const Gap(16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const Gap(16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _servingSizeController,
                              decoration: const InputDecoration(
                                labelText: 'Serving Size',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const Gap(16),
                          Expanded(
                            child: TextFormField(
                              controller: _caloriesController,
                              decoration: const InputDecoration(
                                labelText: 'Calories',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const Gap(16),
                      TextFormField(
                        controller: _tagsController,
                        decoration: const InputDecoration(
                          labelText: 'Tags (comma separated)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const Gap(16),
                      SwitchListTile(
                        title: const Text('Available for Sale'),
                        value: _isAvailable,
                        activeColor: AppColors.success,
                        onChanged: (v) => setState(() => _isAvailable = v),
                      ),
                      SwitchListTile(
                        title: const Text('Mark as Featured'),
                        value: _isFeatured,
                        activeColor: AppColors.primary,
                        onChanged: (v) => setState(() => _isFeatured = v),
                      ),
                      const Gap(32),
                      ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Save Food Item'),
                      ),
                      const Gap(16),
                      if (widget.foodId != null)
                        OutlinedButton(
                          onPressed: () async {
                            final ok = await showDialog<bool>(
                              context: context,
                              builder:
                                  (c) => AlertDialog(
                                    title: const Text('Delete Item?'),
                                    content: const Text(
                                      'This action cannot be undone.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed:
                                            () => Navigator.pop(c, false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(c, true),
                                        child: const Text(
                                          'Delete',
                                          style: TextStyle(
                                            color: AppColors.error,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            );
                            if (ok == true) {
                              await ref
                                  .read(apiServiceProvider)
                                  .delete('/foods/${widget.foodId}');
                              ref.invalidate(vendorMenuProvider);
                              if (mounted) context.pop();
                            }
                          },
                          child: const Text(
                            'Delete Item',
                            style: TextStyle(color: AppColors.error),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
    );
  }
}
