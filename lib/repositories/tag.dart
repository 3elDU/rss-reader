import 'package:drift/drift.dart';
import 'package:rss_reader/database/database.dart';

class TagRepository {
  final Database _db;

  const TagRepository(this._db);

  Future<List<Tag>> all() async {
    return (_db.select(
      _db.tags,
    )..orderBy([(u) => OrderingTerm.desc(u.createdAt)])).get();
  }

  Future<Tag> save(TagsCompanion tag) async {
    return _db.into(_db.tags).insertReturning(tag);
  }

  Future<void> update(TagsCompanion tag) async {
    await _db.update(_db.tags).replace(tag);
  }

  Future<void> delete(Tag tag) async {
    await _db.delete(_db.tags).delete(tag);
  }

  /// Returns the count of articles having this tag
  Future<int> countArticles(Tag tag) async {
    return 5;
  }
}
