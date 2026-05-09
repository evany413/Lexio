import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/ai/ai_provider.dart';
import '../../shared/providers/ai_providers.dart';
import '../../shared/providers/database_providers.dart';

class WordInputScreen extends ConsumerStatefulWidget {
  const WordInputScreen({super.key});

  @override
  ConsumerState<WordInputScreen> createState() => _WordInputScreenState();
}

class _WordInputScreenState extends ConsumerState<WordInputScreen> {
  final _textController = TextEditingController();
  bool _analyzing = false;
  bool _enriching = false;
  List<_WordEntry> _suggestions = [];
  String? _error;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _analyze() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final ai = ref.read(aiServiceProvider);
    if (ai == null) {
      setState(() => _error = 'AI service not configured.');
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _analyzing = true;
      _suggestions = [];
      _error = null;
    });

    try {
      final suggestions = await ai.extractWords(text);
      setState(() {
        _suggestions = suggestions
            .map((s) => _WordEntry(suggestion: s, selected: true))
            .toList();
        _analyzing = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Analysis failed: $e';
        _analyzing = false;
      });
    }
  }

  Future<void> _addSelected() async {
    final selected = _suggestions.where((e) => e.selected).toList();
    if (selected.isEmpty) return;

    final ai = ref.read(aiServiceProvider);
    if (ai == null) return;

    FocusScope.of(context).unfocus();
    setState(() => _enriching = true);

    int added = 0;
    for (final entry in selected) {
      try {
        final info = await ai.enrichWord(entry.suggestion.word);
        await insertWord(
          ref,
          word: info.word.isEmpty ? entry.suggestion.word : info.word,
          type: info.type,
          pronunciation: info.pronunciation,
          meaning: info.meaning,
          usageExample: info.usageExample,
          synonym: info.synonym,
          nextReviewAt: DateTime.now().add(const Duration(days: 1)),
        );
        added++;
      } catch (_) {
        await insertWord(
          ref,
          word: entry.suggestion.word,
          nextReviewAt: DateTime.now().add(const Duration(days: 1)),
        );
        added++;
      }
    }

    if (!mounted) return;
    setState(() {
      _enriching = false;
      _suggestions = [];
      _textController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added $added words to your list')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedCount = _suggestions.where((e) => e.selected).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Add Words')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _textController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText:
                        'Paste a paragraph, article, or sentence here…\nOr type a single word to look it up.',
                    border: const OutlineInputBorder(),
                    filled: true,
                    suffixIcon: _textController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _textController.clear();
                              setState(() => _suggestions = []);
                            },
                          )
                        : null,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: _analyzing ? null : _analyze,
                  icon: _analyzing
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.auto_awesome),
                  label: Text(_analyzing ? 'Analyzing…' : 'Analyze with AI'),
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(_error!,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error)),
                  ),
              ],
            ),
          ),
          if (_suggestions.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Suggested words (${_suggestions.length})',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  TextButton(
                    onPressed: () => setState(() {
                      final allSelected = _suggestions.every((e) => e.selected);
                      for (final e in _suggestions) {
                        e.selected = !allSelected;
                      }
                    }),
                    child: const Text('Toggle All'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _suggestions.length,
                itemBuilder: (_, i) {
                  final entry = _suggestions[i];
                  return Card(
                    child: CheckboxListTile(
                      value: entry.selected,
                      onChanged: (v) =>
                          setState(() => entry.selected = v ?? false),
                      title: Text(
                        entry.suggestion.word,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        entry.suggestion.context,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed:
                      selectedCount == 0 || _enriching ? null : _addSelected,
                  icon: _enriching
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.add),
                  label: Text(_enriching
                      ? 'Adding words…'
                      : 'Add $selectedCount word${selectedCount == 1 ? '' : 's'}'),
                ),
              ),
            ),
          ],
          if (_suggestions.isEmpty && !_analyzing)
            const Expanded(child: _EmptyState()),
        ],
      ),
    );
  }
}

class _WordEntry {
  final WordSuggestion suggestion;
  bool selected;
  _WordEntry({required this.suggestion, required this.selected});
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.text_snippet_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.outlineVariant),
          const SizedBox(height: 16),
          Text('Paste text above and tap Analyze',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  )),
        ],
      ),
    );
  }
}

