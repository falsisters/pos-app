import 'package:flutter/material.dart';
import 'package:falsisters_pos_app/features/kahon/data/models/kahon_transferred_item_model.dart';

class ModifierWidget extends StatelessWidget {
  final dynamic
      modifier; // Could be KahonItemModifier, KahonTransferredItemModifier, or KahonTotalModifier
  final VoidCallback onRemove;

  const ModifierWidget({
    Key? key,
    required this.modifier,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String operationText = _getOperationText(modifier.operation);
    IconData operationIcon = _getOperationIcon(modifier.operation);

    return ListTile(
      dense: true,
      leading: CircleAvatar(
        backgroundColor: _getOperationColor(modifier.operation),
        child: Icon(operationIcon, color: Colors.white, size: 18),
      ),
      title: Text(
        '$operationText ${modifier.value.toStringAsFixed(2)}',
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text('Index: ${modifier.index}'),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, color: Colors.red),
        onPressed: onRemove,
      ),
    );
  }

  String _getOperationText(OperationType operation) {
    switch (operation) {
      case OperationType.ADDITION:
        return '+';
      case OperationType.SUBTRACTION:
        return '-';
      case OperationType.MULTIPLICATION:
        return '×';
      case OperationType.DIVISION:
        return '÷';
      case OperationType.TOTAL:
        return '=';
      default:
        return '';
    }
  }

  IconData _getOperationIcon(OperationType operation) {
    switch (operation) {
      case OperationType.ADDITION:
        return Icons.add;
      case OperationType.SUBTRACTION:
        return Icons.remove;
      case OperationType.MULTIPLICATION:
        return Icons.close;
      case OperationType.DIVISION:
        return Icons.star;
      case OperationType.TOTAL:
        return Icons.drag_handle;
      default:
        return Icons.question_mark;
    }
  }

  Color _getOperationColor(OperationType operation) {
    switch (operation) {
      case OperationType.ADDITION:
        return Colors.green;
      case OperationType.SUBTRACTION:
        return Colors.red;
      case OperationType.MULTIPLICATION:
        return Colors.blue;
      case OperationType.DIVISION:
        return Colors.orange;
      case OperationType.TOTAL:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
