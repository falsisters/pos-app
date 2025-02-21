import 'package:image_picker/image_picker.dart';

class DeliveryState {
  final bool isFinished;
  final DateTime? timeFinished;
  final String driver;
  final List<XFile>
      attachments; // Changed to XFile for image_picker compatibility

  DeliveryState({
    this.isFinished = false,
    this.timeFinished,
    required this.driver,
    this.attachments = const [],
  });

  DeliveryState copyWith({
    bool? isFinished,
    DateTime? timeFinished,
    String? driver,
    List<XFile>? attachments,
  }) {
    return DeliveryState(
      isFinished: isFinished ?? this.isFinished,
      timeFinished: timeFinished ?? this.timeFinished,
      driver: driver ?? this.driver,
      attachments: attachments ?? this.attachments,
    );
  }
}
