import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/providers/feed.dart';
import 'package:rss_reader/repositories/tag.dart';
import 'package:rss_reader/services/article.dart';
import 'package:rss_reader/services/refresh.dart';
import 'package:rss_reader/services/remote_feed.dart';
import 'package:rss_reader/task.dart';
import 'package:rss_reader/database/database.dart';
import 'package:rss_reader/pages/add_feed.dart';
import 'package:rss_reader/pages/feed.dart';
import 'package:rss_reader/pages/read_later.dart';
import 'package:rss_reader/pages/subscriptions.dart';
import 'package:rss_reader/repositories/article.dart';
import 'package:rss_reader/repositories/feed.dart';
import 'package:rss_reader/services/feed.dart';
import 'package:rss_reader/widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher);

  final db = Database();
  final prefs = SharedPreferencesAsync();

  await RefreshService(db, prefs).registerPeriodicTask();

  runApp(MyApp(db, prefs));
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey();

class MyApp extends StatefulWidget {
  final Database db;
  final SharedPreferencesAsync prefs;

  const MyApp(this.db, this.prefs, {super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FeedRepository>(
          create: (_) => FeedRepository(widget.db, widget.prefs),
        ),
        Provider<ArticleRepository>(
          create: (_) => ArticleRepository(widget.db),
        ),
        Provider<TagRepository>(create: (_) => TagRepository(widget.db)),
        Provider<RemoteFeedService>(create: (_) => RemoteFeedService()),
        Provider<RefreshService>(
          create: (_) => RefreshService(widget.db, widget.prefs),
        ),
        Provider<FeedService>(create: (_) => FeedService(widget.db)),
        Provider<ArticleService>(create: (_) => ArticleService(widget.db)),
        ChangeNotifierProvider<FeedListModel>(
          create: (_) => FeedListModel(FeedRepository(widget.db, widget.prefs)),
        ),
      ],
      child: MaterialApp(
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
        home: const IndexPage(),
      ),
    );
  }
}

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  final List<NavigationDestination> destinations =
      const <NavigationDestination>[
        NavigationDestination(icon: Icon(Icons.inbox), label: "Feed"),
        NavigationDestination(
          icon: Icon(Icons.watch_later_outlined),
          selectedIcon: Icon(Icons.watch_later),
          label: "Read later",
        ),
        NavigationDestination(icon: Icon(Icons.list), label: "Subscriptions"),
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
        return FeedPage();
      case 1:
        return ReadLaterPage();
      case 2:
        return const SubscriptionsPage();
      default:
        return FeedPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: Theme.of(context).brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      child: Scaffold(
        drawer: const FoxDrawer(),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add a new feed',
          child: const Icon(Icons.add),
          onPressed: () async {
            final feed = await Navigator.push<Feed?>(
              context,
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (_) => AddNewFeedDialog(),
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
      ),
    );
  }
}
