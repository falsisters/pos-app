import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:falsisters_pos_app/features/kahon/data/models/kahon_transferred_item_model.dart';

class AddModifierDialog extends StatefulWidget {
  final Function(OperationType operation, double value) onModifierAdded;

  const AddModifierDialog({
    Key? key,
    required this.onModifierAdded,
  }) : super(key: key);

  @override
  State<AddModifierDialog> createState() => _AddModifierDialogState();
}

class _AddModifierDialogState extends State<AddModifierDialog> {
  final _formKey = GlobalKey<FormState>();
  final _valueController = TextEditingController(text: '0.00');
  OperationType _selectedOperation = OperationType.ADDITION;

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Modifier'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<OperationType>(
              value: _selectedOperation,
              decoration: const InputDecoration(
                labelText: 'Operation',
                border: OutlineInputBorder(),
              ),
              items: OperationType.values.map((op) {
                return DropdownMenuItem<OperationType>(
                  value: op,
                  child: Text(_getOperationLabel(op)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedOperation = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _valueController,
              decoration: const InputDecoration(
                labelText: 'Value',
                border: OutlineInputBorder(),
                prefixText: '₱',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a value';
                }
                final number = double.tryParse(value);
                if (number == null) {
                  return 'Value must be a valid number';
                }
                return null;
              },
            ),
          ],
        ),
      ),