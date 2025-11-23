import 'package:rss_reader/database/database.dart';
import 'package:rss_reader/repositories/feed.dart';
import 'package:rss_reader/task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

/// Manages fetching articles from feeds, finding new articles and adding them
/// to database
class RefreshService {
  final FeedRepository _feeds;

  RefreshService(Database db, SharedPreferencesAsync prefs)
    : _feeds = FeedRepository(db, prefs);

  /// Registers the refresh task to run periodically in background
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
  Future<void> dispatchTask() async {
    await Workmanager().registerOneOffTask(refreshTaskKey, refreshTaskKey);
    await _feeds.waitForGlobalUpdated();
  }
}
