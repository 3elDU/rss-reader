import 'dart:collection';

import 'package:drift/drift.dart';
import 'package:rss_reader/database/database.dart';
import 'package:rss_reader/database/dataclasses.dart';

mixin _ArticleQueryHelper {
  /// Takes an existing select() statement on articles table and performs
  /// a join to return each article with the corresponding feed
  Selectable<ArticleWithFeed> _join(
    Database db,
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
}

/// How articles should be sorted
enum Sort { newestToOldest, oldestToNewest, alphabeticAtoZ, alphabetricZtoA }

/// How to filter articles relative to the specified date
enum DateFilterKind { olderThan, newerThan }

class DateFilter {
  DateTime date;
  DateFilterKind kind;

  /// Filter articles by specified date and with specified filter kind
  DateFilter({required this.kind, required this.date});

  /// Filter articles that are older than now (so to say, include all articles)
  DateFilter.olderThanNow() : date = DateTime.now(), kind = .olderThan;

  /// Filter articles by date that is newer than specified date
  DateFilter.olderThan(this.date) : kind = .olderThan;

  /// Filter articles by date that is older than specified date
  DateFilter.newerThan(this.date) : kind = .newerThan;
}

/// Allows to query articles with filters and ordering applied,
/// using a builder pattern style.
class ArticleQueryBuilder with _ArticleQueryHelper {
  ArticleQueryBuilder();

  /// Creates an instance with all filters and ordering copied from another instance
  ArticleQueryBuilder.fromAnother(ArticleQueryBuilder other) {
    _sort = other._sort;
    _statuses = other._statuses;
    _feeds = other._feeds;
    _dateFilter = other._dateFilter;
    _search = other._search;
  }

  /// Clone this instance with all filters and ordering preserved
  ArticleQueryBuilder copy() => ArticleQueryBuilder.fromAnother(this);

  Sort _sort = Sort.newestToOldest;
  List<ArticleStatus> _statuses = [];
  List<Feed> _feeds = [];
  DateFilter? _dateFilter;
  String? _search;

  /// Retrieve the sorting of articles
  Sort get sorting => _sort;

  /// Retrieves the filtered articles statuses
  UnmodifiableListView<ArticleStatus> get statuses =>
      UnmodifiableListView(_statuses);

  /// Retrieves the feeds that articles are filtered by, if any
  UnmodifiableListView<Feed> get feeds => UnmodifiableListView(_feeds);

  /// Retrieve the current date filtering mode
  DateFilter? get dateFilter => _dateFilter;

  /// Orders articles
  void order(Sort sort) {
    _sort = sort;
  }

  /// Include only new articles
  void unread() {
    _statuses = [ArticleStatus.unread];
  }

  /// Include only read articles
  void read() {
    _statuses = [ArticleStatus.read];
  }

  /// Include only snoozed articles
  void snoozed() {
    _statuses = [ArticleStatus.snoozed];
  }

  /// Include articles that match one of provided statuses
  void withStatuses(List<ArticleStatus> statuses) {
    _statuses = statuses;
  }

  /// Switches the status used for filtering to the provided one,
  /// or removes it from filters if it is already turned on
  void toggleStatus(ArticleStatus status) {
    if (_statuses.contains(status)) {
      _statuses.remove(status);
    } else {
      _statuses = [status];
    }
  }

  /// Filter articles from specified feeds
  void inFeeds(List<Feed> feeds) {
    _feeds = feeds;
  }

  /// Include articles from all feeds
  void inAnyFeed() {
    _feeds = [];
  }

  /// Include article from this feed, or remove it from filters, if already
  /// present in there.
  void toggleFeed(Feed feed) {
    if (_feeds.contains(feed)) {
      _feeds.remove(feed);
    } else {
      _feeds.add(feed);
    }
  }

  /// Provide a date filter instance for filtering by date
  void filterDate(DateFilter filter) {
    _dateFilter = filter;
  }

  /// Remove current filtering by date, if ste
  void clearDateFilter() {
    _dateFilter = null;
  }

  /// Include only articles containing [needle] in their string or description
  void search(String needle) {
    _search = needle;
  }

  /// Returns the list of articles with sorting and ordering applied
  Future<List<ArticleWithFeed>> run(ArticleRepository repo) async {
    final query = repo._db.select(repo._db.articles);

    // Ordering
    query.orderBy([
      (a) => OrderingTerm(
        expression: switch (_sort) {
          Sort.alphabeticAtoZ || Sort.alphabetricZtoA => a.title,
          Sort.newestToOldest || Sort.oldestToNewest => a.publishedAt,
        },
        mode: switch (_sort) {
          Sort.newestToOldest || Sort.alphabetricZtoA => .desc,
          Sort.oldestToNewest || Sort.alphabeticAtoZ => .asc,
        },
      ),
    ]);

    // Text search
    if (_search != null) {
      query.where(
        (a) => a.title.contains(_search!) | a.description.contains(_search!),
      );
    }

    // Filtering by status
    if (_statuses.isNotEmpty) {
      query.where((a) => a.status.isInValues(_statuses));
    }

    // Filtering by feeds
    if (_feeds.isNotEmpty) {
      query.where((a) => a.feed.isIn(_feeds.map((f) => f.id)));
    }

    // Filtering by date
    if (_dateFilter != null) {
      query.where((a) {
        final col = a.publishedAt;

        return switch (dateFilter!.kind) {
          DateFilterKind.newerThan => col.isBiggerThanValue(dateFilter!.date),
          DateFilterKind.olderThan => col.isSmallerThanValue(dateFilter!.date),
        };
      });
    }

    return _join(repo._db, query).get();
  }
}

class ArticleRepository with _ArticleQueryHelper {
  final Database _db;

  const ArticleRepository(this._db);

  /// Add multiple articles to the corresponding feed
  ///
  /// [ArticlesCompanion.feed] will be populated accordingly.
  Future<void> addBulk(Feed parent, List<ArticlesCompanion> articles) async {
    await _db.batch((batch) {
      for (final article in articles) {
        batch.insert(_db.articles, article.copyWith(feed: Value(parent.id)));
      }
    });
  }

  /// Returns articles containing the supplied text in their title or descriptions
  Future<List<ArticleWithFeed>> search(String search) async {
    return _join(
      _db,
      _order(
        _db.select(_db.articles)..where(
          (a) => a.title.contains(search) | a.description.contains(search),
        ),
      ),
    ).get();
  }

  /// Finds an article by its URL
  Future<ArticleWithFeed?> findByUrl(String url) async {
    return _join(
      _db,
      _db.select(_db.articles)..where((a) => a.url.equals(url)),
    ).getSingleOrNull();
  }

  /// Returns a list of articles in the given feed
  Future<List<ArticleWithFeed>> inFeed(int feedId) async {
    return _join(
      _db,
      _order(_db.select(_db.articles)..where((a) => a.feed.equals(feedId))),
    ).get();
  }

  /// Returns a list of all unread articles
  Future<List<ArticleWithFeed>> unread() async {
    return _join(
      _db,
      _db.select(_db.articles)..where((a) => a.status.equalsValue(.unread)),
    ).get();
  }

  /// Returns a list of all articles marked as snoozed (read later)
  Future<List<ArticleWithFeed>> snoozed() async {
    return _join(
      _db,
      _order(
        _db.select(_db.articles)..where((a) => a.status.equalsValue(.snoozed)),
      ),
    ).get();
  }

  /// Marks the specified article as read, returning the article with an updated status
  Future<Article> markRead(Article article) async {
    article = article.copyWith(status: ArticleStatus.read);
    await _db.update(_db.articles).replace(article);
    return article;
  }

  /// Puts the article into read later list (sets its status to snoozed),
  /// returning the article with an updated status
  Future<Article> snooze(Article article) async {
    article = article.copyWith(status: ArticleStatus.snoozed);
    await _db.update(_db.articles).replace(article);
    return article;
  }
}
