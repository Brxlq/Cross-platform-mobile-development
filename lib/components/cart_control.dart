import 'package:flutter/material.dart';

class CartControl extends StatefulWidget {
  const CartControl({required this.addToCart, super.key});

  final void Function(int) addToCart;

  @override
  State<CartControl> createState() => _CartControlState();
}

class _CartControlState extends State<CartControl> {
  int _cartNumber = 1;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildMinusButton(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: colorScheme.onPrimary,
          child: Text(_cartNumber.toString()),
        ),
        _buildPlusButton(),
        const Spacer(),
        FilledButton(
          onPressed: () {
            widget.addToCart(_cartNumber);
          },
          child: const Text('Add to reservation'),
        ),
      ],
    );
  }

  Widget _buildMinusButton() {
    return IconButton(
      icon: const Icon(Icons.remove),
      tooltip: 'Decrease add-on quantity',
      onPressed: () {
        setState(() {
          if (_cartNumber > 1) {
            _cartNumber--;
          }
        });
      },
    );
  }

  Widget _buildPlusButton() {
    return IconButton(
      icon: const Icon(Icons.add),
      tooltip: 'Increase add-on quantity',
      onPressed: () {
        setState(() {
          _cartNumber++;
        });
      },
    );
  }
}
