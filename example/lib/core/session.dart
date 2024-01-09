import 'dart:convert';

import 'package:http/http.dart' as http;

class Session {
  static Session? _instance;
  static Session get instance => _instance ??= Session._internal();

  static const String apiBaseUrl = "https://api.infobip.com";
  static const String apiKey = "<API_KEY>";

  String? _token;
  http.Client httpClient = http.Client();

  get token => _token;

  get isLoggedIn => token != null;

  Future<bool> performLoginForToken({
    required String identity,
    required String applicationId,
    required String displayName,
  }) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/webrtc/1/token'),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', 'Authorization': 'App $apiKey'},
      body: jsonEncode({
        "identity": identity,
        "applicationId": applicationId,
        "displayName": displayName,
      }),
    );

    if (response.statusCode != 200) {
      return false;
    }
    final json = jsonDecode(response.body);
    _token = json["token"];
    return true;
  }

  Session._internal();
}
