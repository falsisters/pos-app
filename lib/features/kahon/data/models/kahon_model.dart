import 'package:falsisters_pos_app/features/kahon/data/models/kahon_item.dart';
import 'package:falsisters_pos_app/features/kahon/data/models/kahon_transferred_item_model.dart';

class Kahon {
  final String id;
  final String cashierId;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<KahonTransferredItem> kahonTransferredItems;
  final List<KahonItem> kahonItems;
  final List<KahonTotalModifier> kahonTotalModifiers;

  Kahon({
    required this.id,
    required this.cashierId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.kahonTransferredItems = const [],
    this.kahonItems = const [],
    this.kahonTotalModifiers = const [],
  });

  factory Kahon.fromJson(Map<String, dynamic> json) {
    return Kahon(
      id: json['id'],
      cashierId: json['cashierId'],
      name: json['name'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      kahonTransferredItems: (json['kahonTransferredItems'] as List)
          .map((e) => KahonTransferredItem.fromJson(e))
          .toList(),
      kahonItems: (json['kahonItems'] as List)
          .map((e) => KahonItem.fromJson(e))
          .toList(),
      kahonTotalModifiers: (json['kahonTotalModifiers'] as List)
          .map((e) => KahonTotalModifier.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cashierId': cashierId,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'kahonTransferredItems':
          kahonTransferredItems.map((e) => e.toJson()).toList(),
      'kahonItems': kahonItems.map((e) => e.toJson()).toList(),
      'kahonTotalModifiers':
          kahonTotalModifiers.map((e) => e.toJson()).toList(),
    };
  }
}

class KahonTotalModifier {
  final String id;
  final int index;
  final double value;
  final OperationType operation;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String kahonId;

  KahonTotalModifier({
    required this.id,
    required this.index,
    this.value = 0,
    required this.operation,
    required this.createdAt,
    required this.updatedAt,
    required this.kahonId,
  });

  factory KahonTotalModifier.fromJson(Map<String, dynamic> json) {
    return KahonTotalModifier(
      id: json['id'],
      index: json['index'],
      value: json['value'],
      operation: OperationType.values.firstWhere(
        (e) => e.toString() == 'OperationType.${json['operation']}',
      ),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      kahonId: json['kahonId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      'index': index,
      'operation': operation.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'kahonId': kahonId,
    };
  }
}
