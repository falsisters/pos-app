import 'package:falsisters_pos_app/features/sales/data/models/cart_item_model.dart';
import 'package:falsisters_pos_app/features/sales/data/models/product_type_enum.dart';
import 'package:falsisters_pos_app/features/sales/data/providers/product_provider.dart';
import 'package:falsisters_pos_app/features/sales/data/providers/sales_provider.dart';
import 'package:falsisters_pos_app/features/sales/presentation/widgets/quantity_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartItemTile extends ConsumerWidget {
  final CartItem item;

  const CartItemTile({super.key, required this.item});

  String _getDisplayType(ProductType type) {
    switch (type) {
      case ProductType.FIFTY_KG:
        return '50KG';
      case ProductType.TWENTY_FIVE_KG:
        return '25KG';
      case ProductType.FIVE_KG:
        return '5KG';
      default:
        return type.toString().split('.').last;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsData = ref.watch(productsNotifierProvider);

    return productsData.when(
      data: (products) {
        final product = products.firstWhere(
          (p) => p['id'] == item.productId,
          orElse: () => null,
        );

        if (product == null) return const SizedBox.shrink();

        final priceData = product['Price'].firstWhere(
          (p) => 'ProductType.${p['type']}' == item.type.toString(),
          orElse: () => null,
        );

        if (priceData == null) return const SizedBox.shrink();

        return ListTile(
          title: Text(item.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${_getDisplayType(item.type)} - ₱${item.price}'),
              if (item.isSpecialPrice)
                Text(
                  'Special Price Applied',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  final result = await showDialog<Map<String, dynamic>>(
                    context: context,
                    builder: (context) => QuantityDialog(
                      price: priceData,
                      productName: product['name'],
                      currentStock: priceData['stock'] + item.quantity,
                      initialQuantity: item.quantity,
                    ),
                  );

                  if (result != null) {
                    if (result['quantity'] == 0) {
                      ref
                          .read(cartProvider.notifier)
                          .removeItem(item.productId, item.type);
                    } else {
                      ref.read(cartProvider.notifier).updateQuantity(
                            item.productId,
                            item.type,
                            result['quantity'],
                            result['unitPrice'],
                            result['isSpecialPrice'],
                          );
                    }
                  }
                },
              ),
              const SizedBox(width: 8),
              Text(
                '${item.quantity}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  ref
                      .read(cartProvider.notifier)
                      .removeItem(item.productId, item.type);
                },
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }
}
