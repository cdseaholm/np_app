import 'dart:convert';

class UserModel {
  late String userName;
  late String emailId;
  late String password;
  late String confirmPassword;

  UserModel({
    required this.userName,
    required this.emailId,
    required this.password,
    required this.confirmPassword,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    userName = json.containsKey('username') ? json['username'] : '';
    emailId = json.containsKey('email') ? json['email'] : '';
    password = json.containsKey('password') ? json['password'] : '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = userName;
    data['email'] = emailId;
    data['password'] = password;

    return data;
  }
}

UserResponseModel userResponseFromJson(String str) =>
    UserResponseModel.fromJson(json.decode(str));

class UserResponseModel {
  late dynamic id;
  late dynamic code;
  String? message;
  bool existingUsername = false;
  bool existingEmail = false;

  UserResponseModel({required this.code, this.message});

  UserResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    message = json['message'];
    existingUsername = json['existing_username'] ?? false;
    existingEmail = json['existing_email'] ?? false;
    if (json.containsKey('additional_errors')) {
      for (var error in json['additional_errors']) {
        if (error.containsKey('code')) {
          if (error['code'] == 'user_name') {
            existingUsername = true;
          } else if (error['code'] == 'user_email') {
            existingEmail = true;
          }
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['message'] = message;
    data['existing_username'] = existingUsername;
    data['existing_email'] = existingEmail;

    return data;
  }
}
