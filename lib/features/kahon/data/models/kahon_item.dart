import 'package:falsisters_pos_app/features/kahon/data/models/kahon_transferred_item_model.dart';

class KahonItem {
  final String id;
  final int qty;
  final double value;
  final String kahonId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<KahonItemModifier> kahonItemModifiers;

  KahonItem({
    required this.id,
    required this.qty,
    this.value = 0,
    required this.kahonId,
    required this.createdAt,
    required this.updatedAt,
    this.kahonItemModifiers = const [],
  });

  factory KahonItem.fromJson(Map<String, dynamic> json) {
    return KahonItem(
      id: json['id'],
      qty: json['qty'],
      kahonId: json['kahonId'],
      value: json['value'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      kahonItemModifiers: (json['kahonItemModifiers'] as List)
          .map((e) => KahonItemModifier.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'qty': qty,
      'kahonId': kahonId,
      'value': value,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'kahonItemModifiers': kahonItemModifiers.map((e) => e.toJson()).toList(),
    };
  }
}

class KahonItemModifier {
  final String id;
  final int index;
  final double value;
  final OperationType operation;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String kahonItemId;

  KahonItemModifier({
    required this.id,
    required this.index,
    required this.operation,
    this.value = 0,
    required this.createdAt,
    required this.updatedAt,
    required this.kahonItemId,
  });

  factory KahonItemModifier.fromJson(Map<String, dynamic> json) {
    return KahonItemModifier(
      id: json['id'],
      index: json['index'],
      value: json['value'],
      operation: OperationType.values
          .firstWhere((e) => e.toString().split('.').last == json['operation']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      kahonItemId: json['kahonItemId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'index': index,
      'value': value,
      'operation': operation.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'kahonItemId': kahonItemId,
    };
  }
}
