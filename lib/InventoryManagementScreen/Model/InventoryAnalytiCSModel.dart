class InventoryAnalyticsModel {
  final int totalSKUs;
  final int lowStockAlerts;
  final int inventoryValue;

  InventoryAnalyticsModel({
    required this.totalSKUs,
    required this.lowStockAlerts,
    required this.inventoryValue,
  });

  factory InventoryAnalyticsModel.fromJson(Map<String, dynamic> json) {
    return InventoryAnalyticsModel(
      totalSKUs: json['totalSKUs'] ?? 0,
      lowStockAlerts: json['lowStockAlerts'] ?? 0,
      inventoryValue: json['inventoryValue'] ?? 0,
    );
  }
}