import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/providers/article.dart';
import 'package:rss_reader/providers/feed.dart';
import 'package:timeago/timeago.dart' as timeago;

class InfoStrip extends StatelessWidget {
  const InfoStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final (loading, articles) = context.select<ArticleListModel, (bool, int)>(
      (model) => (model.loading, model.items.length),
    );
    final lastUpdated = context.select<FeedListModel, DateTime?>(
      (model) => model.lastUpdated,
    );

    final textStyle = Theme.of(context).textTheme.labelMedium!;

    return AnimatedOpacity(
      opacity: loading ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Text(
            Intl.plural(
              articles,
              one: '1 article',
              other: '$articles articles',
            ),
            style: textStyle,
          ),
          Text(
            'Last updated: ${lastUpdated != null ? timeago.format(lastUpdated) : 'Never'}',
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
