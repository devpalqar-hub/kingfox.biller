class BillingSessions {
  int? billingSessionId;
  int? cartId;
  String? createdAt;
  String? updatedAt;
  int? itemCount;
  int? returnCredit;
  int? grandFinalTotal;

  BillingSessions({
    this.billingSessionId,
    this.cartId,
    this.createdAt,
    this.updatedAt,
    this.itemCount,
    this.returnCredit,
    this.grandFinalTotal,
  });

  BillingSessions.fromJson(Map<String, dynamic> json) {
    billingSessionId = json['billingSessionId'];
    cartId = json['cartId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    itemCount = json['itemCount'];
    returnCredit = json['returnCredit'];
    grandFinalTotal = json['grandFinalTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['billingSessionId'] = this.billingSessionId;
    data['cartId'] = this.cartId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['itemCount'] = this.itemCount;
    data['returnCredit'] = this.returnCredit;
    data['grandFinalTotal'] = this.grandFinalTotal;
    return data;
  }
}
