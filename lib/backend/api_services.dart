import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../models/user_model.dart';

class APIServices {
  static var client = http.Client();
  static String apiURL = "https://newprogress.net/wp-json/api/v1/token";
  static var logger = Logger();

  static Future<UserResponseModel> registerUser(
    UserModel model,
  ) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjEsIm5hbWUiOiJjZHNlYWhvbG0iLCJpYXQiOjE2ODg3Nzk1MjYsImV4cCI6MTg0NjQ1OTUyNn0.2sOn5fr8vN8UEcb0btIqVJB3fAIsF5bDp_l4VnYseh4',
      'id': 'your_id_value',
    };

    var response = await client.post(
      Uri.parse("https://newprogress.net/wp-json/wp/v2/users"),
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );

    logger.d('Response Body: ${response.body}');

    return userResponseFromJson(response.body);
  }
}
