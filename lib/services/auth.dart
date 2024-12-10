import 'package:flutter/material.dart';
import 'package:rss_reader/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

/// Auth tokens are created manually on the backend via a CLI,
/// so there's no "log in" process, technically.
/// We simply validate that the provided token works.
/// Logging out means just deleting the token from SharedPreferences,
/// and resetting the auth flow
class AuthService extends ChangeNotifier {
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();
  bool _isAuthenticated = false;
  Uri? _baseUrl;
  String? _token;

  AuthService();

  Future<void> initialize() async {
    _isAuthenticated = await _isLoggedIn();
    _baseUrl = await _getBaseUrl();
    _token = await _getToken();
  }

  bool get isAuthenticated => _isAuthenticated;
  Uri? get baseUrl => _baseUrl;
  String? get token => _token;

  Future<bool> _checkToken(Uri baseUrl, String token) async {
    final response = await http.get(
      baseUrl.replace(path: '/ping'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    return response.body == 'pong';
  }

  /// Checks the validity of the provided token and sets values in [SharedPreferences]
  Future<bool> login(Uri baseUrl, String token) async {
    final success = await _checkToken(baseUrl, token);
    if (success) {
      await _prefs.setString('baseUrl', baseUrl.toString());
      await _prefs.setBool('loggedIn', true);
      await _prefs.setString('token', token);

      // Inform the user that the login was successful
      scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
        content: Text.rich(TextSpan(children: [
          const TextSpan(text: 'Logged in successfully at '),
          TextSpan(
            style: const TextStyle(fontWeight: FontWeight.bold),
            text: this.baseUrl!.host,
          )
        ])),
      ));
    }

    notifyListeners();
    return success;
  }

  Future<void> logout() async {
    await _prefs.remove('loggedIn');
    await _prefs.remove('token');
    _isAuthenticated = false;
    notifyListeners();
  }

  // Checks the login state in SharedPreferences
  Future<bool> _isLoggedIn() async {
    if (await _prefs.getBool('loggedIn') != true) {
      return false;
    }

    final baseUrl = await _prefs.getString('baseUrl');
    final token = await _prefs.getString('token');
    if (baseUrl == null || token == null) return false;

    return await _checkToken(
      Uri.parse(baseUrl),
      token,
    );
  }

  // Fetches the base url from SharedPreferences
  Future<Uri?> _getBaseUrl() async {
    final uri = await _prefs.getString('baseUrl');
    if (uri != null) {
      return Uri.parse(uri);
    }
    return null;
  }

  // Fetches the token from SharedPreferences
  Future<String?> _getToken() async {
    return await _prefs.getString('token');
  }
}
