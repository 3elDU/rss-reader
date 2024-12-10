import 'package:json_annotation/json_annotation.dart';
import 'package:rss_reader/models/feed.dart';

part 'article.g.dart';

@JsonSerializable()
class Article {
  final int id;
  @JsonKey(name: 'subscription_id')
  final int subscriptionId;
  final Feed? subscription;
  final String title;
  final String? description;
  final Uri url;
  @JsonKey(name: 'new')
  final bool unread;
  final Uri? thumbnail;
  final DateTime created;
  final bool? video;

  const Article({
    required this.id,
    required this.subscriptionId,
    required this.title,
    required this.url,
    required this.unread,
    required this.created,
    this.subscription,
    this.video,
    this.description,
    this.thumbnail,
  });

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleToJson(this);
}
