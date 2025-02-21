import 'package:falsisters_pos_app/features/sales/data/models/payment_method_enum.dart';
import 'package:falsisters_pos_app/features/sales/data/providers/product_provider.dart';
import 'package:falsisters_pos_app/features/sales/data/providers/sales_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckoutDialog extends ConsumerStatefulWidget {
  const CheckoutDialog();

  @override
  ConsumerState<CheckoutDialog> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends ConsumerState<CheckoutDialog> {
  PaymentMethod selectedPaymentMethod = PaymentMethod.CASH;
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final total = ref.watch(cartProvider.notifier).total;

    return AlertDialog(
      title: const Text('Checkout'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<PaymentMethod>(
            value: selectedPaymentMethod,
            items: PaymentMethod.values
                .map((method) => DropdownMenuItem(
                      value: method,
                      child: Text(method.name),
                    ))
                .toList(),
            onChanged: (method) {
              if (method != null) {
                setState(() => selectedPaymentMethod = method);
              }
            },
          ),
          const SizedBox(height: 16),
          Text('Total: $total'),
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
                  setState(() => isProcessing = true);
                  try {
                    await ref.read(salesRepositoryProvider).createSale({
                      'total': total,
                      'paymentMethod': selectedPaymentMethod.name,
                      'saleItems': cartItems
                          .map((item) => {
                                'productId': item.productId,
                                'qty': item.quantity,
                                'price': item.price,
                                'type': item.type.name,
                                'isSpecialPrice': item.isSpecialPrice,
                              })
                          .toList(),
                    });
                    ref.read(cartProvider.notifier).clearCart();
                    ref
                        .read(productsNotifierProvider.notifier)
                        .refreshProducts();
                    if (mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sale completed successfully'),
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
              : const Text('Complete Sale'),
        ),
      ],
    );
  }
}
