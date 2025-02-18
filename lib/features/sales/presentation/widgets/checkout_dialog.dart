import 'package:falsisters_pos_app/features/sales/data/providers/sales_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckoutDialog extends ConsumerWidget {
  const CheckoutDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Confirm Sale'),
      content: const Text('Do you want to complete this sale?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            final cart = ref.read(cartProvider);
            final total = ref.read(cartProvider.notifier).total;

            try {
              await ref.read(salesRepositoryProvider).createSale({
                'total': total,
                'paymentMethod': 'CASH',
                'saleItems': cart
                    .map((item) => ({
                          'productId': item.productId,
                          'qty': item.quantity,
                          'price': item.price,
                          'type': item.type.toString().split('.').last,
                        }))
                    .toList(),
              });

              ref.read(cartProvider.notifier).clearCart();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(e.toString())),
              );
            }
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
