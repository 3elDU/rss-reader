import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;
import 'package:rss_dart/dart_rss.dart';
import 'package:rss_dart/domain/rss1_feed.dart';
import 'package:rss_dart/util/helpers.dart';
import 'package:rss_reader/database/companions.dart';
import 'package:rss_reader/database/database.dart';

/// Facilities data extraction from remote feeds
class RemoteFeedService {
  const RemoteFeedService();

  FeedWithArticlesCompanion _fromRss1(Uri url, Rss1Feed feed) {
    final articles = feed.items
        .where((i) => i.link != null && i.title != null)
        .map(
          (item) => ArticlesCompanion.insert(
            // This will be populated before insertion, after the feed is created
            feed: 0,
            url: item.link!,
            title: item.title!,
            publishedAt: parseDateTime(item.dc?.date) ?? DateTime.now(),
          ),
        )
        .toList();

    return FeedWithArticlesCompanion(
      FeedsCompanion.insert(
        url: url.toString(),
        title: feed.title ?? 'RSS Feed',
        description: Value(feed.description),
      ),
      articles,
    );
  }

  FeedWithArticlesCompanion _fromRss(Uri url, RssFeed feed) {
    final articles = feed.items
        .where((i) => i.title != null && i.link != null)
        .map(
          (item) => ArticlesCompanion.insert(
            // This will be populated before insertion, after the feed is created
            feed: 0,
            url: item.link!,
            title: item.title!,
            thumbnailUrl: Value(item.content?.images.firstOrNull),
            publishedAt: parseDateTime(item.pubDate) ?? DateTime.now(),
          ),
        )
        .toList();

    return FeedWithArticlesCompanion(
      FeedsCompanion.insert(
        url: url.toString(),
        title: feed.title!,
        description: Value(feed.description),
      ),
      articles,
    );
  }

  FeedWithArticlesCompanion _fromAtom(Uri url, AtomFeed feed) {
    final articles = feed.items
        .where((i) => i.title != null && i.links.isNotEmpty)
        .map(
          (item) => ArticlesCompanion.insert(
            // This will be populated before insertion, after the feed is created
            feed: 0,
            url: item.links.first.href!,
            title: item.title!,
            thumbnailUrl: Value(item.media?.thumbnails.firstOrNull?.url),
            publishedAt: parseDateTime(item.published) ?? DateTime.now(),
          ),
        )
        .toList();

    return FeedWithArticlesCompanion(
      FeedsCompanion.insert(
        url: url.toString(),
        title: feed.title!,
        description: Value(feed.subtitle),
      ),
      articles,
    );
  }

  /// Fetches a remote feed by it's URL.
  Future<FeedWithArticlesCompanion> get(Uri remote) async {
    final xml = (await http.get(remote)).body;

    return switch (WebFeed.detectRssVersion(xml)) {
      .rss1 => _fromRss1(remote, Rss1Feed.parse(xml)),
      .rss2 => _fromRss(remote, RssFeed.parse(xml)),
      .atom => _fromAtom(remote, AtomFeed.parse(xml)),
      .unknown => throw Exception('Unknown feed format'),
    };
  }
}
