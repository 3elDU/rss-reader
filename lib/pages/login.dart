import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/services/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _tokenController = TextEditingController();
  // Whether to use HTTPS with the API
  bool _https = true;

  bool _loginButtonDisabled = true;
  Future<bool>? _loginFuture;

  // Toggles the login button based on text in text fields
  void _toggleLoginButton(String _) {
    final disabled = _urlController.text == '' || _tokenController.text == '';
    setState(() {
      _loginButtonDisabled = disabled;
    });
  }

  // Constructs the base URL from the text in TextField
  Uri _baseUrl() {
    if (_https) {
      return Uri.https(_urlController.text);
    } else {
      return Uri.http(_urlController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value:
            Theme.of(context).brightness == Brightness.light
                ? SystemUiOverlayStyle.dark
                : SystemUiOverlayStyle.light,
        child: SafeArea(
          child: FutureBuilder(
            future: _loginFuture,
            builder: (context, snapshot) {
              String? urlError;
              if (snapshot.hasError) {
                urlError =
                    'Connection error: ${snapshot.error.runtimeType.toString()}';
              } else if (_urlController.text.startsWith('http:') ||
                  _urlController.text.startsWith('https:')) {
                urlError = 'Do not prefix the base URL with http or https';
              }

              final tokenError =
                  snapshot.data == false ? 'Invalid token' : null;

              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Log in',
                        style: Theme.of(context).textTheme.displayLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      Tooltip(
                        message:
                            'The base URL for the api. Provide only the host, without http://, https:// or slashes, e.g. myapi.example.com',
                        child: TextField(
                          controller: _urlController,
                          keyboardType: TextInputType.url,
                          decoration: InputDecoration(
                            labelText: 'Instance base URL',
                            hintStyle: const TextStyle(
                              fontWeight: FontWeight.w400,
                            ),
                            border: const OutlineInputBorder(),
                            errorText: urlError,
                          ),
                          onChanged: _toggleLoginButton,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _tokenController,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          labelText: 'Token',
                          border: const OutlineInputBorder(),
                          errorText: tokenError,
                        ),
                        onChanged: _toggleLoginButton,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Switch(
                            value: _https,
                            onChanged: (value) {
                              setState(() {
                                _https = value;
                              });
                            },
                          ),
                          const SizedBox(width: 16),
                          const Text('Use HTTPS'),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Consumer<AuthService>(
                          builder:
                              (context, auth, _) => LoginButton(
                                disabled: _loginButtonDisabled,
                                onPressed: () {
                                  setState(() {
                                    _loginFuture = auth.login(
                                      _baseUrl(),
                                      _tokenController.text,
                                    );
                                  });
                                },
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({
    required this.disabled,
    required this.onPressed,
    super.key,
  });

  final bool disabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: disabled ? null : onPressed,
      child: const Text('Log in'),
    );
  }
}
