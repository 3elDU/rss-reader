import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:rss_reader/models/article.dart';
import 'package:rss_reader/util/api.dart';

/// Provides a modifiable list of articles.
class ArticleListModel extends ChangeNotifier {
  final List<Article> _articles;

  UnmodifiableListView<Article> get items => UnmodifiableListView(_articles);

  ArticleListModel(
    /// Provide an initial list of articles
    this._articles,
  );

  /// Add or remove the article from the read later list.
  Future<void> toggleReadLater(ApiClient api, int id) async {
    await _articles
        .firstWhere((article) => article.id == id)
        .toggleReadLater(api);
    notifyListeners();
  }
}
