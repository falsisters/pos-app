// lib/features/stocks/presentation/dialogs/transfer_stock_dialog.dart
import 'dart:io';
import 'package:falsisters_pos_app/features/sales/data/models/price_model.dart';
import 'package:falsisters_pos_app/features/stocks/data/providers/stock_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:falsisters_pos_app/features/sales/data/models/product_model.dart';
import 'package:falsisters_pos_app/features/stocks/data/models/stock_model.dart';
import 'package:falsisters_pos_app/features/stocks/data/models/transfer_stock_model.dart';

class TransferStockDialog extends ConsumerStatefulWidget {
  final Product product;

  const TransferStockDialog({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  ConsumerState<TransferStockDialog> createState() =>
      _TransferStockDialogState();
}

class _TransferStockDialogState extends ConsumerState<TransferStockDialog> {
  Price? _selectedPrice;
  int _transferQuantity = 0;
  TransferType _transferType = TransferType.OWN_CONSUMPTION;
  final List<XFile> _attachments = [];
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.product.prices.isNotEmpty) {
      _selectedPrice = widget.product.prices.first;
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _attachments.add(XFile(image.path));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removeAttachment(int index) {
    setState(() {
      _attachments.removeAt(index);
    });
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

    if (_attachments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one attachment'),
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
            'Are you sure you want to transfer ${_transferQuantity} units of ${_selectedPrice!.type.toString().split('.').last} as ${_transferType.toString().split('.').last}?',
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
      final request = TransferStockRequest(
        price: StockUpdate(
          id: _selectedPrice!.id,
          stock: _transferQuantity,
          type: _selectedPrice!.type,
        ),
        qty: _transferQuantity,
        type: _transferType,
      );

      await ref
          .read(stocksProvider.notifier)
          .transferStock(request, _attachments);

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
              DropdownButtonFormField<TransferType>(
                value: _transferType,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: TransferType.values.map((type) {
                  return DropdownMenuItem<TransferType>(
                    value: type,
                    child: Text(
                        type.toString().split('.').last.replaceAll('_', ' ')),
                  );
                }).toList(),
                onChanged: (TransferType? value) {
                  if (value != null) {
                    setState(() {
                      _transferType = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              // Attachments
              const Text(
                'Attachments:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              if (_attachments.isEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Center(
                    child: Text('No attachments added'),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(
                      _attachments.length,
                      (index) => Stack(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              image: DecorationImage(
                                image:
                                    FileImage(File(_attachments[index].path)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: GestureDetector(
                              onTap: () => _removeAttachment(index),
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.add_photo_alternate),
                label: const Text('Add Photo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                ),
              ),
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
