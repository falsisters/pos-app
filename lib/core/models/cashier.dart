class Cashier {
  final String id;
  final String name;
  final String userId;
  final List<String> permissions;

  Cashier({
    required this.id,
    required this.name,
    required this.userId,
    required this.permissions,
  });

  factory Cashier.fromJson(Map<String, dynamic> json) {
    return Cashier(
      id: json['id'],
      name: json['name'],
      userId: json['userId'],
      permissions: List<String>.from((json['permissions'] as List)
          .map((permission) => permission['name'] as String)),
    );
  }
}
