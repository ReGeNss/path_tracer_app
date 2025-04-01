import 'dart:convert';
import 'package:http/http.dart' as http;
import '../entities.dart/index.dart';

const _successCode = 200;

class HttpService {
  Future<List<Task>> getTasks(String url) async {
    return getResponse<Task>(url, Task.fromJson);
  }

  Future<List<TaskStatus>> sendResults(String url, List<ProcessedTaskPath> results) async {
    return await sendResponse<ProcessedTaskPath, TaskStatus>(url, results, TaskStatus.fromJson);
  }

  Future<List<K>> sendResponse<T extends Sendable, K>(
    String url,
    List<T> dataToSend, 
    K Function(Map<String, dynamic>) responseDataFromJson
  ) async {
    final client = http.Client();
    try {
        final response = await client.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json','Accept': 'application/json'},
          body: jsonEncode(dataToSend.map((item) => item.toJson()).toList()),
        );
        return validateResponse<K>(response, responseDataFromJson);
    } finally {
      client.close();
    }
  }

  Future<List<T>> getResponse<T>(String url, T Function(Map<String, dynamic>) dataFromJson) async {
    final client = http.Client();
    try {
      final response = await client.get(Uri.parse(url),);
      return validateResponse(response, dataFromJson);
    } finally {
      client.close();
    }
  }

  List<T> validateResponse<T>(http.Response response, T Function(Map<String, dynamic>) dataFromJson) {
    if (response.statusCode == _successCode) {
      final decodedResponse = ApiResponse.fromJson(
        jsonDecode(response.body), 
        (json) => dataFromJson(json as Map<String, dynamic>)
      );
      if(decodedResponse.error == true) throw Exception('Error: ${decodedResponse.message}');
      return decodedResponse.data;
    } else {
      final decodedResponse = ApiFailureResponse.fromJson(jsonDecode(response.body));
      throw Exception('Failed to send data to server.\nStatus code: ${response.statusCode}}\nError: ${decodedResponse.message}');
    }
  }
}