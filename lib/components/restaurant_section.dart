import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants.dart';
import '../models/models.dart';
import 'components.dart';

class RestaurantSection extends StatelessWidget {
  const RestaurantSection({
    super.key,
    required this.restaurants,
    required this.cartManager,
    required this.orderManager,
    required this.selectedCategory,
  });

  final List<Restaurant> restaurants;
  final CartManager cartManager;
  final OrderManager orderManager;
  final String selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedCategory == electricClass
                      ? 'Electric fleet'
                      : '$selectedCategory cars',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Open any car to view details and rent it.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          if (restaurants.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'No vehicles available in this class right now.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            )
          else
            SizedBox(
              height: 270,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: restaurants.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 320,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: RestaurantLandscapeCard(
                        restaurant: restaurants[index],
                        onTap: () {
                          context.go(
                            '/${EchelonTab.discover.value}/vehicle/${restaurants[index].id}',
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
