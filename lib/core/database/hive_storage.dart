import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/word.dart';

class HiveStorage {
  static const _wordsBox = 'words';
  static const _reviewLogsBox = 'review_logs';
  static const _uuid = Uuid();

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_wordsBox);
    await Hive.openBox(_reviewLogsBox);
  }

  Box get _words => Hive.box(_wordsBox);
  Box get _reviewLogs => Hive.box(_reviewLogsBox);

  Future<String> insertWord({
    required String word,
    String? type,
    String? pronunciation,
    String? meaning,
    String? usageExample,
    String? synonym,
    DateTime? nextReviewAt,
  }) async {
    final id = _uuid.v4();
    final w = Word(
      id: id,
      word: word,
      type: type,
      pronunciation: pronunciation,
      meaning: meaning,
      usageExample: usageExample,
      synonym: synonym,
      createdAt: DateTime.now(),
      nextReviewAt: nextReviewAt,
    );
    await _words.put(id, w.toMap());
    return id;
  }

  Future<void> updateWord(Word word) async {
    await _words.put(word.id, word.toMap());
  }

  Future<void> updateWordStatus(String id, String status) async {
    final existing = getWordById(id);
    if (existing != null) {
      await _words.put(id, existing.copyWith(status: status).toMap());
    }
  }

  Future<void> deleteWord(String id) async {
    await _words.delete(id);
  }

  Word? getWordById(String id) {
    final map = _words.get(id);
    if (map == null) return null;
    return Word.fromMap(map as Map);
  }

  List<Word> getAllWords() {
    return _words.values
        .map((m) => Word.fromMap(m as Map))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<Word> getWordsByStatus(String status) {
    return _words.values
        .where((m) => (m as Map)['status'] == status)
        .map((m) => Word.fromMap(m as Map))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<Word> getDueWords() {
    final now = DateTime.now();
    return _words.values.where((m) {
      final map = m as Map;
      final status = map['status'] as String? ?? 'active';
      if (status == 'achieved') return false;
      final nextReview = map['nextReviewAt'] != null
          ? DateTime.parse(map['nextReviewAt'] as String)
          : null;
      return nextReview == null || nextReview.isBefore(now);
    }).map((m) => Word.fromMap(m as Map)).toList()
      ..sort((a, b) {
        if (a.nextReviewAt == null) return -1;
        if (b.nextReviewAt == null) return 1;
        return a.nextReviewAt!.compareTo(b.nextReviewAt!);
      });
  }

  Future<void> addReview({required String wordId, required int quality}) async {
    final id = _uuid.v4();
    await _reviewLogs.put(id, {
      'id': id,
      'wordId': wordId,
      'quality': quality,
      'reviewedAt': DateTime.now().toIso8601String(),
    });
  }

  Stream<List<Word>> watchAllWords() async* {
    yield getAllWords();
    await for (final _ in _words.watch()) {
      yield getAllWords();
    }
  }

  Stream<List<Word>> watchWordsByStatus(String status) async* {
    yield getWordsByStatus(status);
    await for (final _ in _words.watch()) {
      yield getWordsByStatus(status);
    }
  }

  Stream<List<Word>> watchDueWords() async* {
    yield getDueWords();
    await for (final _ in _words.watch()) {
      yield getDueWords();
    }
  }
}
