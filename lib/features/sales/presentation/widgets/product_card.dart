import 'package:falsisters_pos_app/features/sales/presentation/widgets/quantity_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductCard extends ConsumerWidget {
  final dynamic product;

  const ProductCard({super.key, required this.product});

  String _getDisplayType(String type) {
    switch (type) {
      case 'FIFTY_KG':
        return '50KG';
      case 'TWENTY_FIVE_KG':
        return '25KG';
      case 'FIVE_KG':
        return '5KG';
      default:
        return type;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product['name'],
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: product['Price'].length,
                itemBuilder: (context, index) {
                  final price = product['Price'][index];
                  final hasSpecialPrices = price['SpecialPrice'] != null &&
                      price['SpecialPrice'].isNotEmpty;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
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
                            if (hasSpecialPrices) ...[
                              const SizedBox(height: 4),
                              const Text(
                                'Special Prices:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              ...price['SpecialPrice'].map<Widget>((sp) => Text(
                                    '${sp['minimumQty']}+ units: ₱${sp['specialPrice']}',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  )),
                            ],
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.add_shopping_cart),
                          onPressed: price['stock'] > 0
                              ? () => _showQuantityDialog(
                                    context,
                                    ref,
                                    price,
                                  )
                              : null,
                        ),
                      ),
                      const Divider(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuantityDialog(BuildContext context, WidgetRef ref, dynamic price) {
    showDialog(
      context: context,
      builder: (context) => QuantityDialog(
        price: price,
        productName: product['name'],
        productId: product['id'],
      ),
    );
  }
}
