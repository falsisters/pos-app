import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falsisters_pos_app/features/delivery/data/providers/delivery_provider.dart';
import 'package:falsisters_pos_app/features/delivery/data/models/delivery_item_model.dart';
import 'package:falsisters_pos_app/features/sales/data/models/product_model.dart';
import 'package:falsisters_pos_app/features/sales/data/models/price_model.dart';

class AddToDeliveryDialog extends ConsumerStatefulWidget {
  final Product product;
  final Price price;

  const AddToDeliveryDialog({
    required this.product,
    required this.price,
  });

  @override
  ConsumerState<AddToDeliveryDialog> createState() =>
      _AddToDeliveryDialogState();
}

class _AddToDeliveryDialogState extends ConsumerState<AddToDeliveryDialog> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final total = widget.price.price * quantity;

    return AlertDialog(
      title: Text('Add ${widget.product.name} to Delivery'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
            ref.read(deliveryCartProvider.notifier).addItem(
                  DeliveryItem(
                    productId: widget.product.id,
                    name: widget.product.name,
                    price: widget.price.price,
                    quantity: quantity,
                    type: widget.price.type,
                  ),
                );
            Navigator.pop(context);
          },
          child: const Text('Add to Delivery'),
        ),
      ],
    );
  }
}
