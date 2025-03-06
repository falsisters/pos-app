import 'package:falsisters_pos_app/features/kahon/presentation/widgets/add_modifier.dart';
import 'package:falsisters_pos_app/features/kahon/presentation/widgets/modifier.dart';
import 'package:flutter/material.dart';
import 'package:falsisters_pos_app/features/kahon/data/models/kahon_item.dart';
import 'package:falsisters_pos_app/features/kahon/data/models/kahon_transferred_item_model.dart';

class KahonItemWidget extends StatelessWidget {
  final KahonItem item;
  final Function(String itemId, OperationType operation, double value)
      onModifierAdded;
  final Function(String itemId, String modifierId) onModifierRemoved;
  final Function(String itemId) onItemDeleted;

  const KahonItemWidget({
    Key? key,
    required this.item,
    required this.onModifierAdded,
    required this.onModifierRemoved,
    required this.onItemDeleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate item value with all modifiers applied
    double calculatedValue = item.value * item.qty;
    for (var modifier in item.kahonItemModifier) {
      calculatedValue =
          _applyOperation(calculatedValue, modifier.operation, modifier.value);
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Row(
          children: [
            Text(
              '${item.qty}x',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(item.name),
            ),
            Text(
              '₱${calculatedValue.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        subtitle: Text('Base price: ₱${item.value}/unit'),
        children: [
          // Modifiers list
          if (item.kahonItemModifier.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: item.kahonItemModifier.length,
              itemBuilder: (context, index) {
                final modifier = item.kahonItemModifier[index];
                return ModifierWidget(
                  modifier: modifier,
                  onRemove: () => onModifierRemoved(item.id, modifier.id),
                );
              },
            ),

          // Actions
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Delete'),
                  onPressed: () => onItemDeleted(item.id),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add Modifier'),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AddModifierDialog(
                        onModifierAdded: (operation, value) {
                          onModifierAdded(item.id, operation, value);
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _applyOperation(
      double value, OperationType operation, double modifierValue) {
    switch (operation) {
      case OperationType.ADDITION:
        return value + modifierValue;
      case OperationType.SUBTRACTION:
        return value - modifierValue;
      case OperationType.MULTIPLICATION:
        return value * modifierValue;
      case OperationType.DIVISION:
        return modifierValue != 0 ? value / modifierValue : value;
      case OperationType.TOTAL:
        return modifierValue; // Replace with the specified value
      default:
        return value;
    }
  }
}
