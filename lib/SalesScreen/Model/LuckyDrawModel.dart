// lib/models/lucky_draw_model.dart
class BranchModel {
  final int id;
  final String name;
  final String phone;
  final String address;
  final String type;

  BranchModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.type,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      type: json['type'],
    );
  }
}

class LuckyDrawCampaign {
  final int id;
  final String name;
  final String description;
  final String image;
  final int totalVouchersLimit;
  final int vouchersIssued;
  final String startDate;
  final String endDate;
  final String status;
  final int pendingVouchers;
  final List<BranchModel> branches;

  LuckyDrawCampaign({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.totalVouchersLimit,
    required this.vouchersIssued,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.pendingVouchers,
    required this.branches,
  });

  factory LuckyDrawCampaign.fromJson(Map<String, dynamic> json) {
    var branchesJson = json['branches'] as List<dynamic>;
    List<BranchModel> branchesList = branchesJson
        .map((e) => BranchModel.fromJson(e))
        .toList();

    return LuckyDrawCampaign(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      totalVouchersLimit: json['totalVouchersLimit'],
      vouchersIssued: json['vouchersIssued'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      status: json['status'],
      pendingVouchers: json['pendingVouchers'],
      branches: branchesList,
    );
  }
}
