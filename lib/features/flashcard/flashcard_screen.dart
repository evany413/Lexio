import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/word.dart';
import '../../shared/providers/database_providers.dart';

class FlashcardScreen extends ConsumerStatefulWidget {
  const FlashcardScreen({super.key});

  @override
  ConsumerState<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends ConsumerState<FlashcardScreen>
    with SingleTickerProviderStateMixin {
  List<Word> _words = [];
  int _currentIndex = 0;
  bool _flipped = false;
  bool _loading = true;
  bool _done = false;
  late AnimationController _animController;
  late Animation<double> _flipAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _flipAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
    _loadWords();
  }

  Future<void> _loadWords() async {
    final words = ref.read(storageProvider).getDueWords();
    setState(() {
      _words = words..shuffle(Random());
      _loading = false;
      _done = words.isEmpty;
    });
  }

  void _flip() {
    if (!_flipped) {
      _animController.forward();
    } else {
      _animController.reverse();
    }
    setState(() => _flipped = !_flipped);
  }

  Future<void> _rate(int quality) async {
    if (_words.isEmpty) return;
    final word = _words[_currentIndex];
    await recordReview(ref, word, quality);

    if (_currentIndex + 1 >= _words.length) {
      setState(() => _done = true);
    } else {
      _animController.reset();
      setState(() {
        _currentIndex++;
        _flipped = false;
      });
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcards'),
        actions: [
          if (_words.isNotEmpty && !_done)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text('${_currentIndex + 1} / ${_words.length}'),
              ),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _done
              ? _DoneState(
                  onRestart: () {
                    setState(() {
                      _currentIndex = 0;
                      _flipped = false;
                      _done = false;
                      _loading = true;
                    });
                    _loadWords();
                  },
                )
              : _Session(
                  word: _words[_currentIndex],
                  flipped: _flipped,
                  flipAnim: _flipAnim,
                  onFlip: _flip,
                  onRate: _rate,
                ),
    );
  }
}

class _Session extends StatelessWidget {
  final Word word;
  final bool flipped;
  final Animation<double> flipAnim;
  final VoidCallback onFlip;
  final ValueChanged<int> onRate;

  const _Session({
    required this.word,
    required this.flipped,
    required this.flipAnim,
    required this.onFlip,
    required this.onRate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onFlip,
              child: AnimatedBuilder(
                animation: flipAnim,
                builder: (_, __) {
                  final angle = flipAnim.value * pi;
                  final showBack = angle > pi / 2;
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(angle),
                    child: Transform(
                      alignment: Alignment.center,
                      transform: showBack
                          ? Matrix4.rotationY(pi)
                          : Matrix4.identity(),
                      child: _FlashCard(
                        word: word,
                        showBack: showBack,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            flipped ? 'How well did you know this?' : 'Tap the card to reveal',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          if (flipped) _RatingButtons(onRate: onRate),
          if (!flipped)
            TextButton.icon(
              onPressed: onFlip,
              icon: const Icon(Icons.flip),
              label: const Text('Reveal Answer'),
            ),
        ],
      ),
    );
  }
}

class _FlashCard extends StatelessWidget {
  final Word word;
  final bool showBack;

  const _FlashCard({required this.word, required this.showBack});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      elevation: 4,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: showBack
              ? [
                  if (word.type != null)
                    Chip(label: Text(word.type!)),
                  const SizedBox(height: 8),
                  Text(
                    word.word,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  if (word.pronunciation != null) ...[
                    const SizedBox(height: 4),
                    Text(word.pronunciation!,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: cs.primary)),
                  ],
                  const Divider(height: 32),
                  Text(
                    word.meaning ?? '—',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  if (word.usageExample != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      '"${word.usageExample}"',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: cs.onSurfaceVariant),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  if (word.synonym != null) ...[
                    const SizedBox(height: 12),
                    Text('≈ ${word.synonym}',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: cs.outline)),
                  ],
                ]
              : [
                  Text(
                    word.word,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.primary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'What does this word mean?',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ],
        ),
      ),
    );
  }
}

class _RatingButtons extends StatelessWidget {
  final ValueChanged<int> onRate;
  const _RatingButtons({required this.onRate});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _RateBtn(label: 'Again', sublabel: 'Forgot', quality: 1, color: Colors.red, onTap: onRate),
        _RateBtn(label: 'Hard', sublabel: 'Difficult', quality: 2, color: Colors.orange, onTap: onRate),
        _RateBtn(label: 'Good', sublabel: 'Recalled', quality: 4, color: Colors.blue, onTap: onRate),
        _RateBtn(label: 'Easy', sublabel: 'Perfect', quality: 5, color: Colors.green, onTap: onRate),
      ],
    );
  }
}

class _RateBtn extends StatelessWidget {
  final String label;
  final String sublabel;
  final int quality;
  final Color color;
  final ValueChanged<int> onTap;

  const _RateBtn({
    required this.label,
    required this.sublabel,
    required this.quality,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(quality),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(label,
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
            Text(sublabel,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: color.withOpacity(0.8))),
          ],
        ),
      ),
    );
  }
}

class _DoneState extends StatelessWidget {
  final VoidCallback onRestart;
  const _DoneState({required this.onRestart});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.celebration_outlined,
                size: 80,
                color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 24),
            Text('Session complete!',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('You reviewed all due words.',
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: onRestart,
              icon: const Icon(Icons.refresh),
              label: const Text('Review Again'),
            ),
          ],
        ),
      ),
    );
  }
}
