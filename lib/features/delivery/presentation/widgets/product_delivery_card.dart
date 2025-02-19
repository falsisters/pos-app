import 'package:falsisters_pos_app/features/delivery/presentation/widgets/add_delivery_item_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDeliveryCard extends ConsumerWidget {
  final dynamic product;

  const ProductDeliveryCard({super.key, required this.product});

  String _getDisplayType(String type) {
    switch (type) {
      case 'FIFTY_KG':
        return '50 Kilograms';
      case 'TWENTY_FIVE_KG':
        return '25 Kilograms';
      case 'FIVE_KG':
        return '5 Kilograms';
      case 'PER_KILO':
        return 'Per Kilo';
      case 'GANTANG':
        return 'Gantang';
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
                .map<Widget>(
                  (price) => ListTile(
                    title: Text(
                      '${_getDisplayType(price['type'])}: ₱${price['price']}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AddDeliveryItemDialog(
                            product: product,
                            priceData: price,
                          ),
                        );
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
