class Subscription {
  int? membershipId;
  String? membershipName;
  String? membershipDescription;
  String? membershipPrice;
  String? membershipDuration;
  String? membershipBenefits;
  String? membershipTerms;
  String? membershipImage;
  String? startDate;
  String? endDate;

  Subscription(
      {this.membershipId,
      this.membershipName,
      this.membershipDescription,
      this.membershipPrice,
      this.membershipDuration,
      this.membershipBenefits,
      this.membershipTerms,
      this.membershipImage,
      this.startDate,
      this.endDate});

  Subscription.fromJson(Map<String, dynamic> json) {
    membershipId = json['membership_id'];
    membershipName = json['membership_name'];
    membershipDescription = json['membership_description'];
    membershipPrice = json['membership_price'];
    membershipDuration = json['membership_duration'];
    membershipBenefits = json['membership_benefits'];
    membershipTerms = json['membership_terms'];
    membershipImage = json['membership_image'];
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['membership_id'] = this.membershipId;
    data['membership_name'] = this.membershipName;
    data['membership_description'] = this.membershipDescription;
    data['membership_price'] = this.membershipPrice;
    data['membership_duration'] = this.membershipDuration;
    data['membership_benefits'] = this.membershipBenefits;
    data['membership_terms'] = this.membershipTerms;
    data['membership_image'] = this.membershipImage;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    return data;
  }
}