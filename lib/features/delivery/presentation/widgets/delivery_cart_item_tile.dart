import 'package:falsisters_pos_app/core/constants/product_type.dart';
import 'package:falsisters_pos_app/features/delivery/data/models/delivery_item_model.dart';
import 'package:falsisters_pos_app/features/delivery/data/providers/delivery_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeliveryCartItemTile extends ConsumerWidget {
  final DeliveryItem item;

  const DeliveryCartItemTile({super.key, required this.item});

  String _getDisplayType(ProductType type) {
    switch (type) {
      case ProductType.FIFTY_KG:
        return '50KG';
      case ProductType.TWENTY_FIVE_KG:
        return '25KG';
      case ProductType.FIVE_KG:
        return '5KG';
      case ProductType.PER_KILO:
        return 'Per Kilo';
      case ProductType.GANTANG:
        return 'Gantang';
      default:
        return type.toString().split('.').last;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(item.name),
      subtitle: Text('${_getDisplayType(item.type)} - ₱${item.price}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              if (item.quantity > 1) {
                ref.read(deliveryCartProvider.notifier).updateQuantity(
                      item.productId,
                      item.type,
                      item.quantity - 1,
                    );
              } else {
                ref.read(deliveryCartProvider.notifier).removeItem(
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
              ref.read(deliveryCartProvider.notifier).updateQuantity(
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
