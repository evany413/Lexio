const _unset = Object();

class Word {
  final String id;
  final String word;
  final String? type;
  final String? pronunciation;
  final String? meaning;
  final String? usageExample;
  final String? synonym;
  final String status;
  final DateTime createdAt;
  final DateTime? nextReviewAt;
  final double intervalDays;
  final double easeFactor;
  final int repetitions;

  const Word({
    required this.id,
    required this.word,
    this.type,
    this.pronunciation,
    this.meaning,
    this.usageExample,
    this.synonym,
    this.status = 'active',
    required this.createdAt,
    this.nextReviewAt,
    this.intervalDays = 1.0,
    this.easeFactor = 2.5,
    this.repetitions = 0,
  });

  Word copyWith({
    String? word,
    Object? type = _unset,
    Object? pronunciation = _unset,
    Object? meaning = _unset,
    Object? usageExample = _unset,
    Object? synonym = _unset,
    String? status,
    DateTime? createdAt,
    Object? nextReviewAt = _unset,
    double? intervalDays,
    double? easeFactor,
    int? repetitions,
  }) {
    return Word(
      id: id,
      word: word ?? this.word,
      type: identical(type, _unset) ? this.type : type as String?,
      pronunciation: identical(pronunciation, _unset) ? this.pronunciation : pronunciation as String?,
      meaning: identical(meaning, _unset) ? this.meaning : meaning as String?,
      usageExample: identical(usageExample, _unset) ? this.usageExample : usageExample as String?,
      synonym: identical(synonym, _unset) ? this.synonym : synonym as String?,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      nextReviewAt: identical(nextReviewAt, _unset) ? this.nextReviewAt : nextReviewAt as DateTime?,
      intervalDays: intervalDays ?? this.intervalDays,
      easeFactor: easeFactor ?? this.easeFactor,
      repetitions: repetitions ?? this.repetitions,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'word': word,
        'type': type,
        'pronunciation': pronunciation,
        'meaning': meaning,
        'usageExample': usageExample,
        'synonym': synonym,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
        'nextReviewAt': nextReviewAt?.toIso8601String(),
        'intervalDays': intervalDays,
        'easeFactor': easeFactor,
        'repetitions': repetitions,
      };

  factory Word.fromMap(Map map) => Word(
        id: map['id'] as String,
        word: map['word'] as String,
        type: map['type'] as String?,
        pronunciation: map['pronunciation'] as String?,
        meaning: map['meaning'] as String?,
        usageExample: map['usageExample'] as String?,
        synonym: map['synonym'] as String?,
        status: map['status'] as String? ?? 'active',
        createdAt: DateTime.parse(map['createdAt'] as String),
        nextReviewAt: map['nextReviewAt'] != null
            ? DateTime.parse(map['nextReviewAt'] as String)
            : null,
        intervalDays: (map['intervalDays'] as num?)?.toDouble() ?? 1.0,
        easeFactor: (map['easeFactor'] as num?)?.toDouble() ?? 2.5,
        repetitions: map['repetitions'] as int? ?? 0,
      );
}
