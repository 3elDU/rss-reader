import 'package:rss_reader/models/article.dart';
import 'package:rss_reader/models/feed.dart';

/// Allows fetching feeds from the backend
class FeedService {
  FeedService();

  final demoSubscription = Feed(id: 1, title: "Demo Subscription");

  late final demoArticles = <Article>[
    Article(
      id: 1,
      subscriptionId: 1,
      title: "First Article",
      description: "This is an article about cats. Miau meow. I like cats.",
      url: Uri.https('example.org', '/article1'),
      unread: false,
      created: DateTime(2025, 11, 21, 12),
      readLater: false,
      subscription: demoSubscription,
    ),
    Article(
      id: 1,
      subscriptionId: 1,
      title: "Second Article",
      description: "Lorem ipsum dolor sit amet asdasdasdasdasd.",
      url: Uri.https('example.org', '/article2'),
      unread: true,
      created: DateTime(2025, 11, 21, 12),
      readLater: true,
      subscription: demoSubscription,
    ),
    Article(
      id: 1,
      subscriptionId: 1,
      title: "Qwerty",
      description: "Test",
      url: Uri.https('example.org', '/article3'),
      unread: true,
      created: DateTime(2025, 11, 21, 12),
      readLater: false,
      subscription: demoSubscription,
    ),
  ];

  Future<List<Article>> articlesInSubscription(int subscriptionId) async {
    return demoArticles;
  }

  Future<List<Article>> unreadArticles() async {
    return demoArticles.where((a) => a.unread).toList();
  }

  /// Fetches the read later list
  Future<List<Article>> readLater() async {
    return demoArticles.where((a) => a.readLater).toList();
  }

  /// Fetch metadata about the remote feed that has not yet been added to the database
  Future<Feed> fetchRemoteFeedInfo(String feedUrl) async {
    return Feed(id: 0, title: "Unimplemented", description: 'Unimplemented');
  }

  /// Subscribe to a feed by it's URL.
  ///
  /// [title] and [description] allow to override title and description of the feed
  Future<Feed> subscribeToFeed(
    String url, {
    String? title,
    String? description,
  }) async {
    return Feed(
      id: 0,
      title: title ?? 'Unimplemented',
      description: 'Unimplemented',
    );
  }
}
