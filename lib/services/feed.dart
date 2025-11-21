import 'package:http/http.dart' as http;
import 'package:drift/drift.dart';
import 'package:rss_dart/domain/rss1_feed.dart';
import 'package:rss_reader/database/database.dart';
import 'package:rss_reader/database/companions.dart';
import 'package:rss_dart/dart_rss.dart';

/// Allows fetching feeds from the backend
class FeedService {
  final Database db;

  FeedService(this.db);

  /// Fetches and parses a remote feed including it's articles, returning
  /// a dataclass ready for insertion into the database.
  Future<FeedWithArticlesCompanion> fetchRemoteFeedInfo(Uri feedUrl) async {
    final xml = (await http.get(feedUrl)).body;

    return switch (WebFeed.detectRssVersion(xml)) {
      .rss1 => FeedWithArticlesCompanion.fromRss1(
        feedUrl.toString(),
        Rss1Feed.parse(xml),
      ),
      .rss2 => FeedWithArticlesCompanion.fromRss2(
        feedUrl.toString(),
        RssFeed.parse(xml),
      ),
      .atom => FeedWithArticlesCompanion.fromAtom(
        feedUrl.toString(),
        AtomFeed.parse(xml),
      ),
      .unknown => throw Exception('Unknown feed format'),
    };
  }

  /// Subscribe to a feed by it's URL.
  ///
  /// [title] and [description] allow to override title and description of the feed
  Future<Feed> subscribeToFeed(
    FeedWithArticlesCompanion companion, {
    String? title,
    String? description,
  }) async {
    companion = companion.copyWith(name: title, description: description);

    final feed = await db.into(db.feeds).insertReturning(companion.feed);

    final articles = companion.articles
        .map((article) => article.copyWith(feed: Value(feed.id)))
        .toList();

    await db.batch((batch) {
      batch.insertAll(db.articles, articles);
    });

    return feed;
  }
}
