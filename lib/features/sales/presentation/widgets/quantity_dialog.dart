import 'package:flutter/material.dart';

class QuantityDialog extends StatefulWidget {
  final dynamic price;
  final String productName;
  final int currentStock;

  const QuantityDialog({
    super.key,
    required this.price,
    required this.productName,
    required this.currentStock,
    required int initialQuantity,
  });

  @override
  State<QuantityDialog> createState() => _QuantityDialogState();
}

class _QuantityDialogState extends State<QuantityDialog> {
  late int quantity = 1;
  late double unitPrice;
  late bool isSpecialPrice;

  @override
  void initState() {
    super.initState();
    updatePrice();
  }

  void updatePrice() {
    final specialPrices = widget.price['SpecialPrice'];
    if (specialPrices != null && specialPrices.isNotEmpty) {
      final applicableSpecialPrice = specialPrices.firstWhere(
        (sp) => quantity >= sp['minimumQty'],
        orElse: () => null,
      );

      if (applicableSpecialPrice != null) {
        unitPrice = applicableSpecialPrice['specialPrice'].toDouble();
        isSpecialPrice = true;
      } else {
        unitPrice = widget.price['price'].toDouble();
        isSpecialPrice = false;
      }
    } else {
      unitPrice = widget.price['price'].toDouble();
      isSpecialPrice = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.productName),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: quantity > 1
                    ? () {
                        setState(() {
                          quantity--;
                          updatePrice();
                        });
                      }
                    : null,
              ),
              Text(
                '$quantity',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: quantity < widget.currentStock
                    ? () {
                        setState(() {
                          quantity++;
                          updatePrice();
                        });
                      }
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Unit Price: ₱${unitPrice.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            'Total: ₱${(unitPrice * quantity).toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (widget.price['SpecialPrice'] != null &&
              widget.price['SpecialPrice'].isNotEmpty)
            const SizedBox(height: 8),
          if (widget.price['SpecialPrice'] != null &&
              widget.price['SpecialPrice'].isNotEmpty)
            Text(
              'Special prices available at:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          if (widget.price['SpecialPrice'] != null &&
              widget.price['SpecialPrice'].isNotEmpty)
            ...widget.price['SpecialPrice'].map<Widget>((sp) => Text(
                  '${sp['minimumQty']} units: ₱${sp['specialPrice'].toStringAsFixed(2)} each',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: quantity >= sp['minimumQty']
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                )),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(
            context,
            {
              'quantity': quantity,
              'unitPrice': unitPrice,
              'isSpecialPrice': isSpecialPrice,
            },
          ),
          child: const Text('Add to Cart'),
        ),
      ],
    );
  }
}
