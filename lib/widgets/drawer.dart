import 'package:flutter/material.dart';
import 'package:rss_reader/pages/settings.dart';
import 'package:rss_reader/pages/tags.dart';

class FoxDrawer extends StatelessWidget {
  const FoxDrawer({super.key});

  void _onDestinationSelected(BuildContext context, int idx) {
    switch (idx) {
      case 0:
        // tags page
        return TagsPage.open(context);
      case 1:
        // settings page
        return SettingsPage.open(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: null,
      onDestinationSelected: (index) => _onDestinationSelected(context, index),
      children: [
        // Padding(padding: .fromLTRB(28, 16, 16, 10), child: Text('Tags')),
        const NavigationDrawerDestination(
          icon: Icon(Icons.list),
          label: Text('Tags'),
        ),
        const Divider(),
        const NavigationDrawerDestination(
          icon: Icon(Icons.settings),
          label: Text('Settings'),
        ),
      ],
    );
  }
}
