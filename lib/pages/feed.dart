import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/providers/article.dart';
import 'package:rss_reader/repositories/article.dart';
import 'package:rss_reader/widgets/article/list.dart';

class FeedPage extends StatelessWidget {
  final initialFilters = ArticleQueryBuilder()..unread();

  FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ChangeNotifierProvider<ArticleListModel>(
        create: (_) => ArticleListModel(
          filters: initialFilters,
          repo: context.read<ArticleRepository>(),
        ),
        child: ArticleListView(),
      ),
    );
  }
}
