class Shift {
  final String id;
  final String cashierId;
  final String employee;
  final DateTime clockIn;
  final DateTime clockOut;

  Shift({
    required this.id,
    required this.cashierId,
    required this.employee,
    required this.clockIn,
    required this.clockOut,
  });

  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      id: json['id'],
      cashierId: json['cashierId'],
      employee: json['employee'],
      clockIn: DateTime.parse(json['clockIn']),
      clockOut: DateTime.parse(json['clockOut']),
    );
  }

  bool get isActive {
    final now = DateTime.now();
    return now.isBefore(clockOut);
  }
}
