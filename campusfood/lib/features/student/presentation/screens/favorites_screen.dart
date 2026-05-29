import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campusfood/features/student/presentation/providers/student_provider.dart';
import 'package:campusfood/features/browse/presentation/widgets/food_card.dart';
import 'package:campusfood/features/sharedWidgets/empty_state_widget.dart';
import 'package:campusfood/features/sharedWidgets/error_widget.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(studentFavoritesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Favorites')),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(studentFavoritesProvider.future),
        child: favoritesAsync.when(
          data: (favs) {
            if (favs.isEmpty) {
              return const EmptyStateWidget(
                title: 'No Favorites Yet',
                message: 'Tap the heart icon on any meal to save it here.',
                icon: Icons.favorite_border,
              );
            }
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: favs.length,
              itemBuilder: (context, index) => FoodCard(food: favs[index]),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error:
              (err, _) => AppErrorWidget(
                message: err.toString(),
                onRetry: () => ref.invalidate(studentFavoritesProvider),
              ),
        ),
      ),
    );
  }
}
