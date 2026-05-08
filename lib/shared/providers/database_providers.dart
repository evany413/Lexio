import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final allWordsProvider = StreamProvider<List<Word>>((ref) {
  return ref.watch(databaseProvider).wordDao.watchAllWords();
});

final activeWordsProvider = StreamProvider<List<Word>>((ref) {
  return ref.watch(databaseProvider).wordDao.watchWordsByStatus('active');
});

final masteredWordsProvider = StreamProvider<List<Word>>((ref) {
  return ref.watch(databaseProvider).wordDao.watchWordsByStatus('mastered');
});

final achievedWordsProvider = StreamProvider<List<Word>>((ref) {
  return ref.watch(databaseProvider).wordDao.watchWordsByStatus('achieved');
});

final dueWordsProvider = StreamProvider<List<Word>>((ref) {
  return ref.watch(databaseProvider).wordDao.watchDueWords();
});

// Derived from the stream so it auto-updates whenever words change
final wordCountsProvider = Provider<AsyncValue<Map<String, int>>>((ref) {
  return ref.watch(allWordsProvider).whenData((words) => {
        'all': words.length,
        'active': words.where((w) => w.status == 'active').length,
        'mastered': words.where((w) => w.status == 'mastered').length,
        'achieved': words.where((w) => w.status == 'achieved').length,
      });
});

// Invalidation helper — call after any write to refresh counts
extension RefreshCounts on Ref {
  void refreshWordData() {
    invalidate(allWordsProvider);
    invalidate(activeWordsProvider);
    invalidate(masteredWordsProvider);
    invalidate(achievedWordsProvider);
    invalidate(dueWordsProvider);
  }
}

// Insert a word and refresh all streams
Future<void> insertWord(WidgetRef ref, WordsCompanion word) async {
  final dao = ref.read(databaseProvider).wordDao;
  await dao.insertWord(word);
}

// Update SRS data after a flashcard review
Future<void> recordReview(WidgetRef ref, Word word, int quality) async {
  final dao = ref.read(databaseProvider).wordDao;

  final newEF = (word.easeFactor +
          (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02)))
      .clamp(1.3, 5.0);

  double newInterval;
  int newReps;

  if (quality < 3) {
    newReps = 0;
    newInterval = 1.0;
  } else {
    newReps = word.repetitions + 1;
    if (newReps == 1) {
      newInterval = 1.0;
    } else if (newReps == 2) {
      newInterval = 6.0;
    } else {
      newInterval = word.intervalDays * newEF;
    }
  }

  String status = 'active';
  if (newInterval >= 90) {
    status = 'achieved';
  } else if (newInterval >= 21) {
    status = 'mastered';
  }

  final nextReview =
      DateTime.now().add(Duration(hours: (newInterval * 24).round()));

  await dao.updateWord(word.copyWith(
    easeFactor: newEF,
    intervalDays: newInterval,
    repetitions: newReps,
    nextReviewAt: Value(nextReview),
    status: status,
  ));

  await dao.addReview(ReviewLogsCompanion(
    wordId: Value(word.id),
    quality: Value(quality),
  ));
}
