import 'dart:convert';

import 'package:http/http.dart';

const scheme = "http";
const host = "codeserver.nithsua.live";
const port = 8081;

class TackServices {
  static Future<List<dynamic>> getMessages() async {
    Uri uri = Uri(
      scheme: scheme,
      host: host,
      port: port,
      path: "/api/home",
    );

    final Response response;
    try {
      response = await get(uri);
    } catch (_) {
      rethrow;
    }

    return jsonDecode(response.body);
  }
}
