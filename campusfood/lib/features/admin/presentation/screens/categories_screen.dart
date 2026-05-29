import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campusfood/core/constants/app_colors.dart';
import 'package:campusfood/core/constants/app_text_styles.dart';
import 'package:campusfood/features/admin/presentation/providers/admin_provider.dart';
import 'package:campusfood/features/sharedWidgets/error_widget.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(adminCategoriesListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Categories')),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(adminCategoriesListProvider.future),
        child: categoriesAsync.when(
          data:
              (categories) => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Card(
                    child: ListTile(
                      leading: Text(
                        category.icon ?? '📁',
                        style: const TextStyle(fontSize: 24),
                      ),
                      title: Text(
                        category.name,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed:
                                () => _showCategoryDialog(
                                  context,
                                  ref,
                                  category: category,
                                ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: AppColors.error,
                            ),
                            onPressed:
                                () => _confirmDelete(context, ref, category.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error:
              (err, _) => AppErrorWidget(
                message: err.toString(),
                onRetry: () => ref.invalidate(adminCategoriesListProvider),
              ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryDialog(context, ref),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showCategoryDialog(
    BuildContext context,
    WidgetRef ref, {
    dynamic category,
  }) {
    final nameController = TextEditingController(text: category?.name ?? '');
    final iconController = TextEditingController(text: category?.icon ?? '');

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(category == null ? 'Add Category' : 'Edit Category'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: iconController,
                  decoration: const InputDecoration(labelText: 'Icon (Emoji)'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final notifier = ref.read(
                    adminCategoryActionNotifierProvider.notifier,
                  );
                  if (category == null) {
                    notifier.addCategory(
                      nameController.text,
                      iconController.text,
                    );
                  } else {
                    notifier.updateCategory(
                      category.id,
                      nameController.text,
                      iconController.text,
                    );
                  }
                  Navigator.pop(ctx);
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, int id) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Delete Category'),
            content: const Text(
              'Are you sure you want to delete this category?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  ref
                      .read(adminCategoryActionNotifierProvider.notifier)
                      .deleteCategory(id);
                  Navigator.pop(ctx);
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            ],
          ),
    );
  }
}
