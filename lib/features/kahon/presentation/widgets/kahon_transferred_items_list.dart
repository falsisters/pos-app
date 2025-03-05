import 'package:falsisters_pos_app/features/kahon/data/models/kahon_transferred_item_model.dart';
import 'package:falsisters_pos_app/features/kahon/presentation/widgets/modifier_form.dart';
import 'package:flutter/material.dart';

class KahonTransferredItemsList extends StatefulWidget {
  final List<KahonTransferredItem> items;
  final bool isEditing;
  final Function(List<KahonTransferredItem>) onItemsChanged;

  const KahonTransferredItemsList({
    Key? key,
    required this.items,
    required this.isEditing,
    required this.onItemsChanged,
  }) : super(key: key);

  @override
  _KahonTransferredItemsListState createState() =>
      _KahonTransferredItemsListState();
}

class _KahonTransferredItemsListState extends State<KahonTransferredItemsList> {
  late List<KahonTransferredItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.items);
  }

  void _addModifier(
      KahonTransferredItem item, KahonTransferredItemModifier modifier) {
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      final updatedItem = KahonTransferredItem(
        id: item.id,
        qty: item.qty,
        name: item.name,
        price: item.price,
        kahonId: item.kahonId,
        value: item.value,
        createdAt: item.createdAt,
        updatedAt: DateTime.now(),
        kahonTransferredItemModifier: [
          ...item.kahonTransferredItemModifier,
          modifier
        ],
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
        for (var modifier in item.kahonTransferredItemModifier) {
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
            '${item.qty} ${item.name} (${item.price.type})',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Value: $calculatedValue'),
              ...item.kahonTransferredItemModifier.map(
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

  void _showAddModifierDialog(KahonTransferredItem item) {
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
