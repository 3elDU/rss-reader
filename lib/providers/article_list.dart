import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:rss_reader/database/database.dart';

/// Provides a modifiable list of articles.
class ArticleListModel extends ChangeNotifier {
  final List<ArticleWithFeed> _articles;

  UnmodifiableListView<ArticleWithFeed> get items =>
      UnmodifiableListView(_articles);

  ArticleListModel({
    /// Provide an initial list of articles
    required List<ArticleWithFeed> articles,
  }) : _articles = articles;

  ArticleWithFeed getArticleById(int id) {
    return _articles.firstWhere((m) => m.article.id == id);
  }

  /// Replace the list of articles with a new one.
  void setArticles(List<ArticleWithFeed> articles) {
    _articles.clear();
    _articles.addAll(articles);
    notifyListeners();
  }

  /// Add or remove the article from the read later list.
  Future<void> toggleReadLater(int id) async {
    notifyListeners();
  }

  Future<void> markAsRead(int id) async {
    notifyListeners();
  }
}
