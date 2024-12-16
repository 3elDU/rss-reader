import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/providers/article_list.dart';
import 'package:rss_reader/widgets/article.dart';
import 'package:rss_reader/models/article.dart';
import 'package:rss_reader/services/feed.dart';
import 'package:rss_reader/widgets/error.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late Future<List<Article>> _articlesFuture;

  @override
  void initState() {
    super.initState();
    _articlesFuture = context.read<FeedService>().unreadArticles();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: _articlesFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return RetriableErrorScreen(
              description: 'Error while fetching articles!',
              error: snapshot.error!,
              onPressRetry: () {
                setState(() {
                  _articlesFuture =
                      context.read<FeedService>().unreadArticles();
                });
              },
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return ChangeNotifierProvider(
              create: (_) => ArticleListModel(snapshot.data!),
              child: Consumer<ArticleListModel>(
                builder: (_, model, __) => ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: model.items.length,
                  itemBuilder: (_, index) => ArticleCard(model.items[index]),
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
