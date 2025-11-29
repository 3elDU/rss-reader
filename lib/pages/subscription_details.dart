import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/database/database.dart';
import 'package:rss_reader/providers/article.dart';
import 'package:rss_reader/repositories/article.dart';
import 'package:rss_reader/repositories/feed.dart';
import 'package:rss_reader/widgets/article/card.dart';
import 'package:rss_reader/widgets/article/list.dart';

/// Page showing subscription info, as well as all articles inside it
class SubscriptionDetailsPage extends StatelessWidget {
  final Feed feed;
  final ArticleQueryBuilder filters;

  SubscriptionDetailsPage(this.feed, {super.key})
    : filters = ArticleQueryBuilder()..inFeeds([feed]);

  static void open(BuildContext context, Feed subscription) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SubscriptionDetailsPage(subscription),
      ),
    );
  }

  void _unsubscribe(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsubscribe?'),
        content: const Text('All articles from this feed will also be deleted'),
        actions: [
          TextButton(
            child: const Text('No'),
            onPressed: () => Navigator.pop<bool>(context, true),
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () => Navigator.pop<bool>(context, true),
          ),
        ],
      ),
    );

    if (confirm == null || !confirm || !context.mounted) return;

    await context.read<FeedRepository>().unsubscribe(feed);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unsubscribed from ${feed.title}')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<ArticleListModel>(
        create: (context) => ArticleListModel(
          filters: filters,
          repo: context.read<ArticleRepository>(),
        ),
        child: CustomScrollView(
          slivers: [
            // Large app bar with title
            SliverAppBar.large(
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(feed.title),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  tooltip: 'Unsubscribe',
                  onPressed: () => _unsubscribe(context),
                ),
              ],
            ),
            // Description
            if (feed.description != null)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    feed.description!,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            Consumer<ArticleListModel>(
              builder: (_, model, _) => SliverArticleList(
                loading: model.loading,
                items: model.items,
                cardBuilder: (model) => ArticleCard(
                  model,
                  // Avoid recursive subscription detail pages
                  clickableHeader: false,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),
          ],
        ),
      ),
    );
  }
}
