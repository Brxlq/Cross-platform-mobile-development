import 'package:flutter/material.dart';

import '../models/models.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key, required this.orderManager});

  final OrderManager orderManager;

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  void _cancelOrder(Order order, {int? index}) {
    final removedIndex = index ?? widget.orderManager.orders.indexOf(order);
    if (removedIndex < 0) {
      return;
    }

    setState(() {
      widget.orderManager.removeOrder(order);
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${order.vehicleName} reservation cancelled'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                widget.orderManager.insertOrder(removedIndex, order);
              });
            },
          ),
        ),
      );
  }

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
                final order = widget.orderManager.orders[index];
                return Dismissible(
                  key: ObjectKey(order),
                  direction: DismissDirection.endToStart,
                  background: const SizedBox.shrink(),
                  secondaryBackground: const _DismissReservationBackground(),
                  onDismissed: (_) => _cancelOrder(order, index: index),
                  child: OrderTile(
                    order: order,
                    onCancel: () => _cancelOrder(order, index: index),
                  ),
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.network(
                    order.vehicleImageUrl,
                    width: 88,
                    height: 88,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            'Reserved',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              'Swipe left to cancel',
                              style: textTheme.labelMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
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

class _DismissReservationBackground extends StatelessWidget {
  const _DismissReservationBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.centerRight,
      child: Icon(
        Icons.delete_outline,
        color: Theme.of(context).colorScheme.error,
      ),
    );
  }
}
