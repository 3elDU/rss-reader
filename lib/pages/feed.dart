import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/models/article.dart';
import 'package:rss_reader/services/feed.dart';
import 'package:rss_reader/widgets/article/list.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late Future<List<Article>> _articlesFuture;

  @override
  void initState() {
    super.initState();
    _articlesFuture = context.read<FeedService>().unreadArticles();
  }

  Future<void> _refresh() {
    final future = context.read<FeedService>().unreadArticles();
    setState(() {
      _articlesFuture = future;
    });
    return future;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ArticleList(
        future: _articlesFuture,
        onRefresh: _refresh,
      ),
    );
  }
}
