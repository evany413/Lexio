import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../models/word.dart';

class CSVService {
  static const _headers = [
    'word',
    'type',
    'pronunciation',
    'meaning',
    'usage_example',
    'synonym',
    'status',
  ];

  static Future<String?> exportWords(List<Word> words) async {
    final rows = [
      _headers,
      ...words.map((w) => [
            w.word,
            w.type ?? '',
            w.pronunciation ?? '',
            w.meaning ?? '',
            w.usageExample ?? '',
            w.synonym ?? '',
            w.status,
          ]),
    ];

    final csv = const ListToCsvConverter().convert(rows);

    String? outputPath;

    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Export vocabulary',
        fileName: 'lexio_words.csv',
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );
    } else {
      final dir = await getApplicationDocumentsDirectory();
      outputPath =
          '${dir.path}/lexio_words_${DateTime.now().millisecondsSinceEpoch}.csv';
    }

    if (outputPath == null) return null;
    await File(outputPath).writeAsString(csv);
    return outputPath;
  }

  static Future<List<Map<String, String>>> importWords() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      dialogTitle: 'Import vocabulary CSV',
    );

    if (result == null || result.files.isEmpty) return [];

    final path = result.files.single.path;
    if (path == null) return [];

    final content = await File(path).readAsString();
    final rows = const CsvToListConverter(eol: '\n').convert(content);

    if (rows.length < 2) return [];

    final headerRow = rows.first.map((e) => e.toString().trim()).toList();
    return rows.skip(1).map((row) {
      final map = <String, String>{};
      for (var i = 0; i < headerRow.length && i < row.length; i++) {
        map[headerRow[i]] = row[i].toString().trim();
      }
      return map;
    }).toList();
  }
}
