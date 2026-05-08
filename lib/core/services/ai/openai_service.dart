import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'ai_provider.dart';

class OpenAIService implements AIProvider {
  final Dio _dio;

  OpenAIService(String apiKey)
      : _dio = Dio(BaseOptions(
          baseUrl: 'https://api.openai.com',
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 60),
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
        ));

  Future<String> _chat(String systemPrompt, String userMessage) async {
    try {
      final res = await _dio.post('/v1/chat/completions', data: {
        'model': 'gpt-4o',
        'response_format': {'type': 'json_object'},
        'messages': [
          {'role': 'system', 'content': systemPrompt},
          {'role': 'user', 'content': userMessage},
        ],
      });
      return res.data['choices'][0]['message']['content'] as String;
    } catch (e, st) {
      debugPrint('[OpenAIService] Error: $e');
      debugPrint('[OpenAIService] Stack: $st');
      rethrow;
    }
  }

  @override
  Future<List<WordSuggestion>> extractWords(String text) async {
    final raw = await _chat(
      'You are an English vocabulary teacher. Always respond with valid JSON.',
      'Extract 5-10 intermediate-to-advanced words worth learning from this text. Return JSON: {"words":[{"word":"...","context":"sentence from text"}]}\n\nText: "$text"',
    );
    final Map<String, dynamic> parsed = jsonDecode(raw);
    final List<dynamic> list = parsed['words'] as List<dynamic>;
    return list
        .map((e) => WordSuggestion(
              word: e['word'] as String,
              context: e['context'] as String,
            ))
        .toList();
  }

  @override
  Future<WordInfo> enrichWord(String word) async {
    final raw = await _chat(
      'You are an English vocabulary expert. Always respond with valid JSON.',
      'Provide vocabulary info for "$word". Return JSON: {"word":"...","type":"...","pronunciation":"/IPA/","meaning":"...","usage_example":"...","synonym":"..."}',
    );
    return WordInfo.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Future<bool> testConnection() async {
    try {
      await _chat('Reply with valid JSON.', 'Return {"status":"ok"}');
      return true;
    } catch (_) {
      return false;
    }
  }
}
