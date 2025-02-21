import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falsisters_pos_app/features/delivery/data/providers/delivery_provider.dart';
import 'package:falsisters_pos_app/features/delivery/data/providers/delivery_state_provider.dart';

class DeliveryCheckoutDialog extends ConsumerStatefulWidget {
  const DeliveryCheckoutDialog();

  @override
  ConsumerState<DeliveryCheckoutDialog> createState() =>
      _DeliveryCheckoutDialogState();
}

class _DeliveryCheckoutDialogState
    extends ConsumerState<DeliveryCheckoutDialog> {
  final _driverController = TextEditingController();
  bool isProcessing = false;

  @override
  void dispose() {
    _driverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(deliveryCartProvider);
    final total = ref.watch(deliveryCartProvider.notifier).total;

    return AlertDialog(
      title: const Text('Create Delivery'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _driverController,
            decoration: const InputDecoration(
              labelText: 'Driver Name',
              hintText: 'Enter driver name',
            ),
          ),
          const SizedBox(height: 16),
          Text('Total Items: ${cartItems.length}'),
          Text('Total Value: $total'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: isProcessing ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: isProcessing
              ? null
              : () async {
                  if (_driverController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter driver name'),
                      ),
                    );
                    return;
                  }

                  setState(() => isProcessing = true);
                  try {
                    // Set delivery state
                    ref
                        .read(deliveryStateProvider.notifier)
                        .setDriver(_driverController.text);

                    // Create delivery
                    await ref.read(deliveryRepositoryProvider).createDelivery({
                      'driver': _driverController.text,
                      'total': total,
                      'items': cartItems
                          .map((item) => {
                                'productId': item.productId,
                                'qty': item.quantity,
                                'price': item.price,
                                'type': item.type.name,
                              })
                          .toList(),
                    });

                    // Clear cart and state
                    ref.read(deliveryCartProvider.notifier).clearCart();
                    ref.read(deliveryStateProvider.notifier).clear();

                    if (mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Delivery created successfully'),
                        ),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: $e'),
                        ),
                      );
                    }
                  } finally {
                    if (mounted) {
                      setState(() => isProcessing = false);
                    }
                  }
                },
          child: isProcessing
              ? const CircularProgressIndicator()
              : const Text('Create Delivery'),
        ),
      ],
    );
  }
}
