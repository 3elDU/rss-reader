import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/models/article.dart';
import 'package:rss_reader/providers/article_list.dart';
import 'package:rss_reader/services/feed.dart';
import 'package:rss_reader/widgets/article/card.dart';
import 'package:rss_reader/widgets/error.dart';

class ArticleList extends StatelessWidget {
  final Future<List<Article>> future;

  final Future<void> Function() onRefresh;

  const ArticleList({
    required this.future,
    required this.onRefresh,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return CustomizableErrorScreen(
            heading: 'API Error',
            description: 'There was an error while fetching articles.',
            error: snapshot.error!,
            stackTrace: snapshot.stackTrace,
            onPressRetry: onRefresh,
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return ChangeNotifierProvider<ArticleListModel>(
            create: (context) => ArticleListModel(
              api: Provider.of<FeedService>(context, listen: false).api,
              articles: snapshot.data!,
            ),
            child: RefreshIndicator(
              onRefresh: onRefresh,
              child: Consumer<ArticleListModel>(
                builder: (_, model, __) => ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: model.items.length,
                  itemBuilder: (_, index) => ArticleCard(model.items[index]),
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                ),
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
