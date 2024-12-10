// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Feed _$FeedFromJson(Map<String, dynamic> json) => Feed(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String?,
      thumbnail: json['thumbnail'] == null
          ? null
          : Uri.parse(json['thumbnail'] as String),
    );

Map<String, dynamic> _$FeedToJson(Feed instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'thumbnail': instance.thumbnail?.toString(),
    };
