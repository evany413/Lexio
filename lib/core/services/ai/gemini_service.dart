import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'ai_provider.dart';

class GeminiService implements AIProvider {
  static const _modelName = 'gemini-3.1-flash-lite';

  final GenerativeModel _model;

  GeminiService(String apiKey)
      : _model = GenerativeModel(
          model: _modelName,
          apiKey: apiKey,
        );

  Future<String> _generate(String prompt) async {
    final response = await _model.generateContent([Content.text(prompt)]);
    return response.text ?? '';
  }

  @override
  Future<List<WordSuggestion>> extractWords(String text) async {
    final raw = await _generate(
      'Extract 5-10 intermediate-to-advanced English words worth learning from this text. '
      'Return ONLY a JSON array, no markdown: [{"word":"...","context":"sentence from text"}]\n\nText: "$text"',
    );
    final cleaned = raw.trim().replaceAll(RegExp(r'^```json|```$', multiLine: true), '').trim();
    final List<dynamic> list = jsonDecode(cleaned);
    return list
        .map((e) => WordSuggestion(
              word: e['word'] as String,
              context: e['context'] as String,
            ))
        .toList();
  }

  @override
  Future<WordInfo> enrichWord(String word) async {
    final raw = await _generate(
      'Provide vocabulary info for the English word "$word". '
      'Return ONLY a JSON object, no markdown: '
      '{"word":"...","type":"noun/verb/adjective/etc","pronunciation":"/IPA/","meaning":"...","usage_example":"...","synonym":"..."}',
    );
    final cleaned = raw.trim().replaceAll(RegExp(r'^```json|```$', multiLine: true), '').trim();
    return WordInfo.fromJson(jsonDecode(cleaned) as Map<String, dynamic>);
  }

  @override
  Future<bool> testConnection() async {
    final response = await _model.generateContent([Content.text('Hello, are you online?')]);
    return (response.text ?? '').isNotEmpty;
  }
}
