import 'package:drift/drift.dart';
import 'package:drift/web.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'tables.dart';
import 'daos/word_dao.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Words, ReviewLogs], daos: [WordDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    if (kIsWeb) {
      return WebDatabase('lexio_db');
    }
    return driftDatabase(name: 'lexio_db');
  }
}
