import 'package:falsisters_pos_app/features/sales/data/models/cart_item_model.dart';
import 'package:falsisters_pos_app/features/sales/data/models/product_type_enum.dart';
import 'package:falsisters_pos_app/features/sales/data/providers/sales_provider.dart';
import 'package:falsisters_pos_app/features/sales/presentation/widgets/quantity_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductCard extends ConsumerWidget {
  final dynamic product;

  const ProductCard({super.key, required this.product});

  Object _getDisplayType(String type) {
    switch (type) {
      case 'FIFTY_KG':
        return '50 Kilograms';
      case 'TWENTY_FIVE_KG':
        return '25 Kilograms';
      case 'FIVE_KG':
        return '5 Kilograms';
      case 'SPECIAL_PRICE':
        return 'Special Price';
      default:
        return type;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product['name'],
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Spacer(),
            ...product['Price']
                .where(
                    (price) => !['GANTANG', 'PER_KILO'].contains(price['type']))
                .map<Widget>(
                  (price) => ListTile(
                    enabled: price['stock'] > 0,
                    title: Text(
                      '${_getDisplayType(price['type'])}: ₱${price['price']}',
                      style: TextStyle(
                        color: price['stock'] > 0
                            ? null
                            : Theme.of(context).disabledColor,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Stock: ${price['stock']}',
                          style: TextStyle(
                            color: price['stock'] > 0
                                ? null
                                : Theme.of(context).disabledColor,
                          ),
                        ),
                        if (price['type'] == 'SPECIAL_PRICE')
                          Text(
                            'Minimum Quantity: ${product['minimumQty']}',
                            style: TextStyle(
                              color: price['stock'] > 0
                                  ? null
                                  : Theme.of(context).disabledColor,
                            ),
                          ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_shopping_cart),
                      onPressed: price['stock'] > 0
                          ? () async {
                              final result =
                                  await showDialog<Map<String, dynamic>>(
                                context: context,
                                builder: (context) => QuantityDialog(
                                  price: price,
                                  productName: product['name'],
                                  currentStock: price['stock'],
                                  initialQuantity: 1,
                                ),
                              );

                              if (result != null) {
                                final cartItems = ref.read(cartProvider);
                                CartItem? existingItem;
                                try {
                                  existingItem = cartItems.firstWhere(
                                    (item) =>
                                        item.productId == product['id'] &&
                                        item.type.toString() ==
                                            'ProductType.${price['type']}',
                                  );
                                } catch (e) {
                                  existingItem = null;
                                }

                                final currentQty = existingItem?.quantity ?? 0;
                                if (currentQty + result['quantity'] >
                                    price['stock']) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Cannot add more items. Available stock: ${price['stock']}',
                                      ),
                                      backgroundColor: Colors.red,
                                      behavior: SnackBarBehavior.floating,
                                      margin: const EdgeInsets.all(20.0),
                                    ),
                                  );
                                  return;
                                }

                                ref.read(cartProvider.notifier).addItem(
                                      CartItem(
                                        productId: product['id'],
                                        name: product['name'],
                                        price: result['unitPrice'],
                                        quantity: result['quantity'],
                                        type: ProductType.values.firstWhere(
                                            (t) =>
                                                t.toString() ==
                                                'ProductType.${price['type']}'),
                                        isSpecialPrice:
                                            result['isSpecialPrice'],
                                      ),
                                    );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        '${product['name']} added to cart'),
                                    behavior: SnackBarBehavior.floating,
                                    margin: const EdgeInsets.all(20.0),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              }
                            }
                          : null,
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}
