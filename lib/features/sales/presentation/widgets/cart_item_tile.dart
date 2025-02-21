import 'package:falsisters_pos_app/features/sales/data/models/cart_item_model.dart';
import 'package:falsisters_pos_app/features/sales/data/models/product_type_enum.dart';
import 'package:falsisters_pos_app/features/sales/data/providers/sales_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartItemTile extends ConsumerWidget {
  final CartItem item;

  const CartItemTile({required this.item});

  String _parseType(ProductType type) {
    switch (type) {
      case ProductType.FIFTY_KG:
        return '50 Kilograms';
      case ProductType.TWENTY_FIVE_KG:
        return '25 Kilograms';
      case ProductType.FIVE_KG:
        return '5 Kilograms';
      case ProductType.PER_KILO:
        return 'Kilo';
      case ProductType.GANTANG:
        return 'Gantang';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Image.network(
        item.picture,
        width: 48,
        height: 48,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error);
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const CircularProgressIndicator();
        },
      ),
      title: Text(item.name),
      subtitle: Text(
        '${_parseType(item.type)} - ${item.price} x ${item.quantity} = ${item.total}',
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          ref.read(cartProvider.notifier).removeItem(item.productId, item.type);
        },
      ),
    );
  }
}
