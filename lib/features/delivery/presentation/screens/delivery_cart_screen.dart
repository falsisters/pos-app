import 'package:falsisters_pos_app/features/delivery/data/providers/delivery_provider.dart';
import 'package:falsisters_pos_app/features/delivery/presentation/screens/delivery_checkout_screen.dart';
import 'package:falsisters_pos_app/features/delivery/presentation/widgets/delivery_cart_item_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeliveryCartScreen extends ConsumerWidget {
  const DeliveryCartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(deliveryCartProvider);
    final total = ref.read(deliveryCartProvider.notifier).total;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final item = cart[index];
                return DeliveryCartItemTile(item: item);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Total: \$${total.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: cart.isEmpty
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const DeliveryCheckoutScreen(),
                              ),
                            );
                          },
                    child: const Text('Proceed to Checkout'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
