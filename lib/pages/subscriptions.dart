import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/database/database.dart';
import 'package:rss_reader/pages/subscription.dart';
import 'package:rss_reader/repositories/feed.dart';
import 'package:rss_reader/widgets/error.dart';
import 'package:rss_reader/widgets/search.dart';

class SubscriptionsPage extends StatefulWidget {
  const SubscriptionsPage({super.key});

  @override
  State<SubscriptionsPage> createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> {
  late Future<List<Feed>> _feedsFuture;

  @override
  void initState() {
    super.initState();

    _feedsFuture = context.read<FeedRepository>().all();
  }

  Widget _buildListView(List<Feed> feeds) {
    return ListView.builder(
      itemCount: feeds.length,
      itemBuilder: (_, index) => ListTile(
        title: Text(feeds[index].title),
        subtitle: Text(
          feeds[index].description ?? '(No Description)',
          maxLines: 3,
          overflow: .ellipsis,
        ),
        onTap: () => SubscriptionPage.open(context, feeds[index]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const Padding(padding: .all(16.0), child: ArticleSearchBar()),
          Expanded(
            child: FutureBuilder(
              future: _feedsFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return _buildListView(snapshot.data!);
                } else if (snapshot.hasError) {
                  return CustomizableErrorScreen(
                    heading: 'Error',
                    description:
                        'There was an error loading the subscriptions list',
                    error: snapshot.error!,
                    stackTrace: snapshot.stackTrace!,
                  );
                } else {
                  return const SizedBox.expand();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
