import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/providers/article.dart';
import 'package:rss_reader/repositories/article.dart';
import 'package:rss_reader/widgets/article/list.dart';

class ReadLaterPage extends StatelessWidget {
  final ArticleQueryBuilder initialFilters = ArticleQueryBuilder()..snoozed();

  ReadLaterPage({super.key});

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
