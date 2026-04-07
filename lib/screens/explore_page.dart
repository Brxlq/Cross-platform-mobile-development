import 'package:flutter/material.dart';

import '../api/mock_yummy_service.dart';
import '../components/components.dart';
import '../models/models.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({
    super.key,
    required this.cartManager,
    required this.orderManager,
  });

  final CartManager cartManager;
  final OrderManager orderManager;

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final mockService = MockYummyService();
  String selectedCategory = economyClass;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: mockService.getExploreData(),
      builder: (context, AsyncSnapshot<ExploreData> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        final allRestaurants = snapshot.data?.restaurants ?? [];
        final categories = snapshot.data?.categories ?? [];
        final posts = snapshot.data?.friendPosts ?? [];
        final restaurants = allRestaurants
            .where((restaurant) => restaurant.vehicleClass == selectedCategory)
            .toList();

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            const _DiscoverHero(),
            const SizedBox(height: 20),
            CategorySection(
              categories: categories,
              selectedCategory: selectedCategory,
              onCategorySelected: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
            ),
            const SizedBox(height: 20),
            RestaurantSection(
              restaurants: restaurants,
              cartManager: widget.cartManager,
              orderManager: widget.orderManager,
              selectedCategory: selectedCategory,
            ),
            const SizedBox(height: 20),
            PostSection(posts: posts),
          ],
        );
      },
    );
  }
}

class _DiscoverHero extends StatelessWidget {
  const _DiscoverHero();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0B1220), Color(0xFF123B72)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose a class, compare real cars, and rent in minutes.',
            style: textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Echelon organizes the fleet by Economy, Comfort, Premium, '
            'and Electric so you can jump straight to the ride that fits '
            'your trip.',
            style: textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.78),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          const Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _MetricCard(value: '3 min', label: 'average unlock time'),
              _MetricCard(value: '4', label: 'fleet classes'),
              _MetricCard(value: '24/7', label: 'concierge support'),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0x1AFFFFFF),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0x33FFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
