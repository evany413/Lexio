import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'word_dao.g.dart';

@DriftAccessor(tables: [Words, ReviewLogs])
class WordDao extends DatabaseAccessor<AppDatabase> with _$WordDaoMixin {
  WordDao(super.db);

  Stream<List<Word>> watchAllWords() =>
      (select(words)..orderBy([(w) => OrderingTerm.desc(w.createdAt)])).watch();

  Stream<List<Word>> watchWordsByStatus(String status) => (select(words)
        ..where((w) => w.status.equals(status))
        ..orderBy([(w) => OrderingTerm.desc(w.createdAt)]))
      .watch();

  Stream<List<Word>> watchDueWords() => (select(words)
        ..where((w) =>
            w.nextReviewAt.isSmallerOrEqualValue(DateTime.now()) |
            w.nextReviewAt.isNull())
        ..where((w) => w.status.isIn(['active', 'mastered'])))
      .watch();

  Future<List<Word>> getDueWords() => (select(words)
        ..where((w) =>
            w.nextReviewAt.isSmallerOrEqualValue(DateTime.now()) |
            w.nextReviewAt.isNull())
        ..where((w) => w.status.isIn(['active', 'mastered'])))
      .get();

  Future<List<Word>> getAllWords() => select(words).get();

  Future<Word?> getWordById(int id) =>
      (select(words)..where((w) => w.id.equals(id))).getSingleOrNull();

  Future<int> insertWord(WordsCompanion word) => into(words).insert(word);

  Future<bool> updateWord(Word word) => update(words).replace(word);

  Future<void> updateWordStatus(int id, String status) =>
      (update(words)..where((w) => w.id.equals(id)))
          .write(WordsCompanion(status: Value(status)));

  Future<int> deleteWord(int id) =>
      (delete(words)..where((w) => w.id.equals(id))).go();

  Future<int> addReview(ReviewLogsCompanion review) =>
      into(reviewLogs).insert(review);

  Future<Map<String, int>> getWordCounts() async {
    final all = await select(words).get();
    return {
      'all': all.length,
      'active': all.where((w) => w.status == 'active').length,
      'mastered': all.where((w) => w.status == 'mastered').length,
      'achieved': all.where((w) => w.status == 'achieved').length,
    };
  }
}
