import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:rss_reader/database/dataclasses.dart';
import 'package:rss_reader/repositories/feed.dart';

/// Provides a modifiable list of articles.
class ArticleListModel extends ChangeNotifier {
  final FeedRepository repo;
  final List<ArticleWithFeed> _items;

  UnmodifiableListView<ArticleWithFeed> get items =>
      UnmodifiableListView(_items);

  ArticleListModel({
    /// Provide an initial list of articles
    required List<ArticleWithFeed> articles,

    /// Repository for changing article state
    required this.repo,
  }) : _items = articles;

  ArticleWithFeed getArticleById(int id) {
    return _items.firstWhere((m) => m.article.id == id);
  }

  /// Replace the list of articles with a new one.
  void setArticles(List<ArticleWithFeed> articles) {
    _items.clear();
    _items.addAll(articles);
    notifyListeners();
  }

  /// Puts article at the given index into the read later list
  Future<void> snooze(ArticleWithFeed item) async {
    final idx = _items.indexWhere((i) => i.article.id == item.article.id);

    _items[idx] = _items[idx].copyWith(
      article: await repo.snooze(_items[idx].article),
    );
    notifyListeners();
  }

  /// Marks article at the given index as read
  Future<void> markAsRead(ArticleWithFeed item) async {
    final idx = _items.indexWhere((i) => i.article.id == item.article.id);

    _items[idx] = _items[idx].copyWith(
      article: await repo.markRead(_items[idx].article),
    );
    notifyListeners();
  }
}
