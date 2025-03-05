import 'package:falsisters_pos_app/features/sales/data/models/price_model.dart';

class KahonTransferredItem {
  final String id;
  final int qty;
  final String name;
  final Price price;
  final String kahonId;
  final double value;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<KahonTransferredItemModifier> kahonTransferredItemModifier;

  KahonTransferredItem({
    required this.id,
    required this.qty,
    required this.price,
    required this.name,
    this.value = 0,
    required this.kahonId,
    required this.createdAt,
    required this.updatedAt,
    this.kahonTransferredItemModifier = const [],
  });

  factory KahonTransferredItem.fromJson(Map<String, dynamic> json) {
    return KahonTransferredItem(
      id: json['id'],
      qty: json['qty'],
      name: json['name'],
      price: Price.fromJson(json['price']),
      kahonId: json['kahonId'],
      value: json['value'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      kahonTransferredItemModifier:
          (json['KahonTransferredItemModifier'] as List?)
                  ?.map((e) => KahonTransferredItemModifier.fromJson(e))
                  .toList() ??
              [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'qty': qty,
      'price': price.toJson(),
      'name': name,
      'kahonId': kahonId,
      'value': value,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'kahonTransferredItemModifier':
          kahonTransferredItemModifier.map((e) => e.toJson()).toList(),
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
      value: json['value'] ?? 0,
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
