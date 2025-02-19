import 'package:falsisters_pos_app/features/sales/data/models/cart_item_model.dart';
import 'package:falsisters_pos_app/features/sales/data/models/product_type_enum.dart';
import 'package:falsisters_pos_app/features/sales/data/providers/product_provider.dart';
import 'package:falsisters_pos_app/features/sales/data/providers/sales_provider.dart';
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
      case ProductType.SPECIAL_PRICE:
        return 'Special Price';
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
          subtitle: Text('${_getDisplayType(item.type)} - ₱${item.price}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  if (item.type == ProductType.SPECIAL_PRICE) {
                    if (item.quantity <= item.minimumQty) {
                      ref.read(cartProvider.notifier).removeItem(
                            item.productId,
                            item.type,
                          );
                      return;
                    }
                  }

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
                onPressed: item.quantity < priceData['stock']
                    ? () {
                        ref.read(cartProvider.notifier).updateQuantity(
                              item.productId,
                              item.type,
                              item.quantity + 1,
                            );
                      }
                    : null,
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
