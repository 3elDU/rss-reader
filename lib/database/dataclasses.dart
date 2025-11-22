import 'package:rss_reader/database/database.dart';

/// Article that contains a reference to its parent feed
class ArticleWithFeed {
  const ArticleWithFeed(this.article, this.feed);

  final Article article;
  final Feed feed;

  ArticleWithFeed copyWith({Article? article, Feed? feed}) =>
      ArticleWithFeed(article ?? this.article, feed ?? this.feed);
}
