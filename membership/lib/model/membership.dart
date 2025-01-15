class Membership {
  String? membershipId;
  String? membershipName;
  String? membershipDescription;
  String? membershipPrice;
  String? membershipDuration;
  String? membershipBenefits;
  String? membershipTerms;
  String? membershipImage;

  Membership({
    this.membershipId,
    this.membershipName,
    this.membershipDescription,
    this.membershipPrice,
    this.membershipDuration,
    this.membershipBenefits,
    this.membershipTerms,
    this.membershipImage,
  });

  Membership.fromJson(Map<String, dynamic> json) {
    membershipId = json['membership_id'];
    membershipName = json['membership_name'];
    membershipDescription = json['membership_description'];
    membershipPrice = json['membership_price'];
    membershipDuration = json['membership_duration'];
    membershipBenefits = json['membership_benefits'];
    membershipTerms = json['membership_terms'];
    membershipImage = json['membership_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['membership_id'] = membershipId;
    data['membership_name'] = membershipName;
    data['membership_description'] = membershipDescription;
    data['membership_price'] = membershipPrice;
    data['membership_duration'] = membershipDuration;
    data['membership_benefits'] = membershipBenefits;
    data['membership_terms'] = membershipTerms;
    data['membership_image'] = membershipImage;
    return data;
  }
}
