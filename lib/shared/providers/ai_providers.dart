import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/services/ai/ai_provider.dart';
import '../../core/services/ai/anthropic_service.dart';
import '../../core/services/ai/openai_service.dart';
import '../../core/services/ai/gemini_service.dart';

const _kProviderTypeKey = 'ai_provider_type';
const _kApiKeyKey = 'ai_api_key';

const _storage = FlutterSecureStorage(
  aOptions: AndroidOptions(encryptedSharedPreferences: true),
  mOptions: MacOsOptions(useDataProtectionKeyChain: false),
);

class AISettings {
  final AIProviderType type;
  final String apiKey;
  AISettings({required this.type, required this.apiKey});
}

class AISettingsNotifier extends AsyncNotifier<AISettings?> {
  @override
  Future<AISettings?> build() async {
    final typeName = await _storage.read(key: _kProviderTypeKey);
    final key = await _storage.read(key: _kApiKeyKey);
    if (typeName == null || key == null || key.isEmpty) return null;

    final type = AIProviderType.values.firstWhere(
      (e) => e.name == typeName,
      orElse: () => AIProviderType.openai,
    );
    return AISettings(type: type, apiKey: key);
  }

  Future<void> save(AIProviderType type, String apiKey) async {
    await _storage.write(key: _kProviderTypeKey, value: type.name);
    await _storage.write(key: _kApiKeyKey, value: apiKey);
    ref.invalidateSelf();
  }

  Future<void> clear() async {
    await _storage.delete(key: _kProviderTypeKey);
    await _storage.delete(key: _kApiKeyKey);
    ref.invalidateSelf();
  }
}

final aiSettingsProvider =
    AsyncNotifierProvider<AISettingsNotifier, AISettings?>(
  AISettingsNotifier.new,
);

final aiServiceProvider = Provider<AIProvider?>((ref) {
  final settings = ref.watch(aiSettingsProvider).valueOrNull;
  if (settings == null) return null;

  switch (settings.type) {
    case AIProviderType.anthropic:
      return AnthropicService(settings.apiKey);
    case AIProviderType.openai:
      return OpenAIService(settings.apiKey);
    case AIProviderType.gemini:
      return GeminiService(settings.apiKey);
  }
});
