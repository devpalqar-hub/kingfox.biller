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
        summary: Summary.fromJson(json['summary']),
        topSellers: (json['topSellers'] as List)
            .map((e) => TopSeller.fromJson(e))
            .toList(),
        dailySales: (json['dailySales'] as List)
            .map((e) => DailySale.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'summary': summary.toJson(),
        'topSellers': topSellers.map((e) => e.toJson()).toList(),
        'dailySales': dailySales.map((e) => e.toJson()).toList(),
      };
}

class Summary {
  final int totalInvoices;
  final double totalRevenue;
  final double totalDiscount;
  final double totalRefunds;
  final double netRevenue;
  final int totalItemsSold;
  final int totalReturns;

  Summary({
    required this.totalInvoices,
    required this.totalRevenue,
    required this.totalDiscount,
    required this.totalRefunds,
    required this.netRevenue,
    required this.totalItemsSold,
    required this.totalReturns,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        totalInvoices: json['totalInvoices'] ?? 0,
        totalRevenue: (json['totalRevenue'] ?? 0).toDouble(),
        totalDiscount: (json['totalDiscount'] ?? 0).toDouble(),
        totalRefunds: (json['totalRefunds'] ?? 0).toDouble(),
        netRevenue: (json['netRevenue'] ?? 0).toDouble(),
        totalItemsSold: json['totalItemsSold'] ?? 0,
        totalReturns: json['totalReturns'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'totalInvoices': totalInvoices,
        'totalRevenue': totalRevenue,
        'totalDiscount': totalDiscount,
        'totalRefunds': totalRefunds,
        'netRevenue': netRevenue,
        'totalItemsSold': totalItemsSold,
        'totalReturns': totalReturns,
      };
}

class TopSeller {
  final int id;
  final String name;
  final double revenue;

  TopSeller({
    required this.id,
    required this.name,
    required this.revenue,
  });

  factory TopSeller.fromJson(Map<String, dynamic> json) => TopSeller(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        revenue: (json['revenue'] ?? 0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'revenue': revenue,
      };
}

class DailySale {
  final String date;
  final int invoices;
  final double revenue;

  DailySale({
    required this.date,
    required this.invoices,
    required this.revenue,
  });

  factory DailySale.fromJson(Map<String, dynamic> json) => DailySale(
        date: json['date'] ?? '',
        invoices: json['invoices'] ?? 0,
        revenue: (json['revenue'] ?? 0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'date': date,
        'invoices': invoices,
        'revenue': revenue,
      };
}