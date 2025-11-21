import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/database/database.dart';
import 'package:rss_reader/database/dataclasses.dart';
import 'package:rss_reader/main.dart';
import 'package:rss_reader/pages/subscription.dart';
import 'package:rss_reader/providers/article_list.dart';
import 'package:rss_reader/widgets/error.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class ArticleCard extends StatelessWidget {
  final ArticleWithFeed model;

  /// Whether to enable the clickable header, that navigates to subscription
  /// page
  final bool clickableHeader;

  const ArticleCard(this.model, {super.key, this.clickableHeader = true});

  Widget _buildTitle(BuildContext context) {
    return DefaultTextStyle.merge(
      style: Theme.of(context).textTheme.bodySmall!.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      child: Row(
        children: [
          if (model.article.status == .unread ||
              model.article.status == .snoozed) ...[
            const Badge(label: Text('New')),
            const SizedBox(width: 8.0),
          ],
          Expanded(
            child: Tooltip(
              // TODO: format this to user's locale
              message: model.article.createdAt.toString(),
              child: Text(
                '${model.feed.title} • ${timeago.format(model.article.createdAt)}',
                overflow: .ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// [ArticleListModel] is required to mark article as read
  Future<void> _openInBrowser(BuildContext context) async {
    if (!(await launchUrl(
      Uri.parse(model.article.url),
      mode: LaunchMode.externalApplication,
    ))) {
      // If opening a web browser failed, copy article URL to the clipboard
      await Clipboard.setData(
        ClipboardData(text: model.article.url.toString()),
      );
      scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text(
            'Launching a Web browser failed. Article URL was copied to system clipboard!',
          ),
        ),
      );
    }

    if (context.mounted) {
      await context.read<ArticleListModel?>()?.markAsRead(model);
    }
  }

  @override
  Widget build(BuildContext context) {
    final card = Card.filled(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Title and thumbnail
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title container, 2/3 of width
                Flexible(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitle(context),
                      const SizedBox(height: 8.0),
                      Text(
                        model.article.title,
                        maxLines: 3,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),

                // Padding between title and thumbnail
                const SizedBox(width: 8.0),

                // Thumbnail
                if (model.article.thumbnailUrl != null)
                  const SizedBox(height: 8.0),
                if (model.article.thumbnailUrl != null)
                  Expanded(
                    child: ArticleThumbnail(
                      Uri.parse(model.article.thumbnailUrl!),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8.0),
            // Video indicator / actions
            Row(
              mainAxisAlignment: .end,
              crossAxisAlignment: .center,
              children: [
                // Actions
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AddToReadLaterButton(model),
                    FilledButton(
                      onPressed: () => _openInBrowser(context),
                      child: Text('Read'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (clickableHeader) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SubscriptionPage(model.feed),
            ),
          );
        },
        child: card,
      );
    } else {
      return card;
    }
  }
}

class ArticleThumbnail extends StatelessWidget {
  final Uri thumbnail;

  const ArticleThumbnail(this.thumbnail, {super.key});

  void _previewThumbnail(BuildContext context) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (_) => ThumbnailViewer(thumbnail)),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget image;
    if (thumbnail.path.endsWith('.svg')) {
      image = SvgPicture.network(thumbnail.toString(), fit: BoxFit.cover);
    } else {
      image = Image.network(
        key: ValueKey(thumbnail),
        thumbnail.toString(),
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            // The image was fully loaded
            return GestureDetector(
              onTap: () => _previewThumbnail(context),
              child: Hero(tag: thumbnail, child: child),
            );
          }

          double? progress;
          if (loadingProgress.expectedTotalBytes != null) {
            progress =
                loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes!;
          }

          // Show the loading progress
          return Container(
            alignment: Alignment.center,
            color: Theme.of(context).colorScheme.surfaceContainer,
            child: CircularProgressIndicator(value: progress),
          );
        },
      );
    }

    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(child: image),
      ),
    );
  }
}

class ThumbnailViewer extends StatelessWidget {
  final Uri url;

  const ThumbnailViewer(this.url, {super.key});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(url),
      direction: DismissDirection.down,
      onDismissed: (_) {
        Navigator.pop(context);
      },
      child: InteractiveViewer(
        maxScale: 10,
        child: Hero(tag: url, child: Image.network(url.toString())),
      ),
    );
  }
}

class AddToReadLaterButton extends StatefulWidget {
  final ArticleWithFeed model;

  const AddToReadLaterButton(this.model, {super.key});

  @override
  State<AddToReadLaterButton> createState() => _AddToReadLaterButtonState();
}

class _AddToReadLaterButtonState extends State<AddToReadLaterButton> {
  Future<void>? _toggleReadLaterFuture;

  void handleError(Object? error, StackTrace stackTrace) {
    CustomizableErrorScreen(
      heading: "API Error",
      error: error!,
      stackTrace: stackTrace,
    ).showSnackbar(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _toggleReadLaterFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(12),
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(),
            ),
          );
        }

        return IconButton(
          icon: widget.model.article.status == ArticleStatus.snoozed
              ? const Icon(Icons.check)
              : const Icon(Icons.schedule),
          tooltip: 'Read this later',
          onPressed: () {
            setState(() {
              _toggleReadLaterFuture = context
                  .read<ArticleListModel>()
                  .snooze(widget.model)
                  .onError(handleError);
            });
          },
        );
      },
    );
  }
}
