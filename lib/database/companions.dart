import 'package:drift/drift.dart';
import 'package:rss_dart/dart_rss.dart';
import 'package:rss_dart/domain/rss1_feed.dart';
import 'package:rss_dart/util/helpers.dart';
import 'package:rss_reader/database/database.dart';

/// A feed containing multiple articles before it is inserted into the database
class FeedWithArticlesCompanion {
  const FeedWithArticlesCompanion(this.feed, this.articles);

  factory FeedWithArticlesCompanion.fromRss1(String url, Rss1Feed feed) {
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
        url: url,
        title: feed.title ?? 'RSS Feed',
        description: Value(feed.description),
      ),
      articles,
    );
  }

  factory FeedWithArticlesCompanion.fromRss2(String url, RssFeed feed) {
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
        url: url,
        title: feed.title!,
        description: Value(feed.description),
      ),
      articles,
    );
  }

  factory FeedWithArticlesCompanion.fromAtom(String url, AtomFeed feed) {
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
      FeedsCompanion.insert(url: url, title: feed.title!),
      articles,
    );
  }

  FeedWithArticlesCompanion copyWith({String? name, String? description}) {
    return FeedWithArticlesCompanion(
      feed.copyWith(
        title: Value(name ?? feed.title.value),
        description: Value(description ?? feed.description.value),
      ),
      articles,
    );
  }

  final List<ArticlesCompanion> articles;
  final FeedsCompanion feed;
}
