import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/main.dart';
import 'package:rss_reader/models/article.dart';
import 'package:rss_reader/providers/article_list.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class ArticleCard extends StatelessWidget {
  final Article article;

  const ArticleCard(this.article, {super.key});

  Widget _buildTitle(BuildContext context) {
    return DefaultTextStyle.merge(
      style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
      child: Row(children: [
        if (article.unread) const Badge(label: Text('New')),
        if (article.unread) const SizedBox(width: 8.0),
        Expanded(
          child: Tooltip(
            // TODO: format this to user's locale
            message: article.created.toString(),
            child: Text(
              '${article.subscription!.title} • ${timeago.format(article.created)}',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
      ]),
    );
  }

  /// [ArticleListModel] is required to mark article as read
  Future<void> _openInBrowser(ArticleListModel articleList) async {
    if (!(await launchUrl(
      article.url,
      mode: LaunchMode.externalApplication,
    ))) {
      // If opening a web browser failed, copy article URL to the clipboard
      await Clipboard.setData(ClipboardData(text: article.url.toString()));
      scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
        content: Text(
          'Launching a Web browser failed. Article URL was copied to system clipboard!',
        ),
      ));
    }

    await articleList.markAsRead(article.id);
  }

  @override
  Widget build(BuildContext context) {
    final articleList = context.read<ArticleListModel>();

    return Card.filled(
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
                        article.title,
                        maxLines: 3,
                        style: Theme.of(context).textTheme.titleMedium,
                      )
                    ],
                  ),
                ),

                // Padding between title and thumbnail
                const SizedBox(width: 8.0),

                // Thumbnail
                if (article.thumbnail != null) const SizedBox(height: 8.0),
                if (article.thumbnail != null)
                  Expanded(
                    child: ArticleThumbnail(article.thumbnail!),
                  ),
              ],
            ),
            const SizedBox(height: 8.0),
            // Video indicator / actions
            Row(
              mainAxisAlignment: (article.video == true)
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (article.video == true) const Icon(Icons.videocam),

                // Actions
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AddToReadLaterButton(article),
                    FilledButton(
                      onPressed: () => _openInBrowser(articleList),
                      child: Text(article.video == true ? 'Watch' : 'Read'),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ArticleThumbnail extends StatelessWidget {
  final Uri thumbnail;

  const ArticleThumbnail(this.thumbnail, {super.key});

  void _previewThumbnail(BuildContext context) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => ThumbnailViewer(thumbnail),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget image;
    if (thumbnail.path.endsWith('.svg')) {
      image = SvgPicture.network(
        thumbnail.toString(),
        fit: BoxFit.cover,
      );
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
              child: Hero(
                tag: thumbnail,
                child: child,
              ),
            );
          }

          double? progress;
          if (loadingProgress.expectedTotalBytes != null) {
            progress = loadingProgress.cumulativeBytesLoaded /
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
        child: Container(
          color: Colors.black,
          child: image,
        ),
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
        child: Hero(
          tag: url,
          child: Image.network(
            url.toString(),
          ),
        ),
      ),
    );
  }
}

class AddToReadLaterButton extends StatefulWidget {
  final Article article;

  const AddToReadLaterButton(this.article, {super.key});

  @override
  State<AddToReadLaterButton> createState() => _AddToReadLaterButtonState();
}

class _AddToReadLaterButtonState extends State<AddToReadLaterButton> {
  Future<void>? _toggleReadLaterFuture;

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
          icon: widget.article.readLater
              ? const Icon(Icons.check)
              : const Icon(Icons.schedule),
          onPressed: () {
            setState(() {
              _toggleReadLaterFuture = context
                  .read<ArticleListModel>()
                  .toggleReadLater(widget.article.id);
            });
          },
        );
      },
    );
  }
}
