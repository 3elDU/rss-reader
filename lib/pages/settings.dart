import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static void open(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => SettingsPage()));
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder(child: Text('SETTINGS'));
  }
}
