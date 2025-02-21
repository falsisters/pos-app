import 'package:falsisters_pos_app/features/sales/data/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/sales_provider.dart';

enum PaymentMethod { CASH, BANK_TRANSFER, CHECK }

class CheckoutDialog extends ConsumerStatefulWidget {
  const CheckoutDialog({super.key});

  @override
  ConsumerState<CheckoutDialog> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends ConsumerState<CheckoutDialog> {
  PaymentMethod? selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final total = ref.read(cartProvider.notifier).total;

    return AlertDialog(
      title: const Text('Checkout'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Amount: ₱${total.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            const Text('Select Payment Method:'),
            const SizedBox(height: 8),
            ...PaymentMethod.values.map(
              (method) => RadioListTile<PaymentMethod>(
                title: Text(method.toString().split('.').last),
                value: method,
                groupValue: selectedPaymentMethod,
                onChanged: (PaymentMethod? value) {
                  setState(() {
                    selectedPaymentMethod = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: selectedPaymentMethod == null
              ? null
              : () async {
                  try {
                    await ref.read(salesRepositoryProvider).createSale({
                      'total': total,
                      'paymentMethod':
                          selectedPaymentMethod.toString().split('.').last,
                      'saleItems': cart
                          .map((item) => {
                                'productId': item.productId,
                                'qty': item.quantity,
                                'price': item.price,
                                'type': item.type.toString().split('.').last,
                                'isSpecialPrice': item.isSpecialPrice,
                              })
                          .toList(),
                    });

                    ref.read(cartProvider.notifier).clearCart();
                    await ref
                        .read(productsNotifierProvider.notifier)
                        .refreshProducts();

                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sale completed successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: ${e.toString()}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
          child: const Text('Complete Sale'),
        ),
      ],
    );
  }
}
