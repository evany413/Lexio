import 'package:drift/drift.dart';

class Words extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get word => text()();
  TextColumn get type => text().nullable()();
  TextColumn get pronunciation => text().nullable()();
  TextColumn get meaning => text().nullable()();
  TextColumn get usageExample => text().named('usage_example').nullable()();
  TextColumn get synonym => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  DateTimeColumn get createdAt =>
      dateTime().named('created_at').withDefault(currentDateAndTime)();
  DateTimeColumn get nextReviewAt => dateTime().named('next_review_at').nullable()();
  RealColumn get intervalDays =>
      real().named('interval_days').withDefault(const Constant(1.0))();
  RealColumn get easeFactor =>
      real().named('ease_factor').withDefault(const Constant(2.5))();
  IntColumn get repetitions => integer().withDefault(const Constant(0))();
}

class ReviewLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get wordId =>
      integer().named('word_id').references(Words, #id)();
  IntColumn get quality => integer()();
  DateTimeColumn get reviewedAt =>
      dateTime().named('reviewed_at').withDefault(currentDateAndTime)();
}
