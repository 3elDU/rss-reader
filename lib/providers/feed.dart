import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:rss_reader/database/database.dart';
import 'package:rss_reader/repositories/feed.dart';

/// Allows child widgets to access the list of feeds in the database
/// *synchronously*
///
/// Uses the "stale-while-revalidate" caching strategy, where the widgets
/// are presented with outdated data while the list is being updated
/// in background.
class FeedListModel extends ChangeNotifier {
  final FeedRepository repo;

  List<Feed> _feeds = [];
  DateTime? _lastUpdated;

  FeedListModel(this.repo) {
    // Revalidate right away and subscribe to future updates

    _revalidate();
    _watch();
  }

  void _revalidate() async {
    repo.all().then((feeds) {
      _feeds = feeds;
      notifyListeners();
    });

    repo.updatedAt().then((lastUpdated) {
      _lastUpdated = lastUpdated;
      notifyListeners();
    });
  }

  void _watch() async {
    await for (final feeds in repo.streamUpdates()) {
      _feeds = feeds;
      _lastUpdated = await repo.updatedAt();
      notifyListeners();
    }
  }

  UnmodifiableListView<Feed> get feeds => UnmodifiableListView(_feeds);

  DateTime? get lastUpdated => _lastUpdated;
}
