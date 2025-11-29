import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/database/database.dart';
import 'package:rss_reader/database/dataclasses.dart';
import 'package:rss_reader/services/article.dart';

class ArticleDetailsPage extends StatelessWidget {
  final ArticleWithFeed model;

  const ArticleDetailsPage(this.model, {super.key});

  static void open(BuildContext context, ArticleWithFeed model) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => ArticleDetailsPage(model)));
  }

  @override
  Widget build(BuildContext context) {
    final article = model.article;
    final feed = model.feed;

    return Scaffold(
      appBar: AppBar(title: const Text('Article')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const .all(16),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              // Title
              Text(
                article.title,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 12),
              // Feed title
              Text(feed.title, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              // New badge, Published date
              Row(
                children: [
                  if (article.status == ArticleStatus.unread ||
                      article.status == ArticleStatus.snoozed) ...[
                    Badge(label: const Text('New')),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    'Published ${DateFormat.yMMMd().format(article.publishedAt)}',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Description
              if (article.description?.isNotEmpty ?? false) ...[
                Text(
                  article.description!,
                  style: Theme.of(context).textTheme.bodyMedium!,
                ),
                const SizedBox(height: 24),
              ],
              Container(
                width: double.infinity,
                alignment: .bottomRight,
                child: FilledButton.icon(
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Read'),
                  onPressed: () {
                    context.read<ArticleService?>()?.openInBrowser(article);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
