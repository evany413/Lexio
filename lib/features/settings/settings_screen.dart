import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/ai/ai_provider.dart';
import '../../core/services/csv_service.dart';
import '../../core/database/database.dart';
import '../../shared/providers/ai_providers.dart';
import '../../shared/providers/database_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiSettings = ref.watch(aiSettingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // AI Provider Section
          _SectionHeader(title: 'AI Provider'),
          aiSettings.when(
            data: (settings) => ListTile(
              leading: const Icon(Icons.smart_toy_outlined),
              title: const Text('Current Provider'),
              subtitle: Text(settings?.type.label ?? 'Not configured'),
              trailing: TextButton(
                onPressed: () => context.push('/onboarding'),
                child: const Text('Change'),
              ),
            ),
            loading: () => const ListTile(title: Text('Loading…')),
            error: (_, __) => const ListTile(title: Text('Error loading settings')),
          ),
          const Divider(),

          // Data Section
          _SectionHeader(title: 'Vocabulary Data'),
          ListTile(
            leading: const Icon(Icons.upload_outlined),
            title: const Text('Export CSV'),
            subtitle: const Text('Save all words to a CSV file'),
            onTap: () => _export(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.download_outlined),
            title: const Text('Import CSV'),
            subtitle: const Text('Import words from a CSV file'),
            onTap: () => _import(context, ref),
          ),
          const Divider(),

          // Danger Zone
          _SectionHeader(title: 'Data Management'),
          ListTile(
            leading: Icon(Icons.delete_forever_outlined,
                color: Theme.of(context).colorScheme.error),
            title: Text('Clear All Words',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.error)),
            subtitle: const Text('Permanently delete all words and review history'),
            onTap: () => _confirmClearAll(context, ref),
          ),
          ListTile(
            leading: Icon(Icons.logout_outlined,
                color: Theme.of(context).colorScheme.error),
            title: Text('Remove API Key',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.error)),
            subtitle: const Text('Go back to onboarding'),
            onTap: () => _confirmRemoveKey(context, ref),
          ),
          const Divider(),

          // About
          _SectionHeader(title: 'About'),
          const ListTile(
            leading: Icon(Icons.auto_stories_outlined),
            title: Text('Lexio'),
            subtitle: Text('Version 1.0.0\nAI-powered English vocabulary learning'),
          ),
        ],
      ),
    );
  }

  Future<void> _export(BuildContext context, WidgetRef ref) async {
    try {
      final words = await ref.read(databaseProvider).wordDao.getAllWords();
      if (words.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No words to export.')),
          );
        }
        return;
      }
      final path = await CSVService.exportWords(words);
      if (context.mounted && path != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Exported to: $path')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    }
  }

  Future<void> _import(BuildContext context, WidgetRef ref) async {
    try {
      final rows = await CSVService.importWords();
      if (rows.isEmpty) return;

      final dao = ref.read(databaseProvider).wordDao;
      int added = 0;
      for (final row in rows) {
        final word = row['word']?.trim();
        if (word == null || word.isEmpty) continue;

        final status = ['active', 'mastered', 'achieved'].contains(row['status'])
            ? row['status']!
            : 'active';

        await dao.insertWord(WordsCompanion(
          word: Value(word),
          type: Value(row['type']?.isEmpty == true ? null : row['type']),
          pronunciation: Value(row['pronunciation']?.isEmpty == true ? null : row['pronunciation']),
          meaning: Value(row['meaning']?.isEmpty == true ? null : row['meaning']),
          usageExample: Value(row['usage_example']?.isEmpty == true ? null : row['usage_example']),
          synonym: Value(row['synonym']?.isEmpty == true ? null : row['synonym']),
          status: Value(status),
        ));
        added++;
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Imported $added words.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Import failed: $e')),
        );
      }
    }
  }

  Future<void> _confirmClearAll(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear all words?'),
        content: const Text(
            'This will permanently delete all your words and review history. This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => ctx.pop(false), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(ctx).colorScheme.error),
            onPressed: () => ctx.pop(true),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
    if (ok == true) {
      final db = ref.read(databaseProvider);
      await db.delete(db.reviewLogs).go();
      await db.delete(db.words).go();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All words deleted.')),
        );
      }
    }
  }

  Future<void> _confirmRemoveKey(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove API key?'),
        content: const Text('You will need to enter your API key again.'),
        actions: [
          TextButton(onPressed: () => ctx.pop(false), child: const Text('Cancel')),
          FilledButton(onPressed: () => ctx.pop(true), child: const Text('Remove')),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(aiSettingsProvider.notifier).clear();
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
