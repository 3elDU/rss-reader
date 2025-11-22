import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/database/database.dart';
import 'package:rss_reader/database/dataclasses.dart';
import 'package:rss_reader/providers/article_list.dart';
import 'package:rss_reader/repositories/article.dart';
import 'package:rss_reader/repositories/feed.dart';
import 'package:rss_reader/widgets/article/card.dart';
import 'package:rss_reader/widgets/article/skeleton.dart';

/// Page showing subscription info, as well as all articles inside it
class SubscriptionPage extends StatefulWidget {
  final Feed feed;

  const SubscriptionPage(this.feed, {super.key});

  static void open(BuildContext context, Feed subscription) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => SubscriptionPage(subscription)),
    );
  }

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  late Future<List<ArticleWithFeed>> _articlesFuture;

  @override
  void initState() {
    super.initState();

    _articlesFuture = context.read<ArticleRepository>().articlesInFeed(
      widget.feed.id,
    );
  }

  void _unsubscribe() async {
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

    if (confirm == null || !confirm || !mounted) return;

    await context.read<FeedRepository>().unsubscribe(widget.feed);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unsubscribed from ${widget.feed.title}')),
      );
      Navigator.pop(context);
    }
  }

  Widget _buildLoadingList() => SliverList.separated(
    itemCount: 10,
    itemBuilder: (_, index) => ArticleCardSkeleton(high: index.isEven),
    separatorBuilder: (_, _) => const SizedBox(height: 10),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _articlesFuture,
        builder: (context, snapshot) {
          return ChangeNotifierProxyProvider0(
            create: (_) => ArticleListModel(
              articles: [],
              repo: context.read<ArticleRepository>(),
            ),
            update: (_, model) {
              model!.setArticles(snapshot.data ?? []);
              return model;
            },
            child: CustomScrollView(
              physics: snapshot.hasData ? null : NeverScrollableScrollPhysics(),
              slivers: [
                // Large app bar with title
                SliverAppBar.large(
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(widget.feed.title),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.delete),
                      tooltip: 'Unsubscribe',
                      onPressed: _unsubscribe,
                    ),
                  ],
                ),
                // Description
                if (widget.feed.description != null)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        widget.feed.description!,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: snapshot.connectionState == ConnectionState.waiting
                      ? _buildLoadingList()
                      : Consumer<ArticleListModel>(
                          builder: (_, model, _) => SliverList.separated(
                            itemCount: model.items.length,
                            itemBuilder: (_, index) => ArticleCard(
                              snapshot.data![index],
                              clickableHeader: false,
                            ),
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 10),
                          ),
                        ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),
              ],
            ),
          );
        },
      ),
    );
  }
}
