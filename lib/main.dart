import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/pages/feed.dart';
import 'package:rss_reader/pages/login.dart';
import 'package:rss_reader/pages/read_later.dart';
import 'package:rss_reader/pages/subscriptions.dart';
import 'package:rss_reader/services/auth.dart';

void main() {
  runApp(const MyApp());
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // TODO: use system's primary color with 'dynamic_color' package
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AuthProvider()..initialize(),
          ),
        ],
        child: Consumer<AuthProvider>(
          builder: (_, auth, __) =>
              auth.isAuthenticated ? IndexPage() : const LoginPage(),
        ),
      ),
    );
  }
}

class IndexPage extends StatefulWidget {
  IndexPage({super.key});

  final List<NavigationDestination> destinations = <NavigationDestination>[
    const NavigationDestination(
      icon: Icon(Icons.inbox),
      label: "Feed",
    ),
    const NavigationDestination(
      icon: Icon(Icons.watch_later_outlined),
      selectedIcon: Icon(Icons.watch_later),
      label: "Read later",
    ),
    const NavigationDestination(
      icon: Icon(Icons.list),
      label: "Subscriptions",
    ),
  ];

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int _currentDestination = 0;

  void selectDestination(int destination) {
    setState(() {
      _currentDestination = destination;
    });
  }

  Widget pageForDestination() {
    switch (_currentDestination) {
      case 0:
        return const FeedPage();
      case 1:
        return const ReadLaterPage();
      case 2:
        return const SubscriptionsPage();
      default:
        return const FeedPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageForDestination(),
      bottomNavigationBar: NavigationBar(
        destinations: widget.destinations,
        selectedIndex: _currentDestination,
        onDestinationSelected: selectDestination,
      ),
    );
  }
}
