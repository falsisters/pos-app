import 'package:falsisters_pos_app/features/delivery/presentation/widgets/delivery_product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falsisters_pos_app/features/sales/data/providers/product_provider.dart';
import 'package:falsisters_pos_app/features/sales/data/models/product_model.dart';

class ProductsSection extends ConsumerWidget {
  const ProductsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(productsNotifierProvider);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Products for Delivery',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: productsState.when(
              data: (products) => GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = Product.fromJson(products[index]);
                  return DeliveryProductCard(product: product);
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }
}
