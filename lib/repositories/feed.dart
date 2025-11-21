import 'package:drift/drift.dart';
import 'package:rss_reader/database/database.dart';

/// Abstracts away basic database operations with articles and feeds.
class FeedRepository {
  final Database db;

  const FeedRepository(this.db);

  /// Takes an existing select() statement on articles table and performs
  /// a join to return each article with the corresponding feed
  Selectable<ArticleWithFeed> _join(
    SimpleSelectStatement<$ArticlesTable, Article> q,
  ) {
    return q
        .join([innerJoin(db.feeds, db.feeds.id.equalsExp(db.articles.feed))])
        .map((row) {
          return ArticleWithFeed(
            row.readTable(db.articles),
            row.readTable(db.feeds),
          );
        });
  }

  Future<List<ArticleWithFeed>> articlesInFeed(int feedId) async {
    return _join(
      db.select(db.articles)..where((a) => a.feed.equals(feedId)),
    ).get();
  }

  Future<List<ArticleWithFeed>> unreadArticles() async {
    return _join(
      db.select(db.articles)..where((a) => a.status.equalsValue(.unread)),
    ).get();
  }

  Future<List<ArticleWithFeed>> snoozedArticles() async {
    return _join(
      db.select(db.articles)..where((a) => a.status.equalsValue(.snoozed)),
    ).get();
  }
}
