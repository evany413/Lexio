import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/hive_storage.dart';
import '../../core/models/word.dart';

final storageProvider = Provider<HiveStorage>((ref) => HiveStorage());

final allWordsProvider = StreamProvider<List<Word>>((ref) {
  return ref.watch(storageProvider).watchAllWords();
});

final activeWordsProvider = StreamProvider<List<Word>>((ref) {
  return ref.watch(storageProvider).watchWordsByStatus('active');
});

final masteredWordsProvider = StreamProvider<List<Word>>((ref) {
  return ref.watch(storageProvider).watchWordsByStatus('mastered');
});

final achievedWordsProvider = StreamProvider<List<Word>>((ref) {
  return ref.watch(storageProvider).watchWordsByStatus('achieved');
});

final dueWordsProvider = StreamProvider<List<Word>>((ref) {
  return ref.watch(storageProvider).watchDueWords();
});

final wordCountsProvider = Provider<AsyncValue<Map<String, int>>>((ref) {
  return ref.watch(allWordsProvider).whenData((words) => {
        'all': words.length,
        'active': words.where((w) => w.status == 'active').length,
        'mastered': words.where((w) => w.status == 'mastered').length,
        'achieved': words.where((w) => w.status == 'achieved').length,
      });
});

Future<void> insertWord(
  dynamic ref, {
  required String word,
  String? type,
  String? pronunciation,
  String? meaning,
  String? usageExample,
  String? synonym,
  DateTime? nextReviewAt,
}) async {
  await ref.read(storageProvider).insertWord(
        word: word,
        type: type,
        pronunciation: pronunciation,
        meaning: meaning,
        usageExample: usageExample,
        synonym: synonym,
        nextReviewAt: nextReviewAt,
      );
}

Future<void> recordReview(dynamic ref, Word word, int quality) async {
  final storage = ref.read(storageProvider) as HiveStorage;

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

  await storage.updateWord(word.copyWith(
    easeFactor: newEF,
    intervalDays: newInterval,
    repetitions: newReps,
    nextReviewAt: nextReview,
    status: status,
  ));

  await storage.addReview(wordId: word.id, quality: quality);
}
