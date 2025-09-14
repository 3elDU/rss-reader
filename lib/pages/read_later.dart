import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/models/article.dart';
import 'package:rss_reader/services/feed.dart';
import 'package:rss_reader/widgets/article/list.dart';

class ReadLaterPage extends StatefulWidget {
  const ReadLaterPage({super.key});

  @override
  State<ReadLaterPage> createState() => _ReadLaterPageState();
}

class _ReadLaterPageState extends State<ReadLaterPage> {
  late Future<List<Article>> _articlesFuture;

  @override
  void initState() {
    super.initState();

    _articlesFuture = context.read<FeedService>().readLater();
  }

  Future<void> _refresh() {
    final future = context.read<FeedService>().readLater();
    setState(() {
      _articlesFuture = future;
    });
    return future;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SliverArticleList(future: _articlesFuture, onRefresh: _refresh),
    );
  }
}
