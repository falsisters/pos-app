import 'package:falsisters_pos_app/features/kahon/data/models/kahon_item.dart';
import 'package:falsisters_pos_app/features/kahon/data/models/kahon_model.dart';
import 'package:falsisters_pos_app/features/kahon/data/models/kahon_transferred_item_model.dart';

class UpdateKahonRequest {
  final String id;
  final String name;
  final List<KahonItem> kahonItem;
  final List<KahonTransferredItem> kahonTransferredItem;
  final List<KahonTotalModifier> kahonTotalModifier;

  UpdateKahonRequest({
    required this.id,
    required this.name,
    this.kahonItem = const [],
    this.kahonTransferredItem = const [],
    this.kahonTotalModifier = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'kahonItem':
          kahonItem.isEmpty ? [] : kahonItem.map((e) => e.toJson()).toList(),
      'kahonTransferredItem': kahonTransferredItem.isEmpty
          ? []
          : kahonTransferredItem.map((e) => e.toJson()).toList(),
      'kahonTotalModifier': kahonTotalModifier.isEmpty
          ? []
          : kahonTotalModifier.map((e) => e.toJson()).toList(),
    };
  }
}
