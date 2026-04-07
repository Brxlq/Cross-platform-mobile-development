import 'package:flutter/material.dart';

import '../models/models.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key, required this.orderManager});

  final OrderManager orderManager;

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Upcoming Trips', style: textTheme.headlineMedium),
      ),
      body: widget.orderManager.totalOrders == 0
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'No trips reserved yet. Head to Discover and '
                  'build your first Echelon booking.',
                  style: textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: widget.orderManager.totalOrders,
              itemBuilder: (context, index) {
                return OrderTile(
                  order: widget.orderManager.orders[index],
                  onCancel: () {
                    setState(() {
                      widget.orderManager
                          .removeOrder(widget.orderManager.orders[index]);
                    });
                  },
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 12),
            ),
    );
  }
}

class OrderTile extends StatelessWidget {
  const OrderTile({
    super.key,
    required this.order,
    required this.onCancel,
  });

  final Order order;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return Card(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  child: Icon(
                    Icons.directions_car_filled,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reserved',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(order.getFormattedOrderInfo()),
                      const SizedBox(height: 6),
                      Text('Add-ons: ${order.items.length}'),
                    ],
                  ),
                ),
                Text(
                  '\$${order.totalCost.toStringAsFixed(0)}',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                onPressed: onCancel,
                icon: const Icon(Icons.cancel_outlined),
                label: const Text('Cancel Reservation'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
