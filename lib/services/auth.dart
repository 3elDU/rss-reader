import 'package:flutter/material.dart';
import 'package:rss_reader/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

/// Auth tokens are created manually on the backend via a CLI,
/// so there's no "log in" process, technically.
/// We simply validate that the provided token works.
/// Logging out means just deleting the token from SharedPreferences,
/// and resetting the auth flow
class AuthService {
  final SharedPreferencesAsync prefs = SharedPreferencesAsync();

  AuthService();

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
    if (await _checkToken(baseUrl, token)) {
      await prefs.setString('baseUrl', baseUrl.toString());
      await prefs.setBool('loggedIn', true);
      await prefs.setString('token', token);

      return true;
    }

    return false;
  }

  Future<void> logout() async {
    await prefs.remove('loggedIn');
    await prefs.remove('token');
  }

  Future<bool> isLoggedIn() async {
    if (await prefs.getBool('loggedIn') != true) {
      return false;
    }

    final baseUrl = await prefs.getString('baseUrl');
    final token = await prefs.getString('token');
    if (baseUrl == null || token == null) return false;

    return await _checkToken(
      Uri.parse(baseUrl),
      token,
    );
  }

  Future<Uri?> getBaseUrl() async {
    return Uri.parse((await prefs.getString('baseUrl'))!);
  }
}

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  AuthProvider();

  Future<void> initialize() async {
    _isAuthenticated = await _authService.isLoggedIn();
    notifyListeners();
  }

  Future<bool> login(Uri baseUrl, String token) async {
    final success = await _authService.login(baseUrl, token);

    if (success) {
      _isAuthenticated = true;
      notifyListeners();

      // Inform the user that the login was successful
      scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
        content: Text.rich(TextSpan(children: [
          const TextSpan(text: 'Logged in successfully at '),
          TextSpan(
            style: const TextStyle(fontWeight: FontWeight.bold),
            text: (await _authService.getBaseUrl())!.host,
          )
        ])),
      ));
    }

    return success;
  }

  Future<void> logout() async {
    await _authService.logout();
    _isAuthenticated = false;
    notifyListeners();
  }
}
