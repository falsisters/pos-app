import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddKahonItemDialog extends StatefulWidget {
  final Function(String name, int qty, double value) onItemAdded;

  const AddKahonItemDialog({
    Key? key,
    required this.onItemAdded,
  }) : super(key: key);

  @override
  State<AddKahonItemDialog> createState() => _AddKahonItemDialogState();
}

class _AddKahonItemDialogState extends State<AddKahonItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _qtyController = TextEditingController(text: '1');
  final _valueController = TextEditingController(text: '0.00');

  @override
  void dispose() {
    _nameController.dispose();
    _qtyController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Item'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Item Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _qtyController,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a quantity';
                }
                final qty = int.tryParse(value);
                if (qty == null || qty <= 0) {
                  return 'Quantity must be a positive number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _valueController,
              decoration: const InputDecoration(
                labelText: 'Value (₱)',
                border: OutlineInputBorder(),
                prefixText: '₱',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a value';
                }
                final price = double.tryParse(value);
                if (price == null || price < 0) {
                  return 'Value must be a valid number';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final name = _nameController.text;
              final qty = int.parse(_qtyController.text);
              final value = double.parse(_valueController.text);

              widget.onItemAdded(name, qty, value);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
