import 'dart:convert';

import 'package:http/http.dart' as http;

/// [ApiException] represents an error on the server side
class ApiException implements Exception {
  /// Error message returned from the server.
  final String message;

  const ApiException(this.message);

  @override
  String toString() {
    return message;
  }
}

/// Wrapper around [http] functions that will automatically pass the token
/// and call the website at it's base url
class ApiClient {
  final String token;
  final Uri baseUrl;

  const ApiClient(this.baseUrl, this.token);

  Future<dynamic> _makeRequest(
    String method,
    String path, {
    Map<String, dynamic>? query,
    String? body,
  }) async {
    final request = http.Request(
      method,
      baseUrl.replace(path: path, queryParameters: query),
    );
    request.headers['Authorization'] = 'Bearer $token';
    if (body != null) {
      request.body = body;
    }
    final response = await http.Response.fromStream(
      await request.send(),
    );

    // Check for internal server errors
    try {
      final json = jsonDecode(response.body);
      if (json is Map<String, dynamic> && json['error'] == true) {
        throw ApiException(json['message'] as String);
      }
    } catch (e) {
      rethrow;
    }

    // At this point we can safely assume that the response is JSON
    return jsonDecode(response.body);
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) async {
    return await _makeRequest('GET', path, query: query);
  }

  Future<dynamic> post(String path, {Object? body}) async {
    return await _makeRequest('POST', path, body: jsonEncode(body));
  }

  Future<dynamic> delete(String path) async {
    return await _makeRequest('DELETE', path);
  }
}
