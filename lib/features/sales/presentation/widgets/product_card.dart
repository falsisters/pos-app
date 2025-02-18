import 'package:falsisters_pos_app/features/sales/data/models/cart_item_model.dart';
import 'package:falsisters_pos_app/features/sales/data/models/product_type_enum.dart';
import 'package:falsisters_pos_app/features/sales/data/providers/sales_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductCard extends ConsumerWidget {
  final dynamic product;

  const ProductCard({super.key, required this.product});

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
                .map<Widget>(
                  (price) => ListTile(
                    title: Text('${price['type']}: \$${price['price']}'),
                    subtitle: Text('Stock: ${price['stock']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_shopping_cart),
                      onPressed: () {
                        if (price['stock'] > 0) {
                          ref.read(cartProvider.notifier).addItem(
                                CartItem(
                                  productId: product['id'],
                                  name: product['name'],
                                  price: price['price'].toDouble(),
                                  quantity: price['type'] == 'SPECIAL_PRICE'
                                      ? product['minimumQty']
                                      : 1,
                                  type: ProductType.values.firstWhere((t) =>
                                      t.toString() ==
                                      'ProductType.${price['type']}'),
                                  minimumQty: product['minimumQty'],
                                ),
                              );
                        }
                      },
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
