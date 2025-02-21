import 'package:falsisters_pos_app/features/delivery/presentation/widgets/delivery_checkout_dialog.dart';
import 'package:falsisters_pos_app/features/delivery/presentation/widgets/delivery_item_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falsisters_pos_app/features/delivery/data/providers/delivery_provider.dart';

class DeliveryCartSection extends ConsumerWidget {
  const DeliveryCartSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(deliveryCartProvider);
    final total = ref.watch(deliveryCartProvider.notifier).total;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Delivery Cart',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return DeliveryItemTile(item: item);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Total: $total',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: cartItems.isEmpty
                      ? null
                      : () => _showDeliveryCheckoutDialog(context),
                  child: const Text('Create Delivery'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeliveryCheckoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const DeliveryCheckoutDialog(),
    );
  }
}
