import 'package:rss_reader/models/feed.dart';

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
  bool unread;
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

  Future<void> toggleReadLater(dynamic api) async {
    readLater = !readLater;
  }

  Future<void> markAsRead(dynamic api) async {
    await api.post('/articles/$id/markread');
    unread = false;
  }
}
