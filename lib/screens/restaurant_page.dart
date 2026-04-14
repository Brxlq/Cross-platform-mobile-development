import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../components/components.dart';
import '../constants.dart';
import '../models/models.dart';
import 'checkout_page.dart';

class RestaurantPage extends StatefulWidget {
  const RestaurantPage({
    super.key,
    required this.restaurant,
    required this.cartManager,
    required this.ordersManager,
  });

  final Restaurant restaurant;
  final CartManager cartManager;
  final OrderManager ordersManager;

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  static const double largeScreenPercentage = 0.9;
  static const double maxWidth = 1000;
  static const desktopThreshold = 700;

  String get _heroTag => 'vehicle-image-${widget.restaurant.id}';

  double _calculateConstrainedWidth(double screenWidth) {
    return (screenWidth > desktopThreshold
            ? screenWidth * largeScreenPercentage
            : screenWidth)
        .clamp(0.0, maxWidth);
  }

  int calculateColumnCount(double screenWidth) {
    return screenWidth > desktopThreshold ? 2 : 1;
  }

  CustomScrollView _buildCustomScrollView() {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(),
        _buildInfoSection(),
        _buildGridViewSection('Trip add-ons'),
      ],
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 300,
      flexibleSpace: FlexibleSpaceBar(
        background: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 64),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Hero(
                    tag: _heroTag,
                    child: Image.network(
                      widget.restaurant.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildInfoSection() {
    final textTheme = Theme.of(context).textTheme;
    final restaurant = widget.restaurant;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(restaurant.name, style: textTheme.headlineLarge),
            const SizedBox(height: 8),
            Text(restaurant.address, style: textTheme.bodyMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InfoPill(label: restaurant.vehicleClass),
                _InfoPill(label: restaurant.priceLabel),
                _InfoPill(label: restaurant.getRatingAndDistance()),
                _InfoPill(label: restaurant.attributes),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              'Rent this car as-is, or optionally add extras like '
              'protection, charging credit, and airport access.',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _showCheckoutSheet,
              icon: const Icon(Icons.key),
              label: const Text('Rent This Car'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(int index) {
    final item = widget.restaurant.items[index];
    return InkWell(
      onTap: () => _showBottomSheet(item),
      child: RestaurantItem(item: item),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  GridView _buildGridView(int columns) {
    return GridView.builder(
      padding: const EdgeInsets.all(0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 3.5,
        crossAxisCount: columns,
      ),
      itemBuilder: (context, index) => _buildGridItem(index),
      itemCount: widget.restaurant.items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  SliverToBoxAdapter _buildGridViewSection(String title) {
    final columns = calculateColumnCount(MediaQuery.of(context).size.width);
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle(title),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Optional extras. You can skip these and continue straight '
                'to your reservation.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 12),
            _buildGridView(columns),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(Item item) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      constraints: const BoxConstraints(maxWidth: 480),
      builder: (context) => ItemDetails(
        item: item,
        cartManager: widget.cartManager,
        quantityUpdated: () {
          setState(() {});
        },
      ),
    );
  }

  Future<void> _showCheckoutSheet() {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.86,
          minChildSize: 0.55,
          maxChildSize: 0.96,
          expand: false,
          snap: true,
          snapSizes: const [0.55, 0.86, 0.96],
          builder: (context, scrollController) {
            return ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
              child: Material(
                color: Theme.of(context).colorScheme.surface,
                child: CheckoutPage(
                  cartManager: widget.cartManager,
                  didUpdate: () {
                    setState(() {});
                  },
                  vehicle: widget.restaurant,
                  scrollController: scrollController,
                  showAppBar: false,
                  onSubmit: (order) {
                    widget.ordersManager.addOrder(order);
                    Navigator.of(sheetContext).pop();
                    this.context.go('/${EchelonTab.trips.value}');
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: _showCheckoutSheet,
      tooltip: 'Reservation',
      icon: const Icon(Icons.event_available),
      label: Text(
        widget.cartManager.items.isEmpty
            ? 'Rent This Car'
            : '${widget.cartManager.items.length} add-ons selected',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final constrainedWidth = _calculateConstrainedWidth(screenWidth);

    return Scaffold(
      floatingActionButton: _buildFloatingActionButton(),
      body: Center(
        child: SizedBox(
          width: constrainedWidth,
          child: _buildCustomScrollView(),
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Text(label),
    );
  }
}
