import 'package:http/http.dart' as http;

/// Wrapper around [http] functions that will automatically pass the token
/// and call the website at it's base url
class ApiClient {
  final String token;
  final Uri baseUrl;

  const ApiClient(this.baseUrl, this.token);

  Future<http.Response> get(String path) async {
    return http.get(
      baseUrl.replace(path: path),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<http.Response> post(String path, Object? body) async {
    return http.post(
      baseUrl.replace(path: path),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: body,
    );
  }
}
