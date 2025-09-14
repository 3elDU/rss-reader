import 'package:json_annotation/json_annotation.dart';

part 'feed.g.dart';

@JsonSerializable()
class Feed {
  final int id;

  /// Url can be unset in some routes, e.g. /unread or /readlater,
  /// where feed object is embedded with each article
  final String? url;
  final String title;
  final String? description;
  final String? thumbnail;

  const Feed({
    required this.id,
    required this.title,
    this.url,
    this.description,
    this.thumbnail,
  });

  factory Feed.fromJson(Map<String, dynamic> json) => _$FeedFromJson(json);

  Map<String, dynamic> toJson() => _$FeedToJson(this);
}
