import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/database/dataclasses.dart';
import 'package:rss_reader/repositories/article.dart';
import 'package:rss_reader/services/refresh.dart';
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
    _articlesFuture = context.read<ArticleRepository>().unread();
  }

  Future<void> _refresh() async {
    final refreshService = context.read<RefreshService>();
    final articles = context.read<ArticleRepository>();

    await refreshService.dispatchTask();

    setState(() {
      _articlesFuture = articles.unread();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ArticleList(future: _articlesFuture, onRefresh: _refresh),
    );
  }
}
