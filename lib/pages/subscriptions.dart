import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/pages/subscription_details.dart';
import 'package:rss_reader/providers/feed.dart';
import 'package:rss_reader/widgets/article/search.dart';

class SubscriptionsPage extends StatelessWidget {
  const SubscriptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final feeds = context.watch<FeedListModel>().feeds;

    return SafeArea(
      child: Column(
        children: [
          const Padding(padding: .all(16.0), child: ArticleSearchBar()),
          Expanded(
            child: ListView.builder(
              itemCount: feeds.length,
              itemBuilder: (_, index) => ListTile(
                title: Text(feeds[index].title),
                subtitle: Text(
                  feeds[index].description ?? '(No Description)',
                  maxLines: 3,
                  overflow: .ellipsis,
                ),
                onTap: () =>
                    SubscriptionDetailsPage.open(context, feeds[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
