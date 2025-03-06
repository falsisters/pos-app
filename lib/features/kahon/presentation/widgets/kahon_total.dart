import 'package:falsisters_pos_app/features/kahon/presentation/widgets/add_modifier.dart';
import 'package:falsisters_pos_app/features/kahon/presentation/widgets/modifier.dart';
import 'package:flutter/material.dart';
import 'package:falsisters_pos_app/features/kahon/data/models/kahon_model.dart';
import 'package:falsisters_pos_app/features/kahon/data/models/kahon_transferred_item_model.dart';

class KahonTotalWidget extends StatelessWidget {
  final int itemCount;
  final double subTotal;
  final List<KahonTotalModifier> totalModifiers;
  final double grandTotal;
  final Function(OperationType operation, double value) onTotalModifierAdded;
  final Function(String modifierId) onTotalModifierRemoved;

  const KahonTotalWidget({
    Key? key,
    required this.itemCount,
    required this.subTotal,
    required this.totalModifiers,
    required this.grandTotal,
    required this.onTotalModifierAdded,
    required this.onTotalModifierRemoved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Item Count
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total Items:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '$itemCount',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Subtotal
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Subtotal:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '₱${subTotal.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Total Modifiers
        if (totalModifiers.isNotEmpty) ...[
          const Text(
            'Modifiers:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: totalModifiers.length,
            itemBuilder: (context, index) {
              final modifier = totalModifiers[index];
              return ModifierWidget(
                modifier: modifier,
                onRemove: () => onTotalModifierRemoved(modifier.id),
              );
            },
          ),
          const SizedBox(height: 8),
        ],

        // Grand Total
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey.shade400),
              bottom: BorderSide(color: Colors.grey.shade400),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'GRAND TOTAL:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                '₱${grandTotal.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Add Modifier Button
        ElevatedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Add Total Modifier'),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AddModifierDialog(
                onModifierAdded: onTotalModifierAdded,
              ),
            );
          },
        ),
      ],
    );
  }
}
