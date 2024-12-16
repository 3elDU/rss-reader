import 'package:json_annotation/json_annotation.dart';
import 'package:rss_reader/models/feed.dart';
import 'package:rss_reader/util/api.dart';

part 'article.g.dart';

@JsonSerializable()
class Article {
  final int id;
  final int subscriptionId;

  /// Subscription is populated by some routes, but it may be null.
  /// In any case, using the `subscriptionId` property, the corresponding
  /// subscription can always be fetched
  final Feed? subscription;
  final String title;
  final String? description;
  final Uri url;
  @JsonKey(name: 'new')
  final bool unread;
  final Uri? thumbnail;
  final DateTime created;
  bool readLater;
  final DateTime? addedToReadLater;

  // FIXME: implement video type on the backend. Currently this property can never be true.
  final bool? video;

  Article({
    required this.id,
    required this.subscriptionId,
    required this.title,
    required this.url,
    required this.unread,
    required this.created,
    required this.readLater,
    this.subscription,
    this.video,
    this.description,
    this.thumbnail,
    this.addedToReadLater,
  });

  Future<void> toggleReadLater(ApiClient api) async {
    if (readLater) {
      await api.delete('/articles/$id/readlater');
    } else {
      await api.post('/articles/$id/readlater');
    }
    readLater = !readLater;
  }

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleToJson(this);
}
