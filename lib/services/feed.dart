import 'package:rss_reader/models/article.dart';
import 'package:rss_reader/models/feed.dart';
import 'package:rss_reader/services/auth.dart';
import 'package:rss_reader/util/api.dart';

/// Allows fetching feeds from the backend
class FeedService {
  final ApiClient api;

  FeedService(AuthService auth) : api = ApiClient(auth.baseUrl!, auth.token!);

  Future<List<Article>> unreadArticles() async {
    final response = await api.get('/unread');
    return (response as List<dynamic>)
        .map((article) => Article.fromJson(article))
        .toList();
  }

  /// Fetches the read later list
  Future<List<Article>> readLater() async {
    final response = await api.get('/readlater');
    return (response as List<dynamic>)
        .map((article) => Article.fromJson(article))
        .toList();
  }

  /// Fetch metadata about the remote feed that has not yet been added to the database
  Future<Feed> fetchRemoteFeedInfo(String feedUrl) async {
    final response = await api.get(
      '/feedinfo',
      query: {
        'url': feedUrl,
      },
    );
    return Feed.fromJson(response);
  }

  /// Subscribe to a feed by it's URL.
  ///
  /// [title] and [description] allow to override title and description of the feed
  Future<Feed> subscribeToFeed(
    String url, {
    String? title,
    String? description,
  }) async {
    final response = await api.post(
      '/subscribe',
      body: {
        'url': url,
        'title': title,
        'description': description,
      },
    );
    return Feed.fromJson(response);
  }
}
