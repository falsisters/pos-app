import 'package:falsisters_pos_app/features/delivery/data/models/delivery_state_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final deliveryStateProvider =
    StateNotifierProvider<DeliveryStateNotifier, DeliveryState>((ref) {
  return DeliveryStateNotifier();
});

class DeliveryStateNotifier extends StateNotifier<DeliveryState> {
  DeliveryStateNotifier() : super(DeliveryState(driver: ''));

  void setDriver(String driver) {
    state = state.copyWith(driver: driver);
  }

  void setFinished(bool isFinished) {
    state = state.copyWith(
      isFinished: isFinished,
      timeFinished: isFinished ? DateTime.now() : null,
    );
  }

  void addAttachment(XFile attachment) {
    state = state.copyWith(
      attachments: [...state.attachments, attachment],
    );
  }

  void removeAttachment(XFile attachment) {
    state = state.copyWith(
      attachments: state.attachments.where((a) => a != attachment).toList(),
    );
  }

  void clear() {
    state = DeliveryState(driver: '');
  }
}
