// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Article _$ArticleFromJson(Map<String, dynamic> json) => Article(
  id: (json['id'] as num).toInt(),
  subscriptionId: (json['subscriptionId'] as num).toInt(),
  title: json['title'] as String,
  url: Uri.parse(json['url'] as String),
  unread: json['new'] as bool,
  created: DateTime.parse(json['created'] as String),
  readLater: json['readLater'] as bool,
  subscription:
      json['subscription'] == null
          ? null
          : Feed.fromJson(json['subscription'] as Map<String, dynamic>),
  video: json['video'] as bool?,
  description: json['description'] as String?,
  thumbnail:
      json['thumbnail'] == null ? null : Uri.parse(json['thumbnail'] as String),
  addedToReadLater:
      json['addedToReadLater'] == null
          ? null
          : DateTime.parse(json['addedToReadLater'] as String),
);

Map<String, dynamic> _$ArticleToJson(Article instance) => <String, dynamic>{
  'id': instance.id,
  'subscriptionId': instance.subscriptionId,
  'subscription': instance.subscription,
  'title': instance.title,
  'description': instance.description,
  'url': instance.url.toString(),
  'new': instance.unread,
  'thumbnail': instance.thumbnail?.toString(),
  'created': instance.created.toIso8601String(),
  'readLater': instance.readLater,
  'addedToReadLater': instance.addedToReadLater?.toIso8601String(),
  'video': instance.video,
};
