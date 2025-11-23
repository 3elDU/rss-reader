import 'package:rss_reader/database/database.dart';
import 'package:rss_reader/repositories/article.dart';
import 'package:rss_reader/repositories/feed.dart';
import 'package:rss_reader/services/feed.dart';
import 'package:rss_reader/services/remote_feed.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

const refreshTaskKey = "cc.petafloppa.foxrss.refreshTask";

Future<bool> refreshTask() async {
  print('Starting the refresh task');

  final db = Database();
  final prefs = SharedPreferencesAsync();

  final feeds = FeedRepository(db, prefs);
  final articles = ArticleRepository(db);
  final remoteService = RemoteFeedService();
  final feedService = FeedService(db);

  for (final feed in await feeds.all()) {
    final remoteFeed = await remoteService.get(Uri.parse(feed.url));
    final newArticles = await feedService.getNewArticles(remoteFeed);

    // Mark the feed as updated even with no new articles
    // The updated date reflects when was the last time we communicated
    // with a feed, not the last time something new was added.
    // In case of a website going offline, this date will show that by staying still.
    await feeds.markFeedUpdated(feed);

    if (newArticles.isEmpty) continue;

    print(
      'Adding ${newArticles.length} new article(s) from the feed "${feed.title}"',
    );

    await articles.addBulk(feed, newArticles);
  }

  // Mark the feeds as updated, even if no new articles were fetched
  // Main thread will watch for this property to know that refresh task has finished.
  await feeds.markGlobalUpdated();
  await db.close();

  return true;
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    switch (taskName) {
      case refreshTaskKey:
        return refreshTask();
      default:
        break;
    }

    return true;
  });
}
