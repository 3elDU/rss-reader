import 'dart:convert';

import 'package:rss_reader/models/article.dart';
import 'package:rss_reader/services/auth.dart';
import 'package:rss_reader/util/api.dart';

/// Allows fetching feeds from the backend
class FeedService {
  final ApiClient api;

  FeedService(AuthService auth) : api = ApiClient(auth.baseUrl!, auth.token!);

  Future<List<Article>> unreadArticles() async {
    final response = await api.get('/unread');
    return (jsonDecode(response.body) as List<dynamic>)
        .map((article) => Article.fromJson(article))
        .toList();
  }
}
