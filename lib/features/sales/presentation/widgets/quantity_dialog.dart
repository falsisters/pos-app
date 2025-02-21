import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/models/product_type_enum.dart';
import '../../data/providers/sales_provider.dart';

class QuantityDialog extends ConsumerStatefulWidget {
  final dynamic price;
  final String productName;
  final String productId;

  const QuantityDialog({
    super.key,
    required this.price,
    required this.productName,
    required this.productId,
  });

  @override
  ConsumerState<QuantityDialog> createState() => _QuantityDialogState();
}

class _QuantityDialogState extends ConsumerState<QuantityDialog> {
  int quantity = 1;
  late double currentPrice;
  bool isSpecialPrice = false;

  @override
  void initState() {
    super.initState();
    updatePrice();
  }

  void updatePrice() {
    if (widget.price['SpecialPrice'] != null &&
        widget.price['SpecialPrice'].isNotEmpty) {
      // Sort special prices by minimum quantity in descending order
      final specialPrices = List.from(widget.price['SpecialPrice'])
        ..sort((a, b) => b['minimumQty'].compareTo(a['minimumQty']));

      // Find the first applicable special price
      final applicablePrice = specialPrices.firstWhere(
        (sp) => quantity >= sp['minimumQty'],
        orElse: () => null,
      );

      if (applicablePrice != null) {
        currentPrice = applicablePrice['specialPrice'].toDouble();
        isSpecialPrice = true;
      } else {
        currentPrice = widget.price['price'].toDouble();
        isSpecialPrice = false;
      }
    } else {
      currentPrice = widget.price['price'].toDouble();
      isSpecialPrice = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = currentPrice * quantity;

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
                onPressed: quantity < widget.price['stock']
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
            'Unit Price: ₱${currentPrice.toStringAsFixed(2)}',
            style: TextStyle(
              color: isSpecialPrice ? Theme.of(context).primaryColor : null,
              fontWeight: isSpecialPrice ? FontWeight.bold : null,
            ),
          ),
          Text(
            'Total: ₱${total.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (isSpecialPrice) ...[
            const SizedBox(height: 8),
            Text(
              'Special Price Applied!',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          if (widget.price['SpecialPrice'] != null &&
              widget.price['SpecialPrice'].isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Available Special Prices:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...widget.price['SpecialPrice'].map<Widget>(
              (sp) => Text(
                '${sp['minimumQty']}+ units: ₱${sp['specialPrice']}',
                style: TextStyle(
                  color: quantity >= sp['minimumQty']
                      ? Theme.of(context).primaryColor
                      : null,
                  fontWeight:
                      quantity >= sp['minimumQty'] ? FontWeight.bold : null,
                ),
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final item = CartItem(
              productId: widget.productId,
              name: widget.productName,
              price: currentPrice,
              quantity: quantity,
              type: ProductType.values.firstWhere(
                (t) => t.toString() == 'ProductType.${widget.price['type']}',
              ),
              isSpecialPrice: isSpecialPrice,
            );

            ref.read(cartProvider.notifier).addItem(item);
            Navigator.pop(context);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Added ${widget.productName} to cart'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.green,
              ),
            );
          },
          child: const Text('Add to Cart'),
        ),
      ],
    );
  }
}
