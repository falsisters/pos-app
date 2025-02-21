import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/product_grid.dart';
import '../widgets/cart_panel.dart';

class SalesScreen extends ConsumerWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales'),
      ),
      body: Row(
        children: [
          // Left side - Products
          const Expanded(
            flex: 1,
            child: ProductGrid(),
          ),
          // Right side - Cart
          Container(
            width:
                MediaQuery.of(context).size.width * 0.4, // 40% of screen width
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ),
            child: const CartPanel(),
          ),
        ],
      ),
    );
  }
}
