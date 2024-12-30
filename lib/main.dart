import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/models/feed.dart';
import 'package:rss_reader/pages/add_feed.dart';
import 'package:rss_reader/pages/feed.dart';
import 'package:rss_reader/pages/login.dart';
import 'package:rss_reader/pages/read_later.dart';
import 'package:rss_reader/pages/subscriptions.dart';
import 'package:rss_reader/services/auth.dart';
import 'package:rss_reader/services/feed.dart';
import 'package:rss_reader/widgets/error.dart';

// Try to initialize the authentication service, and return the error object,
// if there is an error
Future<Object?> safeInitAuth(AuthService auth) async {
  try {
    await auth.initialize();
  } catch (error) {
    return error;
  }

  return null;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize authentication service early
  final auth = AuthService();
  final authError = await safeInitAuth(auth);

  runApp(MyApp(
    auth,
    authError: authError,
  ));
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey();

class MyApp extends StatefulWidget {
  // Auth service is initialized earlier
  final AuthService _auth;
  final Object? authError;

  const MyApp(this._auth, {this.authError, super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Object? _authError;

  @override
  void initState() {
    super.initState();
    _authError = widget.authError;
  }

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
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          brightness: Brightness.dark,
        ),
      ),
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: _authError != null
          ? Scaffold(
              body: CustomizableErrorScreen(
                heading: 'API Error',
                description:
                    'There was an error communicating with the server. Most likely there is a problem with your internet connection, or the API is unreachable.',
                error: _authError!,
                onPressRetry: () async {
                  final error = await safeInitAuth(widget._auth);
                  setState(() {
                    _authError = error;
                  });
                },
                secondaryAction: FilledButton.tonal(
                  child: const Text('Log out'),
                  onPressed: () async {
                    await widget._auth.logout();
                    setState(() {
                      _authError = null;
                    });
                  },
                ),
              ),
            )
          : MultiProvider(
              providers: [
                ChangeNotifierProvider.value(
                  value: widget._auth,
                ),
                ProxyProvider<AuthService, FeedService>(
                  update: (_, auth, __) => FeedService(auth),
                ),
              ],
              child: Consumer<AuthService>(
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
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add a new feed',
        child: const Icon(Icons.add),
        onPressed: () async {
          final feedService = context.read<FeedService>();
          final feed = await Navigator.push<Feed?>(
            context,
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (_) => AddNewFeedDialog(feedService),
            ),
          );

          if (context.mounted && feed is Feed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: 'Subscribed to '),
                      TextSpan(
                        text: feed.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: '!'),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
      body: pageForDestination(),
      bottomNavigationBar: NavigationBar(
        destinations: widget.destinations,
        selectedIndex: _currentDestination,
        onDestinationSelected: selectDestination,
      ),
    );
  }
}
