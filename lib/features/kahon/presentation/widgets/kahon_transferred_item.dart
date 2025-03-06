import 'package:falsisters_pos_app/features/kahon/presentation/widgets/add_modifier.dart';
import 'package:falsisters_pos_app/features/kahon/presentation/widgets/modifier.dart';
import 'package:flutter/material.dart';
import 'package:falsisters_pos_app/features/kahon/data/models/kahon_transferred_item_model.dart';

class KahonTransferredItemWidget extends StatelessWidget {
  final KahonTransferredItem item;
  final Function(String itemId, OperationType operation, double value)
      onModifierAdded;
  final Function(String itemId, String modifierId) onModifierRemoved;

  const KahonTransferredItemWidget({
    Key? key,
    required this.item,
    required this.onModifierAdded,
    required this.onModifierRemoved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine if item is PER_KILO type
    bool isPerKilo =
        item.price != null && item.price!.type.toString().contains('PER_KILO');

    // Calculate item value with all modifiers applied
    double baseValue = item.value;
    if (item.price != null) {
      baseValue = item.price!.price * item.qty;
    }

    double calculatedValue = baseValue;
    for (var modifier in item.kahonTransferredItemModifier) {
      calculatedValue =
          _applyOperation(calculatedValue, modifier.operation, modifier.value);
    }

    // Format display name
    String displayName =
        item.name ?? (item.price?.product.name ?? 'Unknown Item');
    if (isPerKilo) {
      displayName = '$displayName (${item.qty}kg)';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Row(
          children: [
            if (!isPerKilo)
              Text(
                '${item.qty}x',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            if (!isPerKilo) const SizedBox(width: 8),
            Expanded(
              child: Text(
                displayName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              '₱${calculatedValue.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        subtitle: Text(
          item.price != null
              ? 'Price: ₱${item.price!.price}/unit'
              : 'Value: ₱${item.value}',
        ),
        children: [
          // Modifiers list
          if (item.kahonTransferredItemModifier.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: item.kahonTransferredItemModifier.length,
              itemBuilder: (context, index) {
                final modifier = item.kahonTransferredItemModifier[index];
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
    }
  }
}
