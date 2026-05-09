import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/ai/ai_provider.dart';
import '../../core/services/ai/anthropic_service.dart';
import '../../core/services/ai/openai_service.dart';
import '../../core/services/ai/gemini_service.dart';
import '../../shared/providers/ai_providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  AIProviderType _selectedProvider = AIProviderType.openai;
  final _keyController = TextEditingController();
  bool _obscureKey = true;
  bool _testing = false;
  String? _errorMessage;

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  Future<void> _testAndSave() async {
    final apiKey = _keyController.text.trim();
    if (apiKey.isEmpty) {
      setState(() => _errorMessage = 'Please enter your API key.');
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _testing = true;
      _errorMessage = null;
    });

    final AIProvider service;
    switch (_selectedProvider) {
      case AIProviderType.anthropic:
        service = AnthropicService(apiKey);
      case AIProviderType.openai:
        service = OpenAIService(apiKey);
      case AIProviderType.gemini:
        service = GeminiService(apiKey);
    }

    bool ok = false;
    String? errorDetail;
    try {
      ok = await service.testConnection();
    } catch (e) {
      errorDetail = e.toString();
    }
    if (!mounted) return;

    if (!ok) {
      setState(() {
        _testing = false;
        _errorMessage = errorDetail ?? 'Connection failed. Please check your API key.';
      });
      return;
    }

    await ref.read(aiSettingsProvider.notifier).save(_selectedProvider, apiKey);
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.auto_stories, size: 56, color: cs.primary),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome to Lexio',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Connect your AI provider to get started.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: 40),
                  Text('AI Provider',
                      style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 12),
                  _ProviderSelector(
                    selected: _selectedProvider,
                    onChanged: (p) => setState(() => _selectedProvider = p),
                  ),
                  const SizedBox(height: 24),
                  Text('API Key',
                      style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _keyController,
                    obscureText: _obscureKey,
                    decoration: InputDecoration(
                      hintText: _selectedProvider.keyHint,
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureKey
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () =>
                            setState(() => _obscureKey = !_obscureKey),
                      ),
                    ),
                    onSubmitted: (_) => _testAndSave(),
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 8),
                    Text(_errorMessage!,
                        style: TextStyle(color: cs.error)),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: _testing ? null : _testAndSave,
                      icon: _testing
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.check),
                      label: Text(_testing ? 'Testing…' : 'Test & Save'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your API key is stored securely on this device and never sent to our servers.',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: cs.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProviderSelector extends StatelessWidget {
  final AIProviderType selected;
  final ValueChanged<AIProviderType> onChanged;

  const _ProviderSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: AIProviderType.values
          .map((p) => RadioListTile<AIProviderType>(
                value: p,
                groupValue: selected,
                title: Text(p.label),
                contentPadding: EdgeInsets.zero,
                onChanged: (v) => onChanged(v!),
              ))
          .toList(),
    );
  }
}
