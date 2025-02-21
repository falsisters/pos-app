import 'package:falsisters_pos_app/features/sales/data/models/price_model.dart';
import 'package:falsisters_pos_app/features/sales/data/models/product_model.dart';
import 'package:falsisters_pos_app/features/sales/data/models/product_type_enum.dart';
import 'package:falsisters_pos_app/features/sales/presentation/widgets/add_to_cart_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductCard extends ConsumerWidget {
  final Product product;

  const ProductCard({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.network(
              product.picture,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: ProductType.values.map((type) {
                    final price = product.getPriceByType(type);
                    final isAvailable = price != null && price.stock > 0;

                    return FilledButton(
                      onPressed: isAvailable
                          ? () =>
                              _showAddToCartDialog(context, ref, product, price)
                          : null,
                      child: Text('${type.name}\n${price?.price ?? '-'}'),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddToCartDialog(
    BuildContext context,
    WidgetRef ref,
    Product product,
    Price price,
  ) {
    showDialog(
      context: context,
      builder: (context) => AddToCartDialog(
        product: product,
        price: price,
      ),
    );
  }
}
