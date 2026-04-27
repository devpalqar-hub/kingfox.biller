class BranchModel {
  int? id;
  String? name;
  String? phone;
  String? gstin;
  String? address;
  String? type;
  bool? supportsPickup;
  String? createdAt;

  BranchModel({
    this.id,
    this.name,
    this.phone,
    this.gstin,
    this.address,
    this.type,
    this.supportsPickup,
    this.createdAt,
  });

  BranchModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "Kingfox";
    phone = json['phone'] ?? "+918129882245";
    gstin = json['gstin'];
    address =
        json['address'] ??
        "KING FOX CLOTHING, MNS AVENUE, NEAR 4TH GATE, CALICUT 673001";
    type = json['type'] ?? "SHOP";
    supportsPickup = json['supportsPickup'] ?? false;
    createdAt = json['createdAt'] ?? DateTime.now().toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['gstin'] = this.gstin;
    data['address'] = this.address;
    data['type'] = this.type;
    data['supportsPickup'] = this.supportsPickup;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
