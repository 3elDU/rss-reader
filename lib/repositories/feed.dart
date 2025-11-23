import 'dart:async';

import 'package:rss_reader/database/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Abstracts away basic database operations with articles and feeds.
class FeedRepository {
  final Database _db;
  final SharedPreferencesAsync _prefs;

  static final _updatedAtPrefsKey = 'updatedAt';

  const FeedRepository(this._db, this._prefs);

  Future<List<Feed>> all() async {
    return _db.select(_db.feeds).get();
  }

  /// Unsubscribes from a feed, also deleting all corresponding articles
  Future<void> unsubscribe(Feed feed) async {
    // Delete articles first
    await (_db.delete(_db.articles)..where((a) => a.feed.equals(feed.id))).go();

    // Then delete the feed
    await _db.delete(_db.feeds).delete(feed);
  }

  /// Sets the "updated at" date on a feed
  Future<Feed> markFeedUpdated(Feed feed) async {
    feed = feed.copyWith(updatedAt: DateTime.now());
    await _db.update(_db.feeds).replace(feed);
    return feed;
  }

  /// Records the new global "updated at" date.
  ///
  /// Updated date for a single feed should be set with [markFeedUpdated]
  Future<void> markGlobalUpdated() async {
    _prefs.setInt(_updatedAtPrefsKey, DateTime.now().millisecondsSinceEpoch);
  }

  /// Tries to read updated at date from shared preferences
  Future<DateTime?> _readUpdatedAt() async {
    if (await _prefs.containsKey(_updatedAtPrefsKey)) {
      return DateTime.fromMillisecondsSinceEpoch(
        (await _prefs.getInt(_updatedAtPrefsKey))!,
      );
    }

    return null;
  }

  /// Returns when the "updated at" date changes
  Future<void> waitForGlobalUpdated() async {
    DateTime initialUpdatedAt =
        await _readUpdatedAt() ?? DateTime.fromMillisecondsSinceEpoch(0);

    // Query the "updatedAt" key repeatedly until it has changed
    return Future(() async {
      while (true) {
        final newUpdatedAt = await _readUpdatedAt();

        if (newUpdatedAt != null && newUpdatedAt.isAfter(initialUpdatedAt)) {
          return;
        }

        // Sleep for a bit to not stress the system too much
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }).timeout(const Duration(minutes: 5));
  }
}
