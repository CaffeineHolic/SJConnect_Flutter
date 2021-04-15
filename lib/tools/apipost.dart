import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> apiPost(String url, Map body, Map<String, String> header) async {
  http.Response response = await http.post(
    Uri.parse(url),
    headers: header,
    body: jsonEncode(body),
  );
  if (response.statusCode == 200) {
    return response.body;
  } else {
    return response.statusCode.toString();
  }
}