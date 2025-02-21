import 'package:falsisters_pos_app/features/delivery/presentation/widgets/add_to_delivery_dialog.dart';
import 'package:falsisters_pos_app/features/sales/data/models/price_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falsisters_pos_app/features/sales/data/models/product_model.dart';
import 'package:falsisters_pos_app/features/sales/data/models/product_type_enum.dart';

class DeliveryProductCard extends ConsumerWidget {
  final Product product;

  const DeliveryProductCard({required this.product});

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
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 200,
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
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 150,
                  child: SingleChildScrollView(
                    child: Column(
                      children: product.prices.map((price) {
                        final isAvailable = price.stock > 0;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${_parseType(price.type)} - ${price.price}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      'Stock: ${price.stock}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              FilledButton(
                                onPressed: isAvailable
                                    ? () => _showAddToDeliveryDialog(
                                        context, product, price)
                                    : null,
                                child: const Text('Add'),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddToDeliveryDialog(
    BuildContext context,
    Product product,
    Price price,
  ) {
    showDialog(
      context: context,
      builder: (context) => AddToDeliveryDialog(
        product: product,
        price: price,
      ),
    );
  }
}
