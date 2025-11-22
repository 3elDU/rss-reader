import 'package:rss_reader/database/database.dart';
import 'package:rss_reader/repositories/article.dart';
import 'package:rss_reader/task.dart';
import 'package:workmanager/workmanager.dart';

/// Manages fetching articles from feeds, finding new articles and adding them
/// to database
class RefreshService {
  final Database db;
  final ArticleRepository articles;

  RefreshService(this.db) : articles = ArticleRepository(db);

  /// Registers the refresh job to run periodically in background
  Future<void> registerPeriodicTask() async {
    // Try to cancel the task if it was registered previously
    await Workmanager().cancelByUniqueName(refreshTaskKey);

    return Workmanager().registerPeriodicTask(
      refreshTaskKey,
      refreshTaskKey,
      frequency: Duration(minutes: 10),
    );
  }

  /// Dispatches the refresh task to run in background
  ///
  /// The future returns when the task has finished its work
  Future<void> dispatchTask() {
    return Workmanager().registerOneOffTask(refreshTaskKey, refreshTaskKey);
  }
}
