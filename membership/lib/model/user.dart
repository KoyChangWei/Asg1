class User {
  String? memberId;
  String? email;
  String? phoneNo;
  String? username;
  String? timeLog;

  User({this.memberId, this.email, this.phoneNo, this.username, this.timeLog});

  User.fromJson(Map<String, dynamic> json) {
    memberId = json['member_id'];
    email = json['email'];
    phoneNo = json['phoneNo'];
    username = json['username'];
    timeLog = json['timeLog'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['member_id'] = this.memberId;
    data['email'] = this.email;
    data['phoneNo'] = this.phoneNo;
    data['username'] = this.username;
    data['timeLog'] = this.timeLog;
    return data;
  }
}