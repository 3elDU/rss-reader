import 'package:drift/drift.dart';
import 'package:rss_reader/database/database.dart';
import 'package:rss_reader/database/dataclasses.dart';

class ArticleRepository {
  final Database db;

  const ArticleRepository(this.db);

  /// Add multiple articles to the corresponding feed
  ///
  /// [ArticlesCompanion.feed] will be populated accordingly.
  Future<void> addBulk(Feed parent, List<ArticlesCompanion> articles) async {
    await db.batch((batch) {
      for (final article in articles) {
        batch.insert(db.articles, article.copyWith(feed: Value(parent.id)));
      }
    });
  }

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

  /// Takes an existing select() statement, and orders it by article publish
  /// date from newest to oldest
  SimpleSelectStatement<$ArticlesTable, Article> _order(
    SimpleSelectStatement<$ArticlesTable, Article> q,
  ) {
    return (q..orderBy([(a) => OrderingTerm.desc(a.publishedAt)]));
  }

  /// Returns articles containing the supplied text in their title or descriptions
  Future<List<ArticleWithFeed>> search(String search) async {
    return _join(
      _order(
        db.select(db.articles)..where(
          (a) => a.title.contains(search) | a.description.contains(search),
        ),
      ),
    ).get();
  }

  /// Finds an article by its URL
  Future<ArticleWithFeed?> findByUrl(String url) async {
    return _join(
      db.select(db.articles)..where((a) => a.url.equals(url)),
    ).getSingleOrNull();
  }

  /// Returns a list of articles in the given feed
  Future<List<ArticleWithFeed>> inFeed(int feedId) async {
    return _join(
      _order(db.select(db.articles)..where((a) => a.feed.equals(feedId))),
    ).get();
  }

  /// Returns a list of all unread articles
  Future<List<ArticleWithFeed>> unread() async {
    return _join(
      db.select(db.articles)..where((a) => a.status.equalsValue(.unread)),
    ).get();
  }

  /// Returns a list of all articles marked as snoozed (read later)
  Future<List<ArticleWithFeed>> snoozed() async {
    return _join(
      _order(
        db.select(db.articles)..where((a) => a.status.equalsValue(.snoozed)),
      ),
    ).get();
  }

  /// Marks the specified article as read, returning the article with an updated status
  Future<Article> markRead(Article article) async {
    article = article.copyWith(status: ArticleStatus.read);
    await db.update(db.articles).replace(article);
    return article;
  }

  /// Puts the article into read later list (sets its status to snoozed),
  /// returning the article with an updated status
  Future<Article> snooze(Article article) async {
    article = article.copyWith(status: ArticleStatus.snoozed);
    await db.update(db.articles).replace(article);
    return article;
  }
}
