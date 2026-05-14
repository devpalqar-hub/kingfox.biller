class AnalyticsModel {
  final Summary summary;
  final List<TopSeller> topSellers;
  final List<DailySale> dailySales;

  AnalyticsModel({
    required this.summary,
    required this.topSellers,
    required this.dailySales,
  });

  factory AnalyticsModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsModel(
      summary: Summary.fromJson(json['summary'] ?? {}),
      topSellers: (json['topSellers'] as List<dynamic>? ?? [])
          .map((e) => TopSeller.fromJson(e as Map<String, dynamic>))
          .toList(),
      dailySales: (json['dailySales'] as List<dynamic>? ?? [])
          .map((e) => DailySale.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary': summary.toJson(),
      'topSellers': topSellers.map((e) => e.toJson()).toList(),
      'dailySales': dailySales.map((e) => e.toJson()).toList(),
    };
  }
}

class Summary {
  final int totalOrders;
  final double averageOrderValue;
  final double returnRate;
  final double totalSales;
  final double totalRevenue;
  final double totalRefunds;
  final double refundAmount;
  final int transactionsCount;
  final double totalGstCollected;
  final PaymentBreakdown paymentBreakdown;
  final double netRevenue;

  Summary({
    this.totalOrders = 0,
    this.averageOrderValue = 0,
    this.returnRate = 0,
    this.totalSales = 0,
    this.totalRevenue = 0,
    this.totalRefunds = 0,
    this.refundAmount = 0,
    this.transactionsCount = 0,
    this.totalGstCollected = 0,
    required this.paymentBreakdown,
    this.netRevenue = 0,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      totalOrders: json['totalOrders'] ?? 0,
      averageOrderValue: (json['averageOrderValue'] ?? 0).toDouble(),
      returnRate: (json['returnRate'] ?? 0).toDouble(),
      totalSales: (json['totalSales'] ?? 0).toDouble(),
      totalRevenue: (json['totalRevenue'] ?? 0).toDouble(),
      totalRefunds: (json['totalRefunds'] ?? 0).toDouble(),
      refundAmount: (json['refundAmount'] ?? 0).toDouble(),
      transactionsCount: json['transactionsCount'] ?? 0,
      totalGstCollected: (json['totalGstCollected'] ?? 0).toDouble(),
      paymentBreakdown: PaymentBreakdown.fromJson(
        json['paymentBreakdown'] ?? {},
      ),
      netRevenue: (json['netRevenue'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalOrders': totalOrders,
      'averageOrderValue': averageOrderValue,
      'returnRate': returnRate,
      'totalSales': totalSales,
      'totalRevenue': totalRevenue,
      'totalRefunds': totalRefunds,
      'refundAmount': refundAmount,
      'transactionsCount': transactionsCount,
      'totalGstCollected': totalGstCollected,
      'paymentBreakdown': paymentBreakdown.toJson(),
      'netRevenue': netRevenue,
    };
  }
}

class PaymentBreakdown {
  final double upi;
  final double cash;
  final double card;

  PaymentBreakdown({this.upi = 0, this.cash = 0, this.card = 0});

  factory PaymentBreakdown.fromJson(Map<String, dynamic> json) {
    return PaymentBreakdown(
      upi: (json['UPI'] ?? 0).toDouble(),
      cash: (json['CASH'] ?? 0).toDouble(),
      card: (json['CARD'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'UPI': upi, 'CASH': cash};
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

  factory TopSeller.fromJson(Map<String, dynamic> json) {
    return TopSeller(
      variantId: json['variantId'] ?? 0,
      sku: json['sku'] ?? '',
      size: json['size'] ?? '',
      color: json['color'] ?? '',
      productName: json['productName'] ?? '',
      totalQtySold: json['totalQtySold'] ?? 0,
      totalRevenue: (json['totalRevenue'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'variantId': variantId,
      'sku': sku,
      'size': size,
      'color': color,
      'productName': productName,
      'totalQtySold': totalQtySold,
      'totalRevenue': totalRevenue,
    };
  }
}

class DailySale {
  final String date;
  final double sales;
  final int orders;

  DailySale({required this.date, required this.sales, required this.orders});

  factory DailySale.fromJson(Map<String, dynamic> json) {
    return DailySale(
      date: json['date'] ?? '',
      sales: (json['sales'] ?? 0).toDouble(),
      orders: json['orders'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'date': date, 'sales': sales, 'orders': orders};
  }
}
