import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/database.dart';
import '../../shared/providers/database_providers.dart';
import '../../shared/providers/ai_providers.dart';

class WordDetailScreen extends ConsumerStatefulWidget {
  final int wordId;
  const WordDetailScreen({super.key, required this.wordId});

  @override
  ConsumerState<WordDetailScreen> createState() => _WordDetailScreenState();
}

class _WordDetailScreenState extends ConsumerState<WordDetailScreen> {
  Word? _word;
  bool _editing = false;
  bool _enriching = false;

  late TextEditingController _wordCtrl;
  late TextEditingController _typeCtrl;
  late TextEditingController _pronCtrl;
  late TextEditingController _meaningCtrl;
  late TextEditingController _usageCtrl;
  late TextEditingController _synonymCtrl;

  @override
  void initState() {
    super.initState();
    _wordCtrl = TextEditingController();
    _typeCtrl = TextEditingController();
    _pronCtrl = TextEditingController();
    _meaningCtrl = TextEditingController();
    _usageCtrl = TextEditingController();
    _synonymCtrl = TextEditingController();
    _loadWord();
  }

  Future<void> _loadWord() async {
    final word = await ref
        .read(databaseProvider)
        .wordDao
        .getWordById(widget.wordId);
    if (mounted && word != null) {
      setState(() {
        _word = word;
        _populate(word);
      });
    }
  }

  void _populate(Word w) {
    _wordCtrl.text = w.word;
    _typeCtrl.text = w.type ?? '';
    _pronCtrl.text = w.pronunciation ?? '';
    _meaningCtrl.text = w.meaning ?? '';
    _usageCtrl.text = w.usageExample ?? '';
    _synonymCtrl.text = w.synonym ?? '';
  }

  Future<void> _save() async {
    if (_word == null) return;
    await ref.read(databaseProvider).wordDao.updateWord(_word!.copyWith(
          word: _wordCtrl.text.trim(),
          type: Value(_typeCtrl.text.trim().isEmpty ? null : _typeCtrl.text.trim()),
          pronunciation: Value(_pronCtrl.text.trim().isEmpty ? null : _pronCtrl.text.trim()),
          meaning: Value(_meaningCtrl.text.trim().isEmpty ? null : _meaningCtrl.text.trim()),
          usageExample: Value(_usageCtrl.text.trim().isEmpty ? null : _usageCtrl.text.trim()),
          synonym: Value(_synonymCtrl.text.trim().isEmpty ? null : _synonymCtrl.text.trim()),
        ));
    setState(() => _editing = false);
    await _loadWord();
  }

  Future<void> _enrichWithAI() async {
    if (_word == null) return;
    final ai = ref.read(aiServiceProvider);
    if (ai == null) return;

    setState(() => _enriching = true);
    try {
      final info = await ai.enrichWord(_word!.word);
      _typeCtrl.text = info.type ?? _typeCtrl.text;
      _pronCtrl.text = info.pronunciation ?? _pronCtrl.text;
      _meaningCtrl.text = info.meaning ?? _meaningCtrl.text;
      _usageCtrl.text = info.usageExample ?? _usageCtrl.text;
      _synonymCtrl.text = info.synonym ?? _synonymCtrl.text;
      setState(() {
        _editing = true;
        _enriching = false;
      });
    } catch (_) {
      setState(() => _enriching = false);
    }
  }

  @override
  void dispose() {
    _wordCtrl.dispose();
    _typeCtrl.dispose();
    _pronCtrl.dispose();
    _meaningCtrl.dispose();
    _usageCtrl.dispose();
    _synonymCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_word == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_word!.word),
        actions: [
          if (!_editing && !_enriching)
            IconButton(
              icon: const Icon(Icons.auto_awesome_outlined),
              tooltip: 'Re-enrich with AI',
              onPressed: _enrichWithAI,
            ),
          if (_editing)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _save,
            )
          else
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => setState(() => _editing = true),
            ),
        ],
      ),
      body: _enriching
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _StatusSelector(
                  status: _word!.status,
                  onChanged: (s) async {
                    await ref
                        .read(databaseProvider)
                        .wordDao
                        .updateWordStatus(widget.wordId, s);
                    await _loadWord();
                  },
                ),
                const SizedBox(height: 20),
                _Field(
                  label: 'Word',
                  controller: _wordCtrl,
                  editing: _editing,
                  large: true,
                ),
                _Field(
                  label: 'Part of Speech',
                  controller: _typeCtrl,
                  editing: _editing,
                  hint: 'noun, verb, adjective…',
                ),
                _Field(
                  label: 'Pronunciation',
                  controller: _pronCtrl,
                  editing: _editing,
                  hint: '/ɪˈfem(ə)r(ə)l/',
                ),
                _Field(
                  label: 'Meaning',
                  controller: _meaningCtrl,
                  editing: _editing,
                  maxLines: 3,
                ),
                _Field(
                  label: 'Usage Example',
                  controller: _usageCtrl,
                  editing: _editing,
                  maxLines: 3,
                ),
                _Field(
                  label: 'Synonyms',
                  controller: _synonymCtrl,
                  editing: _editing,
                ),
                const SizedBox(height: 8),
                Text(
                  'Added: ${_formatDate(_word!.createdAt)}  •  '
                  'Next review: ${_word!.nextReviewAt != null ? _formatDate(_word!.nextReviewAt!) : "not scheduled"}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Theme.of(context).colorScheme.outline),
                ),
              ],
            ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool editing;
  final String? hint;
  final int maxLines;
  final bool large;

  const _Field({
    required this.label,
    required this.controller,
    required this.editing,
    this.hint,
    this.maxLines = 1,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: cs.primary)),
          const SizedBox(height: 4),
          editing
              ? TextField(
                  controller: controller,
                  maxLines: maxLines,
                  style: large
                      ? Theme.of(context).textTheme.headlineSmall
                      : null,
                  decoration: InputDecoration(
                    hintText: hint,
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                )
              : Text(
                  controller.text.isEmpty ? '—' : controller.text,
                  style: large
                      ? Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold)
                      : Theme.of(context).textTheme.bodyLarge,
                ),
        ],
      ),
    );
  }
}

class _StatusSelector extends StatelessWidget {
  final String status;
  final ValueChanged<String> onChanged;

  const _StatusSelector({required this.status, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const statuses = ['active', 'mastered', 'achieved'];

    return SegmentedButton<String>(
      segments: statuses
          .map((s) => ButtonSegment(
                value: s,
                label: Text(s[0].toUpperCase() + s.substring(1)),
              ))
          .toList(),
      selected: {status},
      onSelectionChanged: (v) => onChanged(v.first),
    );
  }
}
