// lib/features/stocks/presentation/widgets/product_stock_card.dart
import 'package:falsisters_pos_app/features/stocks/presentation/widgets/edit_stock_dialog.dart';
import 'package:falsisters_pos_app/features/stocks/presentation/widgets/transfer_kahon_dialog.dart';
import 'package:falsisters_pos_app/features/stocks/presentation/widgets/transfer_stock_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falsisters_pos_app/features/sales/data/models/product_model.dart';

class ProductStockCard extends ConsumerWidget {
  final Product product;

  const ProductStockCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                if (product.picture.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      product.picture,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported),
                      ),
                    ),
                  )
                else
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.inventory_2_outlined),
                  ),
                const SizedBox(width: 16),
                // Product Details
                Expanded(
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
                      const SizedBox(height: 4),
                      Text(
                        'ID: ${product.id}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Stock information for each price variant
                      ...product.prices.map((priceVariant) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${priceVariant.type.toString().split('.').last}: ${priceVariant.stock}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '₱ ${priceVariant.price}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => _showEditStockDialog(context, product),
                  child: const Text('Edit Stock'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _showTransferStockDialog(context, product),
                  child: const Text('Transfer Stock'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _showTransferKahonDialog(context, product),
                  child: const Text('Transfer to Kahon'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditStockDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => EditStockDialog(product: product),
    );
  }

  void _showTransferStockDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => TransferStockDialog(product: product),
    );
  }

  void _showTransferKahonDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => TransferKahonDialog(product: product),
    );
  }
}
