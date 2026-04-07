import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/models.dart';
import 'cart_control.dart';

class ItemDetails extends StatefulWidget {
  const ItemDetails({
    super.key,
    required this.item,
    required this.cartManager,
    required this.quantityUpdated,
  });

  final Item item;
  final CartManager cartManager;
  final void Function() quantityUpdated;

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    final colorTheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.item.name, style: textTheme.headlineMedium),
              const SizedBox(height: 16),
              _mostLikedBadge(colorTheme),
              const SizedBox(height: 16),
              Text(widget.item.description),
              const SizedBox(height: 16),
              _itemImage(widget.item.imageUrl),
              const SizedBox(height: 16),
              _addToCartControl(widget.item),
            ],
          ),
        ],
      ),
    );
  }

  Widget _mostLikedBadge(ColorScheme colorTheme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(4),
        color: colorTheme.onPrimary,
        child: const Text('Optional add-on'),
      ),
    );
  }

  Widget _itemImage(String imageUrl) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _addToCartControl(Item item) {
    return CartControl(
      addToCart: (number) {
        const uuid = Uuid();
        final cartItem = CartItem(
          id: uuid.v4(),
          name: item.name,
          price: item.price,
          quantity: number,
        );
        setState(() {
          widget.cartManager.addItem(cartItem);
          widget.quantityUpdated();
        });
        Navigator.pop(context);
      },
    );
  }
}
