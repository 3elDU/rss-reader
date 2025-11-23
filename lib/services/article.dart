import 'package:flutter/services.dart';
import 'package:rss_reader/database/database.dart';
import 'package:rss_reader/repositories/article.dart';
import 'package:url_launcher/url_launcher.dart';

/// Facilitates common interactions with articles
class ArticleService {
  final ArticleRepository _articles;

  ArticleService(Database db) : _articles = ArticleRepository(db);

  /// Opens the article in user's preffered browser.
  /// Returns whether opening the browser was successful
  Future<bool> openInBrowser(Article article) async {
    final opened = await launchUrl(
      Uri.parse(article.url),
      mode: LaunchMode.externalApplication,
    );

    if (!opened) {
      // If opening a web browser failed, copy article URL to the clipboard
      await Clipboard.setData(ClipboardData(text: article.url.toString()));
    }

    return opened;
  }
}
