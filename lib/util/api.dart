import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Wrapper around [http] functions that will automatically pass the token
/// from [SharedPreferences]
class ApiClient {
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  Future<http.Response> get(String path) async {
    final baseUrl = await getBaseUrl();
    final token = (await _prefs.getString('token'))!;

    return http.get(
      baseUrl!.replace(path: path),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<http.Response> post(String path, Object? body) async {
    final baseUrl = await getBaseUrl();
    final token = (await _prefs.getString('token'))!;

    return http.post(
      baseUrl!.replace(path: path),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: body,
    );
  }

  Future<Uri?> getBaseUrl() async {
    final baseUrl = await _prefs.getString('baseUrl');
    if (baseUrl == null) return null;

    return Uri.parse(baseUrl);
  }
}
