import 'package:rss_reader/database/database.dart';

/// Abstracts away basic database operations with articles and feeds.
class FeedRepository {
  final Database db;

  const FeedRepository(this.db);

  Future<List<Feed>> all() async {
    return db.select(db.feeds).get();
  }

  /// Unsubscribes from a feed, also deleting all corresponding articles
  Future<void> unsubscribe(Feed feed) async {
    // Delete articles first
    await (db.delete(db.articles)..where((a) => a.feed.equals(feed.id))).go();

    // Then delete the feed
    await db.delete(db.feeds).delete(feed);
  }
}
