import 'package:falsisters_pos_app/features/delivery/data/providers/delivery_provider.dart';
import 'package:falsisters_pos_app/features/sales/data/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeliveryCheckoutScreen extends ConsumerStatefulWidget {
  const DeliveryCheckoutScreen({super.key});

  @override
  _DeliveryCheckoutScreenState createState() => _DeliveryCheckoutScreenState();
}

class _DeliveryCheckoutScreenState
    extends ConsumerState<DeliveryCheckoutScreen> {
  final _driverController = TextEditingController();
  List<String> attachments = [];

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(deliveryCartProvider);
    final total = ref.read(deliveryCartProvider.notifier).total;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Checkout'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _driverController,
              decoration: const InputDecoration(
                labelText: 'Driver Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Items',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Divider(),
                    ...cart.map((item) => ListTile(
                          title: Text(item.name),
                          subtitle: Text(
                              '${item.type.toString().split('.').last} - ${item.quantity} units'),
                          trailing: Text('₱${item.total.toStringAsFixed(2)}'),
                        )),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          '₱${total.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement image attachment
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Image attachment feature coming soon!'),
                  ),
                );
              },
              icon: const Icon(Icons.attach_file),
              label: const Text('Attach Images'),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_driverController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter driver name'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  try {
                    await ref.read(deliveryRepositoryProvider).createDelivery({
                      'total': total,
                      'driver': _driverController.text,
                      'deliveryItems': cart
                          .map((item) => ({
                                'productId': item.productId,
                                'qty': item.quantity,
                                'price': item.price,
                                'type': item.type.toString().split('.').last,
                              }))
                          .toList(),
                      'attachments': attachments,
                    });

                    ref.read(deliveryCartProvider.notifier).clearCart();
                    await ref
                        .read(productsNotifierProvider.notifier)
                        .refreshProducts();

                    Navigator.of(context).popUntil(
                      (route) => route.isFirst,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Delivery recorded successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text('Confirm Delivery'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
