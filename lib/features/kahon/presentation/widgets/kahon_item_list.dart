import 'package:falsisters_pos_app/features/kahon/data/models/kahon_item.dart';
import 'package:falsisters_pos_app/features/kahon/presentation/widgets/modifier_form.dart';
import 'package:flutter/material.dart';
import 'package:falsisters_pos_app/features/kahon/data/models/kahon_transferred_item_model.dart';

class KahonItemsList extends StatefulWidget {
  final List<KahonItem> items;
  final bool isEditing;
  final Function(List<KahonItem>) onItemsChanged;

  const KahonItemsList({
    Key? key,
    required this.items,
    required this.isEditing,
    required this.onItemsChanged,
  }) : super(key: key);

  @override
  _KahonItemsListState createState() => _KahonItemsListState();
}

class _KahonItemsListState extends State<KahonItemsList> {
  late List<KahonItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.items);
  }

  void _addModifier(KahonItem item, KahonItemModifier modifier) {
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      final updatedItem = KahonItem(
        id: item.id,
        qty: item.qty,
        kahonId: item.kahonId,
        value: item.value,
        createdAt: item.createdAt,
        updatedAt: DateTime.now(),
        kahonItemModifier: [...item.kahonItemModifier, modifier],
      );

      setState(() {
        _items[index] = updatedItem;
        widget.onItemsChanged(_items);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _items.map((item) {
        double calculatedValue = item.value;
        for (var modifier in item.kahonItemModifier) {
          switch (modifier.operation) {
            case OperationType.ADDITION:
              calculatedValue += modifier.value;
              break;
            case OperationType.SUBTRACTION:
              calculatedValue -= modifier.value;
              break;
            case OperationType.MULTIPLICATION:
              calculatedValue *= modifier.value;
              break;
            case OperationType.DIVISION:
              calculatedValue /= modifier.value;
              break;
            case OperationType.TOTAL:
              calculatedValue = modifier.value;
              break;
          }
        }

        return ListTile(
          title: Text(
            '${item.qty} ${item.kahonId}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Value: $calculatedValue'),
              ...item.kahonItemModifier.map(
                (modifier) => Text(
                  '${modifier.operation} ${modifier.value} (Index: ${modifier.index})',
                ),
              ),
            ],
          ),
          trailing: widget.isEditing
              ? IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _showAddModifierDialog(item),
                )
              : null,
        );
      }).toList(),
    );
  }

  void _showAddModifierDialog(KahonItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Modifier'),
        content: ModifierForm(
          onSubmit: (modifier) {
            _addModifier(item, modifier);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
