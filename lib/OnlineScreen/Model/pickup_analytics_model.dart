class PickupAnalytics {
  final int totalPickupOrders;
  final int pendingPickupOrders;
  final int deliveredPickupOrders;
  final double totalRevenue;

  PickupAnalytics({
    required this.totalPickupOrders,
    required this.pendingPickupOrders,
    required this.deliveredPickupOrders,
    required this.totalRevenue,
  });

  factory PickupAnalytics.fromJson(Map<String, dynamic> json) {
    return PickupAnalytics(
      totalPickupOrders: json['totalPickupOrders'] ?? 0,
      pendingPickupOrders: json['pendingPickupOrders'] ?? 0,
      deliveredPickupOrders: json['deliveredPickupOrders'] ?? 0,
      totalRevenue: (json['totalRevenue'] ?? 0).toDouble(),
    );
  }
}