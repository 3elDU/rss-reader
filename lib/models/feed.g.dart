// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Feed _$FeedFromJson(Map<String, dynamic> json) => Feed(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  url: json['url'] as String?,
  description: json['description'] as String?,
  thumbnail: json['thumbnail'] as String?,
);

Map<String, dynamic> _$FeedToJson(Feed instance) => <String, dynamic>{
  'id': instance.id,
  'url': instance.url,
  'title': instance.title,
  'description': instance.description,
  'thumbnail': instance.thumbnail,
};
