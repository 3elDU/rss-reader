import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/database/dataclasses.dart';
import 'package:rss_reader/repositories/article.dart';
import 'package:rss_reader/widgets/article/list.dart';

class ReadLaterPage extends StatefulWidget {
  const ReadLaterPage({super.key});

  @override
  State<ReadLaterPage> createState() => _ReadLaterPageState();
}

class _ReadLaterPageState extends State<ReadLaterPage> {
  late Future<List<ArticleWithFeed>> _articlesFuture;

  @override
  void initState() {
    super.initState();

    _articlesFuture = context.read<ArticleRepository>().snoozedArticles();
  }

  Future<void> _refresh() {
    final future = context.read<ArticleRepository>().snoozedArticles();
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
