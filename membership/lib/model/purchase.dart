class PurchaseDetail {
  String? purchaseId;
  String? userId;
  String? paymentAmount;
  String? paymentStatus;
  String? purchaseDate;
  String? membershipName;

  PurchaseDetail(
      {this.purchaseId,
      this.userId,
      this.paymentAmount,
      this.paymentStatus,
      this.purchaseDate,
      this.membershipName});

  PurchaseDetail.fromJson(Map<String, dynamic> json) {
    purchaseId = json['purchase_id'];
    userId = json['user_id'];
    paymentAmount = json['payment_amount'];
    paymentStatus = json['payment_status'];
    purchaseDate = json['purchase_date'];
    membershipName = json['membership_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['purchase_id'] = this.purchaseId;
    data['user_id'] = this.userId;
    data['payment_amount'] = this.paymentAmount;
    data['payment_status'] = this.paymentStatus;
    data['purchase_date'] = this.purchaseDate;
    data['membership_name'] = this.membershipName;
    return data;
  }
}