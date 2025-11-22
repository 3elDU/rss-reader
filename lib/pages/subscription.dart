import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/database/database.dart';
import 'package:rss_reader/database/dataclasses.dart';
import 'package:rss_reader/providers/article_list.dart';
import 'package:rss_reader/repositories/feed.dart';
import 'package:rss_reader/widgets/article/card.dart';
import 'package:rss_reader/widgets/article/skeleton.dart';

/// Page showing subscription info, as well as all articles inside it
class SubscriptionPage extends StatefulWidget {
  final Feed subscription;

  const SubscriptionPage(this.subscription, {super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  late Future<List<ArticleWithFeed>> _articlesFuture;

  @override
  void initState() {
    super.initState();

    _articlesFuture = context.read<FeedRepository>().articlesInFeed(
      widget.subscription.id,
    );
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
              repo: context.read<FeedRepository>(),
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
                    title: Text(widget.subscription.title),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {},
                      tooltip: 'Unsubscribe',
                    ),
                  ],
                ),
                // Description
                if (widget.subscription.description != null)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        widget.subscription.description!,
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
