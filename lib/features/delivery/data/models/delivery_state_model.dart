class DeliveryState {
  final bool isFinished;
  final DateTime? timeFinished;
  final String driver;
  final List<String> attachments;

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
    List<String>? attachments,
  }) {
    return DeliveryState(
      isFinished: isFinished ?? this.isFinished,
      timeFinished: timeFinished ?? this.timeFinished,
      driver: driver ?? this.driver,
      attachments: attachments ?? this.attachments,
    );
  }
}
