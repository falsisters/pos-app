import 'package:falsisters_pos_app/features/sales/data/models/cart_item_model.dart';
import 'package:falsisters_pos_app/features/sales/data/providers/sales_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartItemTile extends ConsumerWidget {
  final CartItem item;

  const CartItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(item.name),
      subtitle:
          Text('${item.type.toString().split('.').last} - \$${item.price}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              if (item.quantity > 1) {
                ref.read(cartProvider.notifier).updateQuantity(
                      item.productId,
                      item.type,
                      item.quantity - 1,
                    );
              } else {
                ref.read(cartProvider.notifier).removeItem(
                      item.productId,
                      item.type,
                    );
              }
            },
          ),
          Text('${item.quantity}'),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              ref.read(cartProvider.notifier).updateQuantity(
                    item.productId,
                    item.type,
                    item.quantity + 1,
                  );
            },
          ),
        ],
      ),
    );
  }
}
