import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/services/auth.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Feeds page'),
          TextButton(
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
            child: const Text('log out'),
          )
        ],
      ),
    );
  }
}
