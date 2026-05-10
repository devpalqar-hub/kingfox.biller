class AnalyticsModel {
  final Summary summary;
  final List<TopSeller> topSellers;
  final List<DailySale> dailySales;

  AnalyticsModel({
    required this.summary,
    required this.topSellers,
    required this.dailySales,
  });

  factory AnalyticsModel.fromJson(Map<String, dynamic> json) => AnalyticsModel(
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
  double totalOrders;
  double averageOrderValue;
  double returnRate;
  double totalSales;
  double totalRevenue;
  double refundAmount;
  double returnCouponRedeemedSales;
  double transactionsCount;
  double totalGstCollected;
  double totalCollectedByOnline;
  double totalCollectedByHand;
  double totalRefunds;
  double netRevenue;

  Summary({
    this.totalOrders = 0,
    this.averageOrderValue = 0,
    this.returnRate = 0,
    this.totalSales = 0,
    this.totalRevenue = 0,
    this.refundAmount = 0,
    this.returnCouponRedeemedSales = 0,
    this.transactionsCount = 0,
    this.totalGstCollected = 0,
    this.totalCollectedByOnline = 0,
    this.totalCollectedByHand = 0,
    this.totalRefunds = 0,
    this.netRevenue = 0,
  });

  Summary.fromJson(Map<String, dynamic> json)
    : totalOrders = (json['totalOrders'] ?? 0).toDouble(),
      averageOrderValue = (json['averageOrderValue'] ?? 0).toDouble(),
      returnRate = (json['returnRate'] ?? 0).toDouble(),
      totalSales = (json['totalSales'] ?? 0).toDouble(),
      totalRevenue = (json['totalRevenue'] ?? 0).toDouble(),
      refundAmount = (json['refundAmount'] ?? 0).toDouble(),
      returnCouponRedeemedSales = (json['returnCouponRedeemedSales'] ?? 0)
          .toDouble(),
      transactionsCount = (json['transactionsCount'] ?? 0).toDouble(),
      totalGstCollected = (json['totalGstCollected'] ?? 0).toDouble(),
      totalCollectedByOnline = (json['totalCollectedByOnline'] ?? 0).toDouble(),
      totalCollectedByHand = (json['totalCollectedByHand'] ?? 0).toDouble(),
      totalRefunds = (json['totalRefunds'] ?? 0).toDouble(),
      netRevenue = (json['netRevenue'] ?? 0).toDouble();

  Map<String, dynamic> toJson() {
    return {
      'totalOrders': totalOrders,
      'averageOrderValue': averageOrderValue,
      'returnRate': returnRate,
      'totalSales': totalSales,
      'totalRevenue': totalRevenue,
      'refundAmount': refundAmount,
      'returnCouponRedeemedSales': returnCouponRedeemedSales,
      'transactionsCount': transactionsCount,
      'totalGstCollected': totalGstCollected,
      'totalCollectedByOnline': totalCollectedByOnline,
      'totalCollectedByHand': totalCollectedByHand,
      'totalRefunds': totalRefunds,
      'netRevenue': netRevenue,
    };
  }
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

  DailySale({required this.date, required this.sales, required this.orders});

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
