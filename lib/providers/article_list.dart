import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:rss_reader/models/article.dart';
import 'package:rss_reader/util/api.dart';

/// Provides a modifiable list of articles.
class ArticleListModel extends ChangeNotifier {
  final List<Article> _articles;
  final ApiClient api;

  UnmodifiableListView<Article> get items => UnmodifiableListView(_articles);

  ArticleListModel({
    /// Provide an initial list of articles
    required List<Article> articles,
    required this.api,
  }) : _articles = articles;

  Article getArticleById(int id) {
    return _articles.firstWhere((article) => article.id == id);
  }

  /// Replace the list of articles with a new one.
  void setArticles(List<Article> articles) {
    _articles.clear();
    _articles.addAll(articles);
    notifyListeners();
  }

  /// Add or remove the article from the read later list.
  Future<void> toggleReadLater(int id) async {
    await getArticleById(id).toggleReadLater(api);
    notifyListeners();
  }

  Future<void> markAsRead(int id) async {
    await getArticleById(id).markAsRead(api);
    notifyListeners();
  }
}
