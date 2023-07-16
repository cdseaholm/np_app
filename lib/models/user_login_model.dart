class UserLoginModel {
  late String userName;
  late String password;

  UserLoginModel({
    required this.userName,
    required this.password,
  });

  UserLoginModel.fromJson(Map<String, dynamic> json) {
    userName = json.containsKey('username') ? json['username'] : '';
    password = json.containsKey('password') ? json['password'] : '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = userName;
    data['password'] = password;

    return data;
  }
}
