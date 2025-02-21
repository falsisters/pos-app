class SpecialPrice {
  final String id;
  final double specialPrice;
  final int minimumQty;

  const SpecialPrice({
    required this.id,
    required this.specialPrice,
    required this.minimumQty,
  });

  factory SpecialPrice.fromJson(Map<String, dynamic> json) {
    return SpecialPrice(
      id: json['id'],
      specialPrice: json['specialPrice'].toDouble(),
      minimumQty: json['minimumQty'],
    );
  }
}
