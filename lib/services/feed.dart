import 'package:rss_reader/models/article.dart';
import 'package:rss_reader/models/feed.dart';
import 'package:rss_reader/services/auth.dart';
import 'package:rss_reader/util/api.dart';

/// Allows fetching feeds from the backend
class FeedService {
  final ApiClient api;

  FeedService(AuthService auth) : api = ApiClient(auth.baseUrl!, auth.token!);

  List<Article> _toArticleList(dynamic response) {
    return (response as List<dynamic>)
        .map((article) => Article.fromJson(article))
        .toList();
  }

  Future<List<Article>> articlesInSubscription(
    int subscriptionId, {
    int? page,
  }) async {
    final response = await api.get(
      '/subscriptions/$subscriptionId/articles',
      query: {'page': page},
    );
    return _toArticleList(response);
  }

  Future<List<Article>> unreadArticles({int? page}) async {
    final response = await api.get('/unread', query: {'page': page});
    return _toArticleList(response);
  }

  /// Fetches the read later list
  Future<List<Article>> readLater({int? page}) async {
    final response = await api.get('/readlater', query: {'page': page});
    return _toArticleList(response);
  }

  /// Fetch metadata about the remote feed that has not yet been added to the database
  Future<Feed> fetchRemoteFeedInfo(String feedUrl) async {
    final response = await api.get('/feedinfo', query: {'url': feedUrl});
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
      body: {'url': url, 'title': title, 'description': description},
    );
    return Feed.fromJson(response);
  }
}
