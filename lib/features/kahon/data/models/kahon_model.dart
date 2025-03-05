import 'package:falsisters_pos_app/features/kahon/data/models/kahon_item.dart';
import 'package:falsisters_pos_app/features/kahon/data/models/kahon_transferred_item_model.dart';

class Kahon {
  final String id;
  final String cashierId;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<KahonTransferredItem> kahonTransferredItem;
  final List<KahonItem> kahonItem;
  final List<KahonTotalModifier> kahonTotalModifier;

  Kahon({
    required this.id,
    required this.cashierId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.kahonTransferredItem = const [],
    this.kahonItem = const [],
    this.kahonTotalModifier = const [],
  });

  factory Kahon.fromJson(Map<String, dynamic> json) {
    return Kahon(
        id: json['id'],
        cashierId: json['cashierId'],
        name: json['name'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        kahonTransferredItem: (json['KahonTransferredItem'] is List)
            ? (json['KahonTransferredItem'] as List)
                .map((e) => KahonTransferredItem.fromJson(e))
                .toList()
            : [],
        kahonItem: (json['KahonItem'] is List)
            ? (json['KahonItem'] as List)
                .map((e) => KahonItem.fromJson(e))
                .toList()
            : [],
        kahonTotalModifier: (json['KahonTotalModifier'] is List)
            ? (json['KahonTotalModifier'] as List)
                .map((e) => KahonTotalModifier.fromJson(e))
                .toList()
            : []);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cashierId': cashierId,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'kahonTransferredItem': kahonTransferredItem.isEmpty
          ? []
          : kahonTransferredItem.map((e) => e.toJson()).toList(),
      'kahonItem':
          kahonItem.isEmpty ? [] : kahonItem.map((e) => e.toJson()).toList(),
      'kahonTotalModifier': kahonTotalModifier.isEmpty
          ? []
          : kahonTotalModifier.map((e) => e.toJson()).toList(),
    };
  }

  Kahon copyWith({
    String? id,
    String? cashierId,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<KahonTransferredItem>? kahonTransferredItem,
    List<KahonItem>? kahonItem,
    List<KahonTotalModifier>? kahonTotalModifier,
  }) {
    return Kahon(
      id: id ?? this.id,
      cashierId: cashierId ?? this.cashierId,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      kahonTransferredItem: kahonTransferredItem ?? this.kahonTransferredItem,
      kahonItem: kahonItem ?? this.kahonItem,
      kahonTotalModifier: kahonTotalModifier ?? this.kahonTotalModifier,
    );
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
      value: json['value'] ?? 0,
      operation: OperationType.values
          .firstWhere((e) => e.toString().split('.').last == json['operation']),
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
