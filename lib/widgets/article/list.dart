import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/models/article.dart';
import 'package:rss_reader/providers/article_list.dart';
import 'package:rss_reader/services/feed.dart';
import 'package:rss_reader/widgets/article/card.dart';
import 'package:rss_reader/widgets/article/skeleton.dart';
import 'package:rss_reader/widgets/error.dart';

/// A list of articles, loaded from the given future.
/// Displays "skeleton" UI while the future is loading.
/// Displays the error message, when the future has an error.
class SliverArticleList extends StatelessWidget {
  final Future<List<Article>> future;

  final Future<void> Function() onRefresh;

  const SliverArticleList({
    required this.future,
    required this.onRefresh,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return SliverFillRemaining(
              child: CustomizableErrorScreen(
                heading: 'API Error',
                description: 'There was an error while fetching articles.',
                error: snapshot.error!,
                stackTrace: snapshot.stackTrace,
                onPressRetry: onRefresh,
              ),
            );
          }

          if (snapshot.data!.isEmpty) {
            return SliverToBoxAdapter(
              child: Center(
                child: Text(
                  'Empty list!',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            );
          }

          return ChangeNotifierProvider<ArticleListModel>(
            create:
                (context) => ArticleListModel(
                  api: context.read<FeedService>().api,
                  articles: snapshot.data!,
                ),
            child: SliverList.separated(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) => ArticleCard(snapshot.data![index]),
              separatorBuilder: (_, _) => const SizedBox(height: 10),
            ),
          );
        } else {
          return CustomScrollView(
            physics: NeverScrollableScrollPhysics(),
            slivers: [ArticleSkeletonSliverList()],
          );
        }
      },
    );
  }
}
