class Payment {
  String? membershipStatusId;
  String? userId;
  String? membershipName;
  String? startDate;
  String? endDate;
  String? status;

  Payment(
      {this.membershipStatusId,
      this.userId,
      this.membershipName,
      this.startDate,
      this.endDate,
      this.status});

  Payment.fromJson(Map<String, dynamic> json) {
    membershipStatusId = json['membership_status_id'];
    userId = json['user_id'];
    membershipName = json['membership_name'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['membership_status_id'] = this.membershipStatusId;
    data['user_id'] = this.userId;
    data['membership_name'] = this.membershipName;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['status'] = this.status;
    return data;
  }
}