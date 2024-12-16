import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/models/article.dart';
import 'package:rss_reader/providers/article_list.dart';
import 'package:rss_reader/services/feed.dart';
import 'package:rss_reader/widgets/article.dart';
import 'package:rss_reader/widgets/error.dart';

class ReadLaterPage extends StatefulWidget {
  const ReadLaterPage({super.key});

  @override
  State<ReadLaterPage> createState() => _ReadLaterPageState();
}

class _ReadLaterPageState extends State<ReadLaterPage> {
  late Future<List<Article>> readLaterFuture;

  @override
  void initState() {
    super.initState();

    readLaterFuture = context.read<FeedService>().readLater();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: readLaterFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return RetriableErrorScreen(
              description: 'Error while fetching articles!',
              error: snapshot.error!,
              onPressRetry: () {
                setState(() {
                  readLaterFuture = context.read<FeedService>().readLater();
                });
              },
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return ChangeNotifierProvider<ArticleListModel>(
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
