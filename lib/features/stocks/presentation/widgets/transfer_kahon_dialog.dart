import 'package:falsisters_pos_app/features/sales/data/models/price_model.dart';
import 'package:falsisters_pos_app/features/stocks/data/models/transfer_kahon_model.dart';
import 'package:falsisters_pos_app/features/stocks/data/providers/stock_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falsisters_pos_app/features/sales/data/models/product_model.dart';

class TransferKahonDialog extends ConsumerStatefulWidget {
  final Product product;

  const TransferKahonDialog({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  ConsumerState<TransferKahonDialog> createState() =>
      _TransferKahonDialogState();
}

class _TransferKahonDialogState extends ConsumerState<TransferKahonDialog> {
  Price? _selectedPrice;
  int _transferQuantity = 0;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.product.prices.isNotEmpty) {
      _selectedPrice = widget.product.prices.first;
    }
  }

  Future<void> _confirmTransfer() async {
    if (_selectedPrice == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a price variant'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_transferQuantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transfer quantity must be greater than 0'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_transferQuantity > _selectedPrice!.stock) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transfer quantity cannot exceed available stock'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show confirmation dialog
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Transfer'),
          content: Text(
            'Are you sure you want to transfer ${_transferQuantity} units of ${_selectedPrice!.type.toString().split('.').last} to KAHON?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );

    if (confirm != true || !mounted) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final request = TransferKahonRequest(
        price: ProductPrice(
          id: _selectedPrice!.id,
          type: _selectedPrice!.type,
        ),
        id: widget.product.id,
        qty: _transferQuantity,
      );

      await ref
          .read(stocksProvider.notifier)
          .transferToKahon(widget.product.id, request);

      if (mounted) {
        Navigator.of(context).pop(); // Close the dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully transferred units'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Transfer failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Transfer Stock'),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.product.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Price variant selection
              const Text(
                'Select Variant:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<Price>(
                isExpanded: true,
                value: _selectedPrice,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: widget.product.prices.map((price) {
                  return DropdownMenuItem<Price>(
                    value: price,
                    child: Text(
                      '${price.type.toString().split('.').last} - ${price.stock} in stock - ₱ ${price.price}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (Price? value) {
                  setState(() {
                    _selectedPrice = value;
                    // Reset quantity when changing variant
                    _transferQuantity = 0;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Transfer quantity
              const Text(
                'Transfer Quantity:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _transferQuantity.toString(),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Enter quantity',
                        suffixText: _selectedPrice != null
                            ? '/ ${_selectedPrice!.stock}'
                            : '',
                      ),
                      onChanged: (value) {
                        setState(() {
                          _transferQuantity = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Transfer type
              const Text(
                'Transfer Type:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _confirmTransfer,
          child: _isSubmitting
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : const Text('Transfer'),
        ),
      ],
    );
  }
}
