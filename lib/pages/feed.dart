import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/database/dataclasses.dart';
import 'package:rss_reader/repositories/feed.dart';
import 'package:rss_reader/widgets/article/list.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late Future<List<ArticleWithFeed>> _articlesFuture;

  @override
  void initState() {
    super.initState();
    _articlesFuture = context.read<FeedRepository>().unreadArticles();
  }

  Future<void> _refresh() {
    final future = context.read<FeedRepository>().unreadArticles();
    setState(() {
      _articlesFuture = future;
    });
    return future;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ArticleList(future: _articlesFuture, onRefresh: _refresh),
    );
  }
}
