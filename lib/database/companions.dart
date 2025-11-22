import 'package:drift/drift.dart';
import 'package:rss_reader/database/database.dart';

/// A companion for insertion containing a feed and all of its articles
class FeedWithArticlesCompanion {
  const FeedWithArticlesCompanion(this.feed, this.articles);

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
