import 'package:falsisters_pos_app/features/sales/data/models/price_model.dart';

class KahonTransferredItem {
  final String id;
  final int qty;
  final Price price;
  final String kahonId;
  final double value;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<KahonTransferredItemModifier> kahonTransferredItemModifiers;

  KahonTransferredItem({
    required this.id,
    required this.qty,
    required this.price,
    this.value = 0,
    required this.kahonId,
    required this.createdAt,
    required this.updatedAt,
    this.kahonTransferredItemModifiers = const [],
  });

  factory KahonTransferredItem.fromJson(Map<String, dynamic> json) {
    return KahonTransferredItem(
      id: json['id'],
      qty: json['qty'],
      price: Price.fromJson(json['price']),
      kahonId: json['kahonId'],
      value: json['value'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      kahonTransferredItemModifiers:
          (json['kahonTransferredItemModifiers'] as List)
              .map((e) => KahonTransferredItemModifier.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'qty': qty,
      'price': price.toJson(),
      'kahonId': kahonId,
      'value': value,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'kahonTransferredItemModifiers':
          kahonTransferredItemModifiers.map((e) => e.toJson()).toList(),
    };
  }
}

enum OperationType { ADDITION, SUBTRACTION, MULTIPLICATION, DIVISION, TOTAL }

class KahonTransferredItemModifier {
  final String id;
  final int index;
  final OperationType operation;
  final double value;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String kahonTransferredItemId;

  KahonTransferredItemModifier({
    required this.id,
    required this.index,
    required this.operation,
    this.value = 0,
    required this.createdAt,
    required this.updatedAt,
    required this.kahonTransferredItemId,
  });

  factory KahonTransferredItemModifier.fromJson(Map<String, dynamic> json) {
    return KahonTransferredItemModifier(
      id: json['id'],
      index: json['index'],
      value: json['value'],
      operation: OperationType.values
          .firstWhere((e) => e.toString().split('.').last == json['operation']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      kahonTransferredItemId: json['kahonTransferredItemId'],
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
      'kahonTransferredItemId': kahonTransferredItemId,
    };
  }
}
