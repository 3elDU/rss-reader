import 'package:rss_reader/database/database.dart';
import 'package:rss_reader/database/companions.dart';
import 'package:rss_reader/repositories/article.dart';

/// Facilitates common interactions with feeds
class FeedService {
  final Database db;
  final ArticleRepository articles;

  FeedService(this.db) : articles = ArticleRepository(db);

  /// Adds a new feed and all its articles into the database
  ///
  /// [title] and [description] allow to override title and description of the feed
  Future<Feed> subscribeToFeed(
    FeedWithArticlesCompanion companion, {
    String? title,
    String? description,
  }) async {
    companion = companion.copyWith(name: title, description: description);

    final feed = await db.into(db.feeds).insertReturning(companion.feed);
    await articles.addBulk(feed, companion.articles);

    return feed;
  }

  /// Computes a list of all articles from remote feed that are not in database
  Future<List<ArticlesCompanion>> getNewArticles(
    FeedWithArticlesCompanion feed,
  ) async {
    final newArticles = <ArticlesCompanion>[];

    // Could be optimized to query every url existence at once
    for (final article in feed.articles) {
      final exists = (await articles.findByUrl(article.url.value)) != null;

      if (!exists) {
        newArticles.add(article);
      }
    }

    return newArticles;
  }
}
