import 'package:falsisters_pos_app/features/sales/data/models/cart_item_model.dart';
import 'package:falsisters_pos_app/features/sales/data/models/price_model.dart';
import 'package:falsisters_pos_app/features/sales/data/models/product_model.dart';
import 'package:falsisters_pos_app/features/sales/data/models/special_price_model.dart';
import 'package:falsisters_pos_app/features/sales/data/providers/sales_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddToCartDialog extends ConsumerStatefulWidget {
  final Product product;
  final Price price;

  const AddToCartDialog({
    required this.product,
    required this.price,
  });

  @override
  ConsumerState<AddToCartDialog> createState() => _AddToCartDialogState();
}

class _AddToCartDialogState extends ConsumerState<AddToCartDialog> {
  int quantity = 1;
  SpecialPrice? selectedSpecialPrice;

  @override
  Widget build(BuildContext context) {
    final applicableSpecialPrices = widget.price.specialPrices
        .where((sp) => sp.minimumQty <= quantity)
        .toList();

    final currentPrice =
        selectedSpecialPrice?.specialPrice ?? widget.price.price;
    final total = currentPrice * quantity;

    return AlertDialog(
      title: Text('Add ${widget.product.name}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                onPressed:
                    quantity > 1 ? () => setState(() => quantity--) : null,
                icon: const Icon(Icons.remove),
              ),
              Text('$quantity'),
              IconButton(
                onPressed: quantity < widget.price.stock
                    ? () => setState(() => quantity++)
                    : null,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          if (applicableSpecialPrices.isNotEmpty) ...[
            const SizedBox(height: 16),
            DropdownButton<SpecialPrice>(
              value: selectedSpecialPrice,
              hint: const Text('Special Prices'),
              items: applicableSpecialPrices
                  .map((sp) => DropdownMenuItem(
                        value: sp,
                        child: Text(
                            'Min ${sp.minimumQty} units: ${sp.specialPrice}'),
                      ))
                  .toList(),
              onChanged: (sp) => setState(() => selectedSpecialPrice = sp),
            ),
          ],
          const SizedBox(height: 16),
          Text('Total: $total'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            ref.read(cartProvider.notifier).addItem(
                  CartItem(
                    productId: widget.product.id,
                    name: widget.product.name,
                    picture: widget.product.picture,
                    price: currentPrice,
                    quantity: quantity,
                    type: widget.price.type,
                    isSpecialPrice: selectedSpecialPrice != null,
                  ),
                );
            Navigator.pop(context);
          },
          child: const Text('Add to Cart'),
        ),
      ],
    );
  }
}
