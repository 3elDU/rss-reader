import 'package:json_annotation/json_annotation.dart';

part 'feed.g.dart';

@JsonSerializable()
class Feed {
  final int id;
  final String title;
  final String? description;
  final Uri? thumbnail;

  const Feed({
    required this.id,
    required this.title,
    this.description,
    this.thumbnail,
  });

  factory Feed.fromJson(Map<String, dynamic> json) => _$FeedFromJson(json);

  Map<String, dynamic> toJson() => _$FeedToJson(this);
}
