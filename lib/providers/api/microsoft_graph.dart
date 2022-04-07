import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getUserInfo(String accessToken) async {
  // Make API call
  const String endpoint = 'https://graph.microsoft.com/v1.0/me';

  http.Response response = await http.get(
    Uri.parse(endpoint),
    headers: {'Authorization': 'Bearer $accessToken'},
  );

  if (response.statusCode != 200) {
    throw jsonDecode(response.body) as MicrosoftGraphException;
  }

  return jsonDecode(response.body);
}

class MicrosoftGraphException implements Exception {
  final String code;
  final String message;

  const MicrosoftGraphException({required this.code, required this.message});

  Map<String, dynamic> toJson() => {
        'code': code,
        'message': message,
      };

  factory MicrosoftGraphException.fromJson(Map<String, dynamic> json) =>
      MicrosoftGraphException(
        code: json['code'],
        message: json['message'],
      );
}
