import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/database/database.dart';
import '../../shared/providers/database_providers.dart';

class WordListScreen extends ConsumerStatefulWidget {
  const WordListScreen({super.key});

  @override
  ConsumerState<WordListScreen> createState() => _WordListScreenState();
}

class _WordListScreenState extends ConsumerState<WordListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word List'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Active'),
            Tab(text: 'Mastered'),
            Tab(text: 'Achieved'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: SearchBar(
              hintText: 'Search words…',
              leading: const Icon(Icons.search),
              onChanged: (v) => setState(() => _search = v.toLowerCase()),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _WordTab(provider: allWordsProvider, search: _search),
                _WordTab(provider: activeWordsProvider, search: _search),
                _WordTab(provider: masteredWordsProvider, search: _search),
                _WordTab(provider: achievedWordsProvider, search: _search),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/input'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _WordTab extends ConsumerWidget {
  final ProviderListenable<AsyncValue<List<Word>>> provider;
  final String search;

  const _WordTab({required this.provider, required this.search});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordsAsync = ref.watch(provider);

    return wordsAsync.when(
      data: (words) {
        final filtered = search.isEmpty
            ? words
            : words
                .where((w) =>
                    w.word.toLowerCase().contains(search) ||
                    (w.meaning?.toLowerCase().contains(search) ?? false))
                .toList();

        if (filtered.isEmpty) {
          return _EmptyList(hasSearch: search.isNotEmpty);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: filtered.length,
          itemBuilder: (_, i) => _WordCard(word: filtered[i]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _WordCard extends ConsumerWidget {
  final Word word;
  const _WordCard({required this.word});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _statusColor(word.status).withOpacity(0.15),
          child: Text(
            word.word[0].toUpperCase(),
            style: TextStyle(color: _statusColor(word.status)),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(word.word,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            if (word.type != null)
              _Badge(label: word.type!, color: cs.secondaryContainer),
            const SizedBox(width: 4),
            _Badge(
              label: word.status,
              color: _statusColor(word.status).withOpacity(0.15),
              textColor: _statusColor(word.status),
            ),
          ],
        ),
        subtitle: word.meaning != null
            ? Text(
                word.meaning!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push('/words/${word.id}'),
        onLongPress: () => _showDeleteDialog(context, ref),
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete word?'),
        content: Text('Remove "${word.word}" from your list?'),
        actions: [
          TextButton(
              onPressed: () => ctx.pop(false), child: const Text('Cancel')),
          FilledButton(
              onPressed: () => ctx.pop(true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(databaseProvider).wordDao.deleteWord(word.id);
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'mastered':
        return Colors.blue;
      case 'achieved':
        return Colors.green;
      default:
        return Colors.orange;
    }
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  final Color? textColor;

  const _Badge({required this.label, required this.color, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: textColor,
            ),
      ),
    );
  }
}

class _EmptyList extends StatelessWidget {
  final bool hasSearch;
  const _EmptyList({required this.hasSearch});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.outlineVariant),
          const SizedBox(height: 16),
          Text(
            hasSearch ? 'No words match your search.' : 'No words here yet.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
