import 'package:falsisters_pos_app/features/sales/data/models/product_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falsisters_pos_app/features/delivery/data/providers/delivery_provider.dart';
import 'package:falsisters_pos_app/features/delivery/data/models/delivery_item_model.dart';
import 'package:falsisters_pos_app/features/sales/data/models/product_model.dart';

class AddToDeliveryDialog extends ConsumerStatefulWidget {
  final Product product;
  final ProductType type;
  final double price;

  const AddToDeliveryDialog({
    required this.product,
    required this.type,
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
                onPressed: () => setState(() => quantity++),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
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
                    quantity: quantity,
                    type: widget.type,
                    price: widget.price,
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
