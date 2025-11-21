import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

/// Adds primary key and creation time column to the table
mixin IdAndTime on Table {
  late final id = integer().autoIncrement()();
  late final createdAt = dateTime().withDefault(currentDateAndTime)();
}

class Feeds extends Table with IdAndTime {
  late final title = text()();
  late final url = text().unique()();
  late final description = text().nullable()();
}

enum ArticleStatus { unread, read, snoozed }

class Articles extends Table with IdAndTime {
  late final feed = integer().references(Feeds, #id)();
  late final url = text()();
  late final title = text()();
  late final description = text().nullable()();
  late final thumbnailUrl = text().nullable()();
  late final status = textEnum<ArticleStatus>().clientDefault(
    () => ArticleStatus.unread.name,
  )();
  late final publishedAt = dateTime()();
}

@DriftDatabase(tables: [Feeds, Articles])
class Database extends _$Database {
  Database([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        // Enforce valid foreign keys in sqlite
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'foxrss');
  }
}
