import 'package:flutter/material.dart';

import '../models/models.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  final FoodCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    final colorScheme = Theme.of(context).colorScheme;

    final icon = switch (category.name) {
      economyClass => Icons.local_taxi,
      comfortClass => Icons.airport_shuttle,
      premiumClass => Icons.workspace_premium,
      electricClass => Icons.electric_car,
      _ => Icons.directions_car_filled,
    };

    return Card(
      color: isSelected
          ? colorScheme.primaryContainer
          : colorScheme.surfaceContainerHighest,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: isSelected
                    ? colorScheme.primary
                    : colorScheme.primaryContainer,
                child: Icon(
                  icon,
                  color: isSelected
                      ? colorScheme.onPrimary
                      : colorScheme.primary,
                ),
              ),
              const Spacer(),
              Text(category.name, style: textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                '${category.numberOfRestaurants} vehicles ready nearby',
                style: textTheme.bodySmall,
              ),
              const SizedBox(height: 10),
              Text(
                isSelected ? 'Showing now' : 'View cars',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
