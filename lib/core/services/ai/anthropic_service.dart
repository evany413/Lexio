import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'ai_provider.dart';

const _extractPrompt = '''You are an English vocabulary teacher. Extract 5-10 words from the following text that are worth learning (intermediate to advanced level, not common everyday words). Return ONLY a JSON array with no markdown, like: [{"word":"ephemeral","context":"the sentence from the text"}]''';

const _enrichPrompt = '''Provide vocabulary information for the English word. Return ONLY a JSON object with no markdown: {"word":"...","type":"noun/verb/adjective/adverb/etc","pronunciation":"/IPA/","meaning":"clear definition","usage_example":"one example sentence","synonym":"word1, word2"}''';

class AnthropicService implements AIProvider {
  final Dio _dio;

  AnthropicService(String apiKey)
      : _dio = Dio(BaseOptions(
          baseUrl: 'https://api.anthropic.com',
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 60),
          headers: {
            'x-api-key': apiKey,
            'anthropic-version': '2023-06-01',
            'content-type': 'application/json',
          },
        ));

  Future<String> _message(String prompt) async {
    try {
      final res = await _dio.post('/v1/messages', data: {
        'model': 'claude-opus-4-7',
        'max_tokens': 1024,
        'messages': [
          {'role': 'user', 'content': prompt}
        ],
      });
      return res.data['content'][0]['text'] as String;
    } catch (e, st) {
      debugPrint('[AnthropicService] Error: $e');
      debugPrint('[AnthropicService] Stack: $st');
      rethrow;
    }
  }

  @override
  Future<List<WordSuggestion>> extractWords(String text) async {
    final raw = await _message('$_extractPrompt\n\nText: "$text"');
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
    final raw = await _message('$_enrichPrompt\n\nWord: "$word"');
    final cleaned = raw.trim().replaceAll(RegExp(r'^```json|```$', multiLine: true), '').trim();
    return WordInfo.fromJson(jsonDecode(cleaned) as Map<String, dynamic>);
  }

  @override
  Future<bool> testConnection() async {
    try {
      await _message('Reply with the single word "ok".');
      return true;
    } catch (_) {
      return false;
    }
  }
}
