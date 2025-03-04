// lib/features/stocks/presentation/dialogs/edit_stock_dialog.dart
import 'package:falsisters_pos_app/features/sales/data/models/product_model.dart';
import 'package:falsisters_pos_app/features/stocks/data/providers/stock_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falsisters_pos_app/features/stocks/data/models/stock_model.dart';

class EditStockDialog extends ConsumerStatefulWidget {
  final Product product;

  const EditStockDialog({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  ConsumerState<EditStockDialog> createState() => _EditStockDialogState();
}

class _EditStockDialogState extends ConsumerState<EditStockDialog> {
  final Map<String, int> _updatedStocks = {};
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Initialize with current stock values
    for (final priceVariant in widget.product.prices) {
      _updatedStocks[priceVariant.id] = priceVariant.stock;
    }
  }

  bool _isStockReduced() {
    for (final priceVariant in widget.product.prices) {
      final updatedStock =
          _updatedStocks[priceVariant.id] ?? priceVariant.stock;
      if (updatedStock > priceVariant.stock) {
        return false;
      }
    }
    return true;
  }

  bool _hasStockChanged() {
    for (final priceVariant in widget.product.prices) {
      final updatedStock =
          _updatedStocks[priceVariant.id] ?? priceVariant.stock;
      if (updatedStock != priceVariant.stock) {
        return true;
      }
    }
    return false;
  }

  Future<void> _submitEditStock() async {
    if (!_isStockReduced()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You can only reduce stock, not increase it.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_hasStockChanged()) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final List<StockUpdate> updates = [];

      for (final priceVariant in widget.product.prices) {
        final updatedStock =
            _updatedStocks[priceVariant.id] ?? priceVariant.stock;
        if (updatedStock != priceVariant.stock) {
          updates.add(StockUpdate(
            id: priceVariant.id,
            stock: updatedStock,
            type: priceVariant.type,
          ));
        }
      }

      if (updates.isNotEmpty) {
        final request = EditStockRequest(price: updates);
        await ref.read(stocksProvider.notifier).editStock(
              widget.product.id,
              request,
            );

        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Stock updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update stock: ${e.toString()}'),
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
      title: const Text('Edit Stock'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.product.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Note: You can only reduce stock, not increase it.',
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.red),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.product.prices
                    .where((price) => price.type.toString() != 'GANTANG')
                    .length,
                itemBuilder: (context, index) {
                  final priceVariant = widget.product.prices
                      .where((price) => price.type.toString() != 'GANTANG')
                      .toList()[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${priceVariant.type.toString().split('.').last} (₱ ${priceVariant.price})',
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 100,
                          child: TextFormField(
                            initialValue: priceVariant.stock.toString(),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              isDense: true,
                              border: const OutlineInputBorder(),
                              labelText: 'Stock',
                              suffixText: '/ ${priceVariant.stock}',
                            ),
                            onChanged: (value) {
                              final newStock =
                                  int.tryParse(value) ?? priceVariant.stock;
                              setState(() {
                                _updatedStocks[priceVariant.id] = newStock;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submitEditStock,
          child: _isSubmitting
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : const Text('Save Changes'),
        ),
      ],
    );
  }
}
