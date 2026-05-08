enum AIProviderType { anthropic, openai, gemini }

extension AIProviderTypeLabel on AIProviderType {
  String get label {
    switch (this) {
      case AIProviderType.anthropic:
        return 'Anthropic (Claude)';
      case AIProviderType.openai:
        return 'OpenAI (GPT-4)';
      case AIProviderType.gemini:
        return 'Google (Gemini)';
    }
  }

  String get keyHint {
    switch (this) {
      case AIProviderType.anthropic:
        return 'sk-ant-...';
      case AIProviderType.openai:
        return 'sk-...';
      case AIProviderType.gemini:
        return 'AIza...';
    }
  }
}

class WordSuggestion {
  final String word;
  final String context;
  WordSuggestion({required this.word, required this.context});
}

class WordInfo {
  final String word;
  final String? type;
  final String? pronunciation;
  final String? meaning;
  final String? usageExample;
  final String? synonym;

  WordInfo({
    required this.word,
    this.type,
    this.pronunciation,
    this.meaning,
    this.usageExample,
    this.synonym,
  });

  factory WordInfo.fromJson(Map<String, dynamic> json) => WordInfo(
        word: (json['word'] as String?) ?? '',
        type: json['type'] as String?,
        pronunciation: json['pronunciation'] as String?,
        meaning: json['meaning'] as String?,
        usageExample: (json['usage_example'] ?? json['usageExample']) as String?,
        synonym: json['synonym'] as String?,
      );
}

abstract class AIProvider {
  Future<List<WordSuggestion>> extractWords(String text);
  Future<WordInfo> enrichWord(String word);
  Future<bool> testConnection();
}
