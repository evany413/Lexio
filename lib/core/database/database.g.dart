// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $WordsTable extends Words with TableInfo<$WordsTable, Word> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _wordMeta = const VerificationMeta('word');
  @override
  late final GeneratedColumn<String> word = GeneratedColumn<String>(
      'word', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pronunciationMeta =
      const VerificationMeta('pronunciation');
  @override
  late final GeneratedColumn<String> pronunciation = GeneratedColumn<String>(
      'pronunciation', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _meaningMeta =
      const VerificationMeta('meaning');
  @override
  late final GeneratedColumn<String> meaning = GeneratedColumn<String>(
      'meaning', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _usageExampleMeta =
      const VerificationMeta('usageExample');
  @override
  late final GeneratedColumn<String> usageExample = GeneratedColumn<String>(
      'usage_example', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _synonymMeta =
      const VerificationMeta('synonym');
  @override
  late final GeneratedColumn<String> synonym = GeneratedColumn<String>(
      'synonym', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('active'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _nextReviewAtMeta =
      const VerificationMeta('nextReviewAt');
  @override
  late final GeneratedColumn<DateTime> nextReviewAt = GeneratedColumn<DateTime>(
      'next_review_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _intervalDaysMeta =
      const VerificationMeta('intervalDays');
  @override
  late final GeneratedColumn<double> intervalDays = GeneratedColumn<double>(
      'interval_days', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1.0));
  static const VerificationMeta _easeFactorMeta =
      const VerificationMeta('easeFactor');
  @override
  late final GeneratedColumn<double> easeFactor = GeneratedColumn<double>(
      'ease_factor', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(2.5));
  static const VerificationMeta _repetitionsMeta =
      const VerificationMeta('repetitions');
  @override
  late final GeneratedColumn<int> repetitions = GeneratedColumn<int>(
      'repetitions', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        word,
        type,
        pronunciation,
        meaning,
        usageExample,
        synonym,
        status,
        createdAt,
        nextReviewAt,
        intervalDays,
        easeFactor,
        repetitions
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'words';
  @override
  VerificationContext validateIntegrity(Insertable<Word> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('word')) {
      context.handle(
          _wordMeta, word.isAcceptableOrUnknown(data['word']!, _wordMeta));
    } else if (isInserting) {
      context.missing(_wordMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('pronunciation')) {
      context.handle(
          _pronunciationMeta,
          pronunciation.isAcceptableOrUnknown(
              data['pronunciation']!, _pronunciationMeta));
    }
    if (data.containsKey('meaning')) {
      context.handle(_meaningMeta,
          meaning.isAcceptableOrUnknown(data['meaning']!, _meaningMeta));
    }
    if (data.containsKey('usage_example')) {
      context.handle(
          _usageExampleMeta,
          usageExample.isAcceptableOrUnknown(
              data['usage_example']!, _usageExampleMeta));
    }
    if (data.containsKey('synonym')) {
      context.handle(_synonymMeta,
          synonym.isAcceptableOrUnknown(data['synonym']!, _synonymMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('next_review_at')) {
      context.handle(
          _nextReviewAtMeta,
          nextReviewAt.isAcceptableOrUnknown(
              data['next_review_at']!, _nextReviewAtMeta));
    }
    if (data.containsKey('interval_days')) {
      context.handle(
          _intervalDaysMeta,
          intervalDays.isAcceptableOrUnknown(
              data['interval_days']!, _intervalDaysMeta));
    }
    if (data.containsKey('ease_factor')) {
      context.handle(
          _easeFactorMeta,
          easeFactor.isAcceptableOrUnknown(
              data['ease_factor']!, _easeFactorMeta));
    }
    if (data.containsKey('repetitions')) {
      context.handle(
          _repetitionsMeta,
          repetitions.isAcceptableOrUnknown(
              data['repetitions']!, _repetitionsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Word map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Word(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      word: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}word'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type']),
      pronunciation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pronunciation']),
      meaning: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}meaning']),
      usageExample: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}usage_example']),
      synonym: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}synonym']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      nextReviewAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}next_review_at']),
      intervalDays: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}interval_days'])!,
      easeFactor: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}ease_factor'])!,
      repetitions: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}repetitions'])!,
    );
  }

  @override
  $WordsTable createAlias(String alias) {
    return $WordsTable(attachedDatabase, alias);
  }
}

class Word extends DataClass implements Insertable<Word> {
  final int id;
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
  const Word(
      {required this.id,
      required this.word,
      this.type,
      this.pronunciation,
      this.meaning,
      this.usageExample,
      this.synonym,
      required this.status,
      required this.createdAt,
      this.nextReviewAt,
      required this.intervalDays,
      required this.easeFactor,
      required this.repetitions});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['word'] = Variable<String>(word);
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
    }
    if (!nullToAbsent || pronunciation != null) {
      map['pronunciation'] = Variable<String>(pronunciation);
    }
    if (!nullToAbsent || meaning != null) {
      map['meaning'] = Variable<String>(meaning);
    }
    if (!nullToAbsent || usageExample != null) {
      map['usage_example'] = Variable<String>(usageExample);
    }
    if (!nullToAbsent || synonym != null) {
      map['synonym'] = Variable<String>(synonym);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || nextReviewAt != null) {
      map['next_review_at'] = Variable<DateTime>(nextReviewAt);
    }
    map['interval_days'] = Variable<double>(intervalDays);
    map['ease_factor'] = Variable<double>(easeFactor);
    map['repetitions'] = Variable<int>(repetitions);
    return map;
  }

  WordsCompanion toCompanion(bool nullToAbsent) {
    return WordsCompanion(
      id: Value(id),
      word: Value(word),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      pronunciation: pronunciation == null && nullToAbsent
          ? const Value.absent()
          : Value(pronunciation),
      meaning: meaning == null && nullToAbsent
          ? const Value.absent()
          : Value(meaning),
      usageExample: usageExample == null && nullToAbsent
          ? const Value.absent()
          : Value(usageExample),
      synonym: synonym == null && nullToAbsent
          ? const Value.absent()
          : Value(synonym),
      status: Value(status),
      createdAt: Value(createdAt),
      nextReviewAt: nextReviewAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextReviewAt),
      intervalDays: Value(intervalDays),
      easeFactor: Value(easeFactor),
      repetitions: Value(repetitions),
    );
  }

  factory Word.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Word(
      id: serializer.fromJson<int>(json['id']),
      word: serializer.fromJson<String>(json['word']),
      type: serializer.fromJson<String?>(json['type']),
      pronunciation: serializer.fromJson<String?>(json['pronunciation']),
      meaning: serializer.fromJson<String?>(json['meaning']),
      usageExample: serializer.fromJson<String?>(json['usageExample']),
      synonym: serializer.fromJson<String?>(json['synonym']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      nextReviewAt: serializer.fromJson<DateTime?>(json['nextReviewAt']),
      intervalDays: serializer.fromJson<double>(json['intervalDays']),
      easeFactor: serializer.fromJson<double>(json['easeFactor']),
      repetitions: serializer.fromJson<int>(json['repetitions']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'word': serializer.toJson<String>(word),
      'type': serializer.toJson<String?>(type),
      'pronunciation': serializer.toJson<String?>(pronunciation),
      'meaning': serializer.toJson<String?>(meaning),
      'usageExample': serializer.toJson<String?>(usageExample),
      'synonym': serializer.toJson<String?>(synonym),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'nextReviewAt': serializer.toJson<DateTime?>(nextReviewAt),
      'intervalDays': serializer.toJson<double>(intervalDays),
      'easeFactor': serializer.toJson<double>(easeFactor),
      'repetitions': serializer.toJson<int>(repetitions),
    };
  }

  Word copyWith(
          {int? id,
          String? word,
          Value<String?> type = const Value.absent(),
          Value<String?> pronunciation = const Value.absent(),
          Value<String?> meaning = const Value.absent(),
          Value<String?> usageExample = const Value.absent(),
          Value<String?> synonym = const Value.absent(),
          String? status,
          DateTime? createdAt,
          Value<DateTime?> nextReviewAt = const Value.absent(),
          double? intervalDays,
          double? easeFactor,
          int? repetitions}) =>
      Word(
        id: id ?? this.id,
        word: word ?? this.word,
        type: type.present ? type.value : this.type,
        pronunciation:
            pronunciation.present ? pronunciation.value : this.pronunciation,
        meaning: meaning.present ? meaning.value : this.meaning,
        usageExample:
            usageExample.present ? usageExample.value : this.usageExample,
        synonym: synonym.present ? synonym.value : this.synonym,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        nextReviewAt:
            nextReviewAt.present ? nextReviewAt.value : this.nextReviewAt,
        intervalDays: intervalDays ?? this.intervalDays,
        easeFactor: easeFactor ?? this.easeFactor,
        repetitions: repetitions ?? this.repetitions,
      );
  Word copyWithCompanion(WordsCompanion data) {
    return Word(
      id: data.id.present ? data.id.value : this.id,
      word: data.word.present ? data.word.value : this.word,
      type: data.type.present ? data.type.value : this.type,
      pronunciation: data.pronunciation.present
          ? data.pronunciation.value
          : this.pronunciation,
      meaning: data.meaning.present ? data.meaning.value : this.meaning,
      usageExample: data.usageExample.present
          ? data.usageExample.value
          : this.usageExample,
      synonym: data.synonym.present ? data.synonym.value : this.synonym,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      nextReviewAt: data.nextReviewAt.present
          ? data.nextReviewAt.value
          : this.nextReviewAt,
      intervalDays: data.intervalDays.present
          ? data.intervalDays.value
          : this.intervalDays,
      easeFactor:
          data.easeFactor.present ? data.easeFactor.value : this.easeFactor,
      repetitions:
          data.repetitions.present ? data.repetitions.value : this.repetitions,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Word(')
          ..write('id: $id, ')
          ..write('word: $word, ')
          ..write('type: $type, ')
          ..write('pronunciation: $pronunciation, ')
          ..write('meaning: $meaning, ')
          ..write('usageExample: $usageExample, ')
          ..write('synonym: $synonym, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('nextReviewAt: $nextReviewAt, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('repetitions: $repetitions')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      word,
      type,
      pronunciation,
      meaning,
      usageExample,
      synonym,
      status,
      createdAt,
      nextReviewAt,
      intervalDays,
      easeFactor,
      repetitions);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Word &&
          other.id == this.id &&
          other.word == this.word &&
          other.type == this.type &&
          other.pronunciation == this.pronunciation &&
          other.meaning == this.meaning &&
          other.usageExample == this.usageExample &&
          other.synonym == this.synonym &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.nextReviewAt == this.nextReviewAt &&
          other.intervalDays == this.intervalDays &&
          other.easeFactor == this.easeFactor &&
          other.repetitions == this.repetitions);
}

class WordsCompanion extends UpdateCompanion<Word> {
  final Value<int> id;
  final Value<String> word;
  final Value<String?> type;
  final Value<String?> pronunciation;
  final Value<String?> meaning;
  final Value<String?> usageExample;
  final Value<String?> synonym;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime?> nextReviewAt;
  final Value<double> intervalDays;
  final Value<double> easeFactor;
  final Value<int> repetitions;
  const WordsCompanion({
    this.id = const Value.absent(),
    this.word = const Value.absent(),
    this.type = const Value.absent(),
    this.pronunciation = const Value.absent(),
    this.meaning = const Value.absent(),
    this.usageExample = const Value.absent(),
    this.synonym = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.nextReviewAt = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.easeFactor = const Value.absent(),
    this.repetitions = const Value.absent(),
  });
  WordsCompanion.insert({
    this.id = const Value.absent(),
    required String word,
    this.type = const Value.absent(),
    this.pronunciation = const Value.absent(),
    this.meaning = const Value.absent(),
    this.usageExample = const Value.absent(),
    this.synonym = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.nextReviewAt = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.easeFactor = const Value.absent(),
    this.repetitions = const Value.absent(),
  }) : word = Value(word);
  static Insertable<Word> custom({
    Expression<int>? id,
    Expression<String>? word,
    Expression<String>? type,
    Expression<String>? pronunciation,
    Expression<String>? meaning,
    Expression<String>? usageExample,
    Expression<String>? synonym,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? nextReviewAt,
    Expression<double>? intervalDays,
    Expression<double>? easeFactor,
    Expression<int>? repetitions,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (word != null) 'word': word,
      if (type != null) 'type': type,
      if (pronunciation != null) 'pronunciation': pronunciation,
      if (meaning != null) 'meaning': meaning,
      if (usageExample != null) 'usage_example': usageExample,
      if (synonym != null) 'synonym': synonym,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (nextReviewAt != null) 'next_review_at': nextReviewAt,
      if (intervalDays != null) 'interval_days': intervalDays,
      if (easeFactor != null) 'ease_factor': easeFactor,
      if (repetitions != null) 'repetitions': repetitions,
    });
  }

  WordsCompanion copyWith(
      {Value<int>? id,
      Value<String>? word,
      Value<String?>? type,
      Value<String?>? pronunciation,
      Value<String?>? meaning,
      Value<String?>? usageExample,
      Value<String?>? synonym,
      Value<String>? status,
      Value<DateTime>? createdAt,
      Value<DateTime?>? nextReviewAt,
      Value<double>? intervalDays,
      Value<double>? easeFactor,
      Value<int>? repetitions}) {
    return WordsCompanion(
      id: id ?? this.id,
      word: word ?? this.word,
      type: type ?? this.type,
      pronunciation: pronunciation ?? this.pronunciation,
      meaning: meaning ?? this.meaning,
      usageExample: usageExample ?? this.usageExample,
      synonym: synonym ?? this.synonym,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      nextReviewAt: nextReviewAt ?? this.nextReviewAt,
      intervalDays: intervalDays ?? this.intervalDays,
      easeFactor: easeFactor ?? this.easeFactor,
      repetitions: repetitions ?? this.repetitions,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (word.present) {
      map['word'] = Variable<String>(word.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (pronunciation.present) {
      map['pronunciation'] = Variable<String>(pronunciation.value);
    }
    if (meaning.present) {
      map['meaning'] = Variable<String>(meaning.value);
    }
    if (usageExample.present) {
      map['usage_example'] = Variable<String>(usageExample.value);
    }
    if (synonym.present) {
      map['synonym'] = Variable<String>(synonym.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (nextReviewAt.present) {
      map['next_review_at'] = Variable<DateTime>(nextReviewAt.value);
    }
    if (intervalDays.present) {
      map['interval_days'] = Variable<double>(intervalDays.value);
    }
    if (easeFactor.present) {
      map['ease_factor'] = Variable<double>(easeFactor.value);
    }
    if (repetitions.present) {
      map['repetitions'] = Variable<int>(repetitions.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WordsCompanion(')
          ..write('id: $id, ')
          ..write('word: $word, ')
          ..write('type: $type, ')
          ..write('pronunciation: $pronunciation, ')
          ..write('meaning: $meaning, ')
          ..write('usageExample: $usageExample, ')
          ..write('synonym: $synonym, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('nextReviewAt: $nextReviewAt, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('repetitions: $repetitions')
          ..write(')'))
        .toString();
  }
}

class $ReviewLogsTable extends ReviewLogs
    with TableInfo<$ReviewLogsTable, ReviewLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReviewLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<int> wordId = GeneratedColumn<int>(
      'word_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES words (id)'));
  static const VerificationMeta _qualityMeta =
      const VerificationMeta('quality');
  @override
  late final GeneratedColumn<int> quality = GeneratedColumn<int>(
      'quality', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _reviewedAtMeta =
      const VerificationMeta('reviewedAt');
  @override
  late final GeneratedColumn<DateTime> reviewedAt = GeneratedColumn<DateTime>(
      'reviewed_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, wordId, quality, reviewedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'review_logs';
  @override
  VerificationContext validateIntegrity(Insertable<ReviewLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('word_id')) {
      context.handle(_wordIdMeta,
          wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta));
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('quality')) {
      context.handle(_qualityMeta,
          quality.isAcceptableOrUnknown(data['quality']!, _qualityMeta));
    } else if (isInserting) {
      context.missing(_qualityMeta);
    }
    if (data.containsKey('reviewed_at')) {
      context.handle(
          _reviewedAtMeta,
          reviewedAt.isAcceptableOrUnknown(
              data['reviewed_at']!, _reviewedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReviewLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReviewLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      wordId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}word_id'])!,
      quality: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quality'])!,
      reviewedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}reviewed_at'])!,
    );
  }

  @override
  $ReviewLogsTable createAlias(String alias) {
    return $ReviewLogsTable(attachedDatabase, alias);
  }
}

class ReviewLog extends DataClass implements Insertable<ReviewLog> {
  final int id;
  final int wordId;
  final int quality;
  final DateTime reviewedAt;
  const ReviewLog(
      {required this.id,
      required this.wordId,
      required this.quality,
      required this.reviewedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['word_id'] = Variable<int>(wordId);
    map['quality'] = Variable<int>(quality);
    map['reviewed_at'] = Variable<DateTime>(reviewedAt);
    return map;
  }

  ReviewLogsCompanion toCompanion(bool nullToAbsent) {
    return ReviewLogsCompanion(
      id: Value(id),
      wordId: Value(wordId),
      quality: Value(quality),
      reviewedAt: Value(reviewedAt),
    );
  }

  factory ReviewLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReviewLog(
      id: serializer.fromJson<int>(json['id']),
      wordId: serializer.fromJson<int>(json['wordId']),
      quality: serializer.fromJson<int>(json['quality']),
      reviewedAt: serializer.fromJson<DateTime>(json['reviewedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'wordId': serializer.toJson<int>(wordId),
      'quality': serializer.toJson<int>(quality),
      'reviewedAt': serializer.toJson<DateTime>(reviewedAt),
    };
  }

  ReviewLog copyWith(
          {int? id, int? wordId, int? quality, DateTime? reviewedAt}) =>
      ReviewLog(
        id: id ?? this.id,
        wordId: wordId ?? this.wordId,
        quality: quality ?? this.quality,
        reviewedAt: reviewedAt ?? this.reviewedAt,
      );
  ReviewLog copyWithCompanion(ReviewLogsCompanion data) {
    return ReviewLog(
      id: data.id.present ? data.id.value : this.id,
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      quality: data.quality.present ? data.quality.value : this.quality,
      reviewedAt:
          data.reviewedAt.present ? data.reviewedAt.value : this.reviewedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReviewLog(')
          ..write('id: $id, ')
          ..write('wordId: $wordId, ')
          ..write('quality: $quality, ')
          ..write('reviewedAt: $reviewedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, wordId, quality, reviewedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReviewLog &&
          other.id == this.id &&
          other.wordId == this.wordId &&
          other.quality == this.quality &&
          other.reviewedAt == this.reviewedAt);
}

class ReviewLogsCompanion extends UpdateCompanion<ReviewLog> {
  final Value<int> id;
  final Value<int> wordId;
  final Value<int> quality;
  final Value<DateTime> reviewedAt;
  const ReviewLogsCompanion({
    this.id = const Value.absent(),
    this.wordId = const Value.absent(),
    this.quality = const Value.absent(),
    this.reviewedAt = const Value.absent(),
  });
  ReviewLogsCompanion.insert({
    this.id = const Value.absent(),
    required int wordId,
    required int quality,
    this.reviewedAt = const Value.absent(),
  })  : wordId = Value(wordId),
        quality = Value(quality);
  static Insertable<ReviewLog> custom({
    Expression<int>? id,
    Expression<int>? wordId,
    Expression<int>? quality,
    Expression<DateTime>? reviewedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (wordId != null) 'word_id': wordId,
      if (quality != null) 'quality': quality,
      if (reviewedAt != null) 'reviewed_at': reviewedAt,
    });
  }

  ReviewLogsCompanion copyWith(
      {Value<int>? id,
      Value<int>? wordId,
      Value<int>? quality,
      Value<DateTime>? reviewedAt}) {
    return ReviewLogsCompanion(
      id: id ?? this.id,
      wordId: wordId ?? this.wordId,
      quality: quality ?? this.quality,
      reviewedAt: reviewedAt ?? this.reviewedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (wordId.present) {
      map['word_id'] = Variable<int>(wordId.value);
    }
    if (quality.present) {
      map['quality'] = Variable<int>(quality.value);
    }
    if (reviewedAt.present) {
      map['reviewed_at'] = Variable<DateTime>(reviewedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewLogsCompanion(')
          ..write('id: $id, ')
          ..write('wordId: $wordId, ')
          ..write('quality: $quality, ')
          ..write('reviewedAt: $reviewedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WordsTable words = $WordsTable(this);
  late final $ReviewLogsTable reviewLogs = $ReviewLogsTable(this);
  late final WordDao wordDao = WordDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [words, reviewLogs];
}

typedef $$WordsTableCreateCompanionBuilder = WordsCompanion Function({
  Value<int> id,
  required String word,
  Value<String?> type,
  Value<String?> pronunciation,
  Value<String?> meaning,
  Value<String?> usageExample,
  Value<String?> synonym,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<DateTime?> nextReviewAt,
  Value<double> intervalDays,
  Value<double> easeFactor,
  Value<int> repetitions,
});
typedef $$WordsTableUpdateCompanionBuilder = WordsCompanion Function({
  Value<int> id,
  Value<String> word,
  Value<String?> type,
  Value<String?> pronunciation,
  Value<String?> meaning,
  Value<String?> usageExample,
  Value<String?> synonym,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<DateTime?> nextReviewAt,
  Value<double> intervalDays,
  Value<double> easeFactor,
  Value<int> repetitions,
});

final class $$WordsTableReferences
    extends BaseReferences<_$AppDatabase, $WordsTable, Word> {
  $$WordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ReviewLogsTable, List<ReviewLog>>
      _reviewLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.reviewLogs,
          aliasName: $_aliasNameGenerator(db.words.id, db.reviewLogs.wordId));

  $$ReviewLogsTableProcessedTableManager get reviewLogsRefs {
    final manager = $$ReviewLogsTableTableManager($_db, $_db.reviewLogs)
        .filter((f) => f.wordId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_reviewLogsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$WordsTableFilterComposer extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get word => $composableBuilder(
      column: $table.word, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pronunciation => $composableBuilder(
      column: $table.pronunciation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get meaning => $composableBuilder(
      column: $table.meaning, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get usageExample => $composableBuilder(
      column: $table.usageExample, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get synonym => $composableBuilder(
      column: $table.synonym, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextReviewAt => $composableBuilder(
      column: $table.nextReviewAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get intervalDays => $composableBuilder(
      column: $table.intervalDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get easeFactor => $composableBuilder(
      column: $table.easeFactor, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get repetitions => $composableBuilder(
      column: $table.repetitions, builder: (column) => ColumnFilters(column));

  Expression<bool> reviewLogsRefs(
      Expression<bool> Function($$ReviewLogsTableFilterComposer f) f) {
    final $$ReviewLogsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reviewLogs,
        getReferencedColumn: (t) => t.wordId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReviewLogsTableFilterComposer(
              $db: $db,
              $table: $db.reviewLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$WordsTableOrderingComposer
    extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get word => $composableBuilder(
      column: $table.word, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pronunciation => $composableBuilder(
      column: $table.pronunciation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get meaning => $composableBuilder(
      column: $table.meaning, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get usageExample => $composableBuilder(
      column: $table.usageExample,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get synonym => $composableBuilder(
      column: $table.synonym, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextReviewAt => $composableBuilder(
      column: $table.nextReviewAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get intervalDays => $composableBuilder(
      column: $table.intervalDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get easeFactor => $composableBuilder(
      column: $table.easeFactor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get repetitions => $composableBuilder(
      column: $table.repetitions, builder: (column) => ColumnOrderings(column));
}

class $$WordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get word =>
      $composableBuilder(column: $table.word, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get pronunciation => $composableBuilder(
      column: $table.pronunciation, builder: (column) => column);

  GeneratedColumn<String> get meaning =>
      $composableBuilder(column: $table.meaning, builder: (column) => column);

  GeneratedColumn<String> get usageExample => $composableBuilder(
      column: $table.usageExample, builder: (column) => column);

  GeneratedColumn<String> get synonym =>
      $composableBuilder(column: $table.synonym, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get nextReviewAt => $composableBuilder(
      column: $table.nextReviewAt, builder: (column) => column);

  GeneratedColumn<double> get intervalDays => $composableBuilder(
      column: $table.intervalDays, builder: (column) => column);

  GeneratedColumn<double> get easeFactor => $composableBuilder(
      column: $table.easeFactor, builder: (column) => column);

  GeneratedColumn<int> get repetitions => $composableBuilder(
      column: $table.repetitions, builder: (column) => column);

  Expression<T> reviewLogsRefs<T extends Object>(
      Expression<T> Function($$ReviewLogsTableAnnotationComposer a) f) {
    final $$ReviewLogsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reviewLogs,
        getReferencedColumn: (t) => t.wordId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReviewLogsTableAnnotationComposer(
              $db: $db,
              $table: $db.reviewLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$WordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WordsTable,
    Word,
    $$WordsTableFilterComposer,
    $$WordsTableOrderingComposer,
    $$WordsTableAnnotationComposer,
    $$WordsTableCreateCompanionBuilder,
    $$WordsTableUpdateCompanionBuilder,
    (Word, $$WordsTableReferences),
    Word,
    PrefetchHooks Function({bool reviewLogsRefs})> {
  $$WordsTableTableManager(_$AppDatabase db, $WordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> word = const Value.absent(),
            Value<String?> type = const Value.absent(),
            Value<String?> pronunciation = const Value.absent(),
            Value<String?> meaning = const Value.absent(),
            Value<String?> usageExample = const Value.absent(),
            Value<String?> synonym = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> nextReviewAt = const Value.absent(),
            Value<double> intervalDays = const Value.absent(),
            Value<double> easeFactor = const Value.absent(),
            Value<int> repetitions = const Value.absent(),
          }) =>
              WordsCompanion(
            id: id,
            word: word,
            type: type,
            pronunciation: pronunciation,
            meaning: meaning,
            usageExample: usageExample,
            synonym: synonym,
            status: status,
            createdAt: createdAt,
            nextReviewAt: nextReviewAt,
            intervalDays: intervalDays,
            easeFactor: easeFactor,
            repetitions: repetitions,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String word,
            Value<String?> type = const Value.absent(),
            Value<String?> pronunciation = const Value.absent(),
            Value<String?> meaning = const Value.absent(),
            Value<String?> usageExample = const Value.absent(),
            Value<String?> synonym = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> nextReviewAt = const Value.absent(),
            Value<double> intervalDays = const Value.absent(),
            Value<double> easeFactor = const Value.absent(),
            Value<int> repetitions = const Value.absent(),
          }) =>
              WordsCompanion.insert(
            id: id,
            word: word,
            type: type,
            pronunciation: pronunciation,
            meaning: meaning,
            usageExample: usageExample,
            synonym: synonym,
            status: status,
            createdAt: createdAt,
            nextReviewAt: nextReviewAt,
            intervalDays: intervalDays,
            easeFactor: easeFactor,
            repetitions: repetitions,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$WordsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({reviewLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (reviewLogsRefs) db.reviewLogs],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (reviewLogsRefs)
                    await $_getPrefetchedData<Word, $WordsTable, ReviewLog>(
                        currentTable: table,
                        referencedTable:
                            $$WordsTableReferences._reviewLogsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WordsTableReferences(db, table, p0)
                                .reviewLogsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.wordId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$WordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WordsTable,
    Word,
    $$WordsTableFilterComposer,
    $$WordsTableOrderingComposer,
    $$WordsTableAnnotationComposer,
    $$WordsTableCreateCompanionBuilder,
    $$WordsTableUpdateCompanionBuilder,
    (Word, $$WordsTableReferences),
    Word,
    PrefetchHooks Function({bool reviewLogsRefs})>;
typedef $$ReviewLogsTableCreateCompanionBuilder = ReviewLogsCompanion Function({
  Value<int> id,
  required int wordId,
  required int quality,
  Value<DateTime> reviewedAt,
});
typedef $$ReviewLogsTableUpdateCompanionBuilder = ReviewLogsCompanion Function({
  Value<int> id,
  Value<int> wordId,
  Value<int> quality,
  Value<DateTime> reviewedAt,
});

final class $$ReviewLogsTableReferences
    extends BaseReferences<_$AppDatabase, $ReviewLogsTable, ReviewLog> {
  $$ReviewLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WordsTable _wordIdTable(_$AppDatabase db) => db.words
      .createAlias($_aliasNameGenerator(db.reviewLogs.wordId, db.words.id));

  $$WordsTableProcessedTableManager get wordId {
    final $_column = $_itemColumn<int>('word_id')!;

    final manager = $$WordsTableTableManager($_db, $_db.words)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_wordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ReviewLogsTableFilterComposer
    extends Composer<_$AppDatabase, $ReviewLogsTable> {
  $$ReviewLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quality => $composableBuilder(
      column: $table.quality, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get reviewedAt => $composableBuilder(
      column: $table.reviewedAt, builder: (column) => ColumnFilters(column));

  $$WordsTableFilterComposer get wordId {
    final $$WordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.wordId,
        referencedTable: $db.words,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WordsTableFilterComposer(
              $db: $db,
              $table: $db.words,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReviewLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReviewLogsTable> {
  $$ReviewLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quality => $composableBuilder(
      column: $table.quality, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get reviewedAt => $composableBuilder(
      column: $table.reviewedAt, builder: (column) => ColumnOrderings(column));

  $$WordsTableOrderingComposer get wordId {
    final $$WordsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.wordId,
        referencedTable: $db.words,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WordsTableOrderingComposer(
              $db: $db,
              $table: $db.words,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReviewLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReviewLogsTable> {
  $$ReviewLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quality =>
      $composableBuilder(column: $table.quality, builder: (column) => column);

  GeneratedColumn<DateTime> get reviewedAt => $composableBuilder(
      column: $table.reviewedAt, builder: (column) => column);

  $$WordsTableAnnotationComposer get wordId {
    final $$WordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.wordId,
        referencedTable: $db.words,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WordsTableAnnotationComposer(
              $db: $db,
              $table: $db.words,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReviewLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReviewLogsTable,
    ReviewLog,
    $$ReviewLogsTableFilterComposer,
    $$ReviewLogsTableOrderingComposer,
    $$ReviewLogsTableAnnotationComposer,
    $$ReviewLogsTableCreateCompanionBuilder,
    $$ReviewLogsTableUpdateCompanionBuilder,
    (ReviewLog, $$ReviewLogsTableReferences),
    ReviewLog,
    PrefetchHooks Function({bool wordId})> {
  $$ReviewLogsTableTableManager(_$AppDatabase db, $ReviewLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReviewLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReviewLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReviewLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> wordId = const Value.absent(),
            Value<int> quality = const Value.absent(),
            Value<DateTime> reviewedAt = const Value.absent(),
          }) =>
              ReviewLogsCompanion(
            id: id,
            wordId: wordId,
            quality: quality,
            reviewedAt: reviewedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int wordId,
            required int quality,
            Value<DateTime> reviewedAt = const Value.absent(),
          }) =>
              ReviewLogsCompanion.insert(
            id: id,
            wordId: wordId,
            quality: quality,
            reviewedAt: reviewedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ReviewLogsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({wordId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (wordId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.wordId,
                    referencedTable:
                        $$ReviewLogsTableReferences._wordIdTable(db),
                    referencedColumn:
                        $$ReviewLogsTableReferences._wordIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ReviewLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ReviewLogsTable,
    ReviewLog,
    $$ReviewLogsTableFilterComposer,
    $$ReviewLogsTableOrderingComposer,
    $$ReviewLogsTableAnnotationComposer,
    $$ReviewLogsTableCreateCompanionBuilder,
    $$ReviewLogsTableUpdateCompanionBuilder,
    (ReviewLog, $$ReviewLogsTableReferences),
    ReviewLog,
    PrefetchHooks Function({bool wordId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WordsTableTableManager get words =>
      $$WordsTableTableManager(_db, _db.words);
  $$ReviewLogsTableTableManager get reviewLogs =>
      $$ReviewLogsTableTableManager(_db, _db.reviewLogs);
}
