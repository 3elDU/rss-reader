import 'package:rss_reader/database/database.dart';
import 'package:rss_reader/repositories/article.dart';
import 'package:rss_reader/repositories/feed.dart';
import 'package:rss_reader/services/feed.dart';
import 'package:rss_reader/services/remote_feed.dart';
import 'package:workmanager/workmanager.dart';

const refreshTaskKey = "cc.petafloppa.foxrss.refreshTask";

Future<bool> refreshTask() async {
  print('Starting the refresh task');

  final db = Database();

  final feeds = FeedRepository(db);
  final articles = ArticleRepository(db);
  final remoteService = RemoteFeedService();
  final feedService = FeedService(db);

  for (final feed in await feeds.all()) {
    final remoteFeed = await remoteService.get(Uri.parse(feed.url));
    final newArticles = await feedService.getNewArticles(remoteFeed);

    if (newArticles.isEmpty) continue;

    print(
      'Adding ${newArticles.length} new article(s) from the feed "${feed.title}"',
    );

    await articles.addBulk(feed, newArticles);
  }

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
