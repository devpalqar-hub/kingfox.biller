class AnalyticsModel {
  final Summary summary;
  final List<TopSeller> topSellers;
  final List<DailySale> dailySales;

  AnalyticsModel({
    required this.summary,
    required this.topSellers,
    required this.dailySales,
  });

  factory AnalyticsModel.fromJson(Map<String, dynamic> json) =>
      AnalyticsModel(
        summary: Summary.fromJson(json['summary'] ?? {}),
        topSellers: (json['topSellers'] ?? [])
            .map<TopSeller>((e) => TopSeller.fromJson(e))
            .toList(),
        dailySales: (json['dailySales'] ?? [])
            .map<DailySale>((e) => DailySale.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'summary': summary.toJson(),
        'topSellers': topSellers.map((e) => e.toJson()).toList(),
        'dailySales': dailySales.map((e) => e.toJson()).toList(),
      };
}

class Summary {
  final double totalOrders;
  final double averageOrderValue;
  final double returnRate;
  final double totalRefunds;
  final double netRevenue;
  final double transactionsCount;
  final double totalSales;

  Summary({
    required this.totalOrders,
    required this.averageOrderValue,
    required this.returnRate,
    required this.totalRefunds,
    required this.netRevenue,
    required this.transactionsCount,
    required this.totalSales,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        totalOrders: (json['totalOrders'] ?? 0).toDouble(),
        averageOrderValue: (json['averageOrderValue'] ?? 0).toDouble(),
        returnRate: (json['returnRate'] ?? 0).toDouble(),
        totalRefunds: (json['totalRefunds'] ?? 0).toDouble(),
        netRevenue: (json['netRevenue'] ?? 0).toDouble(),
        transactionsCount: (json['transactionsCount'] ?? 0).toDouble(),
        totalSales: (json['totalSales'] ?? 0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'totalOrders': totalOrders,
        'averageOrderValue': averageOrderValue,
        'returnRate': returnRate,
        'totalRefunds': totalRefunds,
        'netRevenue': netRevenue,
        'transactionsCount': transactionsCount,
        'totalSales': totalSales,
      };
}

class TopSeller {
  final int variantId;
  final String sku;
  final String size;
  final String color;
  final String productName;
  final int totalQtySold;
  final double totalRevenue;

  TopSeller({
    required this.variantId,
    required this.sku,
    required this.size,
    required this.color,
    required this.productName,
    required this.totalQtySold,
    required this.totalRevenue,
  });

  factory TopSeller.fromJson(Map<String, dynamic> json) => TopSeller(
        variantId: json['variantId'] ?? 0,
        sku: json['sku'] ?? '',
        size: json['size'] ?? '',
        color: json['color'] ?? '',
        productName: json['productName'] ?? '',
        totalQtySold: json['totalQtySold'] ?? 0,
        totalRevenue: (json['totalRevenue'] ?? 0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'variantId': variantId,
        'sku': sku,
        'size': size,
        'color': color,
        'productName': productName,
        'totalQtySold': totalQtySold,
        'totalRevenue': totalRevenue,
      };
}

class DailySale {
  final String date;
  final double sales;
  final double orders;

  DailySale({
    required this.date,
    required this.sales,
    required this.orders,
  });

  factory DailySale.fromJson(Map<String, dynamic> json) => DailySale(
        date: json['date'] ?? '',
        sales: (json['sales'] ?? 0).toDouble(),
        orders: (json['orders'] ?? 0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'date': date,
        'sales': sales,
        'orders': orders,
      };
}