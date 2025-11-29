import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;
import 'package:rss_dart/dart_rss.dart';
import 'package:rss_dart/domain/rss1_feed.dart';
import 'package:rss_reader/database/companions.dart';
import 'package:rss_reader/database/database.dart';

const _months = {
  'Jan': '01',
  'Feb': '02',
  'Mar': '03',
  'Apr': '04',
  'May': '05',
  'Jun': '06',
  'Jul': '07',
  'Aug': '08',
  'Sep': '09',
  'Oct': '10',
  'Nov': '11',
  'Dec': '12',
};

/// Try to parse a datetime string in RFC822 format:
/// Sat, 05 Jul 2025 00:00:00 +0000
///
/// Parsing code taken from https://stackoverflow.com/a/70748039
DateTime? _tryParseRfc822(String input) {
  input = input.replaceFirst('GMT', '+0000');

  final splits = input.split(' ');

  final splitYear = splits[3];

  final splitMonth = _months[splits[2]];
  if (splitMonth == null) return null;

  var splitDay = splits[1];
  if (splitDay.length == 1) {
    splitDay = '0$splitDay';
  }

  final splitTime = splits[4], splitZone = splits[5];

  var reformatted = '$splitYear-$splitMonth-$splitDay $splitTime $splitZone';

  return DateTime.tryParse(reformatted);
}

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
            description: Value(item.description),
            publishedAt: _tryParseRfc822(item.dc!.date!) ?? DateTime.now(),
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
            description: Value(item.description),
            thumbnailUrl: Value(item.content?.images.firstOrNull),
            publishedAt: _tryParseRfc822(item.pubDate!) ?? DateTime.now(),
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
            description: Value(item.summary),
            thumbnailUrl: Value(item.media?.thumbnails.firstOrNull?.url),
            publishedAt: _tryParseRfc822(item.published!) ?? DateTime.now(),
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
    final response = (await http.get(remote)).bodyBytes;
    final xml = utf8.decode(response);

    return switch (WebFeed.detectRssVersion(xml)) {
      .rss1 => _fromRss1(remote, Rss1Feed.parse(xml)),
      .rss2 => _fromRss(remote, RssFeed.parse(xml)),
      .atom => _fromAtom(remote, AtomFeed.parse(xml)),
      .unknown => throw Exception('Unknown feed format'),
    };
  }
}
