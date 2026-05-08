import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/providers/database_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counts = ref.watch(wordCountsProvider);
    final dueWords = ref.watch(dueWordsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lexio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(dueWordsProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Stats row
            counts.when(
              data: (data) => _StatsRow(counts: data),
              loading: () => const _StatsRowSkeleton(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 24),

            // Quick actions
            Text('Quick Actions',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            _QuickActions(),
            const SizedBox(height: 24),

            // Due for review
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Due for Review',
                    style: Theme.of(context).textTheme.titleMedium),
                dueWords.when(
                  data: (words) => Text(
                    '${words.length} words',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            dueWords.when(
              data: (words) {
                if (words.isEmpty) {
                  return _EmptyDue();
                }
                return _DueWordsList(words: words.take(5).toList());
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error: $e'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/input'),
        icon: const Icon(Icons.add),
        label: const Text('Add Words'),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final Map<String, int> counts;
  const _StatsRow({required this.counts});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(label: 'Total', value: counts['all'] ?? 0, icon: Icons.library_books),
        const SizedBox(width: 8),
        _StatCard(label: 'Active', value: counts['active'] ?? 0, icon: Icons.play_circle_outline),
        const SizedBox(width: 8),
        _StatCard(label: 'Mastered', value: counts['mastered'] ?? 0, icon: Icons.star_outline),
        const SizedBox(width: 8),
        _StatCard(label: 'Achieved', value: counts['achieved'] ?? 0, icon: Icons.emoji_events_outlined),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;

  const _StatCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            children: [
              Icon(icon, color: cs.primary, size: 20),
              const SizedBox(height: 4),
              Text('$value',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              Text(label,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: cs.onSurfaceVariant)),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsRowSkeleton extends StatelessWidget {
  const _StatsRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(4, (_) => Expanded(
        child: Card(child: const SizedBox(height: 72)),
      )),
    );
  }
}

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ActionCard(
          icon: Icons.style_outlined,
          label: 'Flashcards',
          color: Colors.blue,
          onTap: () => context.push('/flashcard'),
        ),
        const SizedBox(width: 8),
        _ActionCard(
          icon: Icons.quiz_outlined,
          label: 'Quiz',
          color: Colors.orange,
          onTap: () => context.push('/quiz'),
        ),
        const SizedBox(width: 8),
        _ActionCard(
          icon: Icons.list_alt_outlined,
          label: 'Word List',
          color: Colors.green,
          onTap: () => context.push('/words'),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(height: 8),
                Text(label,
                    style: Theme.of(context).textTheme.labelMedium),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DueWordsList extends StatelessWidget {
  final List words;
  const _DueWordsList({required this.words});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: words
          .map((w) => ListTile(
                leading: CircleAvatar(
                  child: Text(w.word[0].toUpperCase()),
                ),
                title: Text(w.word),
                subtitle: Text(w.type ?? 'word'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () =>
                    context.push('/flashcard'),
              ))
          .toList(),
    );
  }
}

class _EmptyDue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(Icons.check_circle_outline,
                size: 48,
                color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 12),
            Text('All caught up!',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text('No words due for review today.',
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
