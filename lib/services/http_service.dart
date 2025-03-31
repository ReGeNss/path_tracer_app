import 'dart:convert';
import 'package:http/http.dart' as http;

import '../entities.dart/index.dart';

class HttpService {
  Future<List<Task>> getTasks(String url) async {
    final client = http.Client();
    try {
      final response = await client.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return Task.listFromJson(jsonDecode(response.body) as List<dynamic>);
      } else {
        throw Exception('Failed to load data');
      }
    } finally {
      client.close();
    }
  }
}