import 'package:falsisters_pos_app/features/kahon/data/models/kahon_item.dart';
import 'package:falsisters_pos_app/features/kahon/data/models/kahon_model.dart';
import 'package:falsisters_pos_app/features/kahon/data/models/kahon_transferred_item_model.dart';
import 'package:falsisters_pos_app/features/kahon/presentation/widgets/kahon_transferred_items_list.dart';
import 'package:flutter/material.dart';

class ModifierForm extends StatefulWidget {
  final Function(dynamic) onSubmit;

  const ModifierForm({Key? key, required this.onSubmit}) : super(key: key);

  @override
  _ModifierFormState createState() => _ModifierFormState();
}

class _ModifierFormState extends State<ModifierForm> {
  final _formKey = GlobalKey<FormState>();
  OperationType _selectedOperation = OperationType.ADDITION;
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _indexController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<OperationType>(
            value: _selectedOperation,
            onChanged: (value) {
              setState(() {
                _selectedOperation = value!;
              });
            },
            items: OperationType.values
                .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type.toString().split('.').last),
                    ))
                .toList(),
            decoration: const InputDecoration(labelText: 'Operation'),
          ),
          TextFormField(
            controller: _valueController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Value'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a value';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _indexController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Index'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an index';
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Dynamically create the appropriate modifier based on the parent context
                final modifier = context.findAncestorWidgetOfExactType<
                            KahonTransferredItemsList>() !=
                        null
                    ? KahonTransferredItemModifier(
                        id: DateTime.now().toIso8601String(),
                        index: int.parse(_indexController.text),
                        operation: _selectedOperation,
                        value: double.parse(_valueController.text),
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                        kahonTransferredItemId:
                            '', // You might want to pass this dynamically
                      )
                    : KahonItemModifier(
                        id: DateTime.now().toIso8601String(),
                        index: int.parse(_indexController.text),
                        operation: _selectedOperation,
                        value: double.parse(_valueController.text),
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                        kahonItemId:
                            '', // You might want to pass this dynamically
                      );

                widget.onSubmit(modifier);
              }
            },
            child: const Text('Add Modifier'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _valueController.dispose();
    _indexController.dispose();
    super.dispose();
  }
}

// Utility function to calculate total value with modifiers
double calculateTotalValue(Kahon kahon) {
  double total = 0;

  // Calculate transferred items total
  for (var item in kahon.kahonTransferredItem) {
    double itemValue = item.value;
    for (var modifier in item.kahonTransferredItemModifier) {
      switch (modifier.operation) {
        case OperationType.ADDITION:
          itemValue += modifier.value;
          break;
        case OperationType.SUBTRACTION:
          itemValue -= modifier.value;
          break;
        case OperationType.MULTIPLICATION:
          itemValue *= modifier.value;
          break;
        case OperationType.DIVISION:
          itemValue /= modifier.value;
          break;
        case OperationType.TOTAL:
          itemValue = modifier.value;
          break;
      }
    }
    total += itemValue;
  }

  // Calculate kahon items total
  for (var item in kahon.kahonItem) {
    double itemValue = item.value;
    for (var modifier in item.kahonItemModifier) {
      switch (modifier.operation) {
        case OperationType.ADDITION:
          itemValue += modifier.value;
          break;
        case OperationType.SUBTRACTION:
          itemValue -= modifier.value;
          break;
        case OperationType.MULTIPLICATION:
          itemValue *= modifier.value;
          break;
        case OperationType.DIVISION:
          itemValue /= modifier.value;
          break;
        case OperationType.TOTAL:
          itemValue = modifier.value;
          break;
      }
    }
    total += itemValue;
  }

  // Apply total modifiers
  for (var modifier in kahon.kahonTotalModifier) {
    switch (modifier.operation) {
      case OperationType.ADDITION:
        total += modifier.value;
        break;
      case OperationType.SUBTRACTION:
        total -= modifier.value;
        break;
      case OperationType.MULTIPLICATION:
        total *= modifier.value;
        break;
      case OperationType.DIVISION:
        total /= modifier.value;
        break;
      case OperationType.TOTAL:
        total = modifier.value;
        break;
    }
  }

  return total;
}
