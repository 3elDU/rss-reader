import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:rss_reader/database/dataclasses.dart';
import 'package:rss_reader/repositories/article.dart';

/// Provides a list of articles to child widgets, that can be filtered, ordered,
/// refreshed, and manipulated in other ways
class ArticleListModel extends ChangeNotifier {
  /// Acess to data source is needed to apply filters, refresh data and such
  final ArticleRepository repo;

  /// Internal array keeping all the articles
  List<ArticleWithFeed> _items = [];

  /// Whether the articles are still loading from database.
  bool loading = true;

  /// Filters used by the list
  ArticleQueryBuilder filters;

  UnmodifiableListView<ArticleWithFeed> get items =>
      UnmodifiableListView(_items);

  /// Construct a model from [ArticleQueryBuilder] instance.
  ///
  /// Articles will be fetched automatically
  ArticleListModel({required this.repo, required this.filters}) {
    refresh();
  }

  // Loads articles asynchronously in a non-blocking manner
  Future<void> refresh() async {
    _items = [];
    loading = true;
    notifyListeners();

    final articles = await filters.run(repo);

    _items = articles;
    loading = false;
    notifyListeners();
  }

  /// Applies filters from the given [ArticleQueryBuilder] instance.
  void applyFilters(ArticleQueryBuilder queryBuilder) {
    filters = queryBuilder.copy();
    refresh();
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
