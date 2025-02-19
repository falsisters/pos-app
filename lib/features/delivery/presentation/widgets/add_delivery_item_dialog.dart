import 'package:falsisters_pos_app/core/constants/product_type.dart';
import 'package:falsisters_pos_app/features/delivery/data/models/delivery_item_model.dart';
import 'package:falsisters_pos_app/features/delivery/data/providers/delivery_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddDeliveryItemDialog extends ConsumerStatefulWidget {
  final dynamic product;
  final dynamic priceData;

  const AddDeliveryItemDialog({
    super.key,
    required this.product,
    required this.priceData,
  });

  @override
  _AddDeliveryItemDialogState createState() => _AddDeliveryItemDialogState();
}

class _AddDeliveryItemDialogState extends ConsumerState<AddDeliveryItemDialog> {
  final _quantityController = TextEditingController(text: '1');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add ${widget.product['name']}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      int currentValue =
                          int.tryParse(_quantityController.text) ?? 0;
                      _quantityController.text = (currentValue + 1).toString();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      int currentValue =
                          int.tryParse(_quantityController.text) ?? 0;
                      if (currentValue > 1) {
                        _quantityController.text =
                            (currentValue - 1).toString();
                      }
                    },
                  ),
                ],
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
        TextButton(
          onPressed: () {
            final quantity = int.tryParse(_quantityController.text);
            if (quantity == null || quantity <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please enter a valid quantity'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }

            ref.read(deliveryCartProvider.notifier).addItem(
                  DeliveryItem(
                    productId: widget.product['id'],
                    name: widget.product['name'],
                    price: widget.priceData['price'].toDouble(),
                    quantity: quantity,
                    type: ProductType.values.firstWhere(
                      (t) =>
                          t.toString() ==
                          'ProductType.${widget.priceData['type']}',
                    ),
                    minimumQty: widget.product['minimumQty'],
                  ),
                );

            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('${widget.product['name']} added to delivery cart'),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(20.0),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
