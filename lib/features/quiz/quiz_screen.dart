import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/word.dart';
import '../../shared/providers/database_providers.dart';

enum _QuizMode { multipleChoice, typeTheWord }

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  _QuizMode _mode = _QuizMode.multipleChoice;
  List<Word> _allWords = [];
  List<_Question> _questions = [];
  int _current = 0;
  int _score = 0;
  int? _selectedAnswer;
  bool _answered = false;
  bool _loading = true;
  bool _done = false;
  final _typeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  Future<void> _loadWords() async {
    final words = ref.read(storageProvider).getAllWords();
    setState(() {
      _allWords = words;
      _loading = false;
    });
    if (words.length >= 4) _buildQuiz();
  }

  void _buildQuiz() {
    final rng = Random();
    final shuffled = List.of(_allWords)..shuffle(rng);
    final pool = shuffled.take(10).toList();

    _questions = pool.map((word) {
      if (_mode == _QuizMode.multipleChoice) {
        // Pick 3 wrong answers
        final others = _allWords
            .where((w) => w.id != word.id && w.meaning != null)
            .toList()
          ..shuffle(rng);
        final wrongs = others.take(3).map((w) => w.meaning!).toList();
        final options = [...wrongs, word.meaning ?? word.word]..shuffle(rng);
        return _Question(
          word: word,
          prompt: 'What is the meaning of:',
          answer: word.meaning ?? word.word,
          options: options,
        );
      } else {
        return _Question(
          word: word,
          prompt: word.meaning ?? word.usageExample ?? 'Type the word',
          answer: word.word,
          options: [],
        );
      }
    }).toList();

    setState(() {
      _current = 0;
      _score = 0;
      _answered = false;
      _selectedAnswer = null;
      _done = false;
      _typeController.clear();
    });
  }

  void _selectAnswer(int index) {
    if (_answered) return;
    final correct = _questions[_current].options[index] ==
        _questions[_current].answer;
    setState(() {
      _selectedAnswer = index;
      _answered = true;
      if (correct) _score++;
    });
  }

  void _submitType() {
    if (_answered) return;
    FocusScope.of(context).unfocus();
    final input = _typeController.text.trim().toLowerCase();
    final correct =
        input == _questions[_current].answer.toLowerCase();
    setState(() {
      _answered = true;
      if (correct) _score++;
    });
  }

  void _next() {
    FocusScope.of(context).unfocus();
    if (_current + 1 >= _questions.length) {
      setState(() => _done = true);
    } else {
      setState(() {
        _current++;
        _answered = false;
        _selectedAnswer = null;
        _typeController.clear();
      });
    }
  }

  @override
  void dispose() {
    _typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: SegmentedButton<_QuizMode>(
              segments: const [
                ButtonSegment(
                    value: _QuizMode.multipleChoice,
                    label: Text('Multiple Choice'),
                    icon: Icon(Icons.list)),
                ButtonSegment(
                    value: _QuizMode.typeTheWord,
                    label: Text('Type the Word'),
                    icon: Icon(Icons.keyboard)),
              ],
              selected: {_mode},
              onSelectionChanged: (v) {
                setState(() => _mode = v.first);
                if (_allWords.length >= 4) _buildQuiz();
              },
            ),
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _allWords.length < 4
              ? _NotEnoughWords()
              : _done
                  ? _ResultScreen(
                      score: _score,
                      total: _questions.length,
                      onRetry: _buildQuiz,
                    )
                  : _QuizBody(
                      question: _questions[_current],
                      current: _current,
                      total: _questions.length,
                      mode: _mode,
                      answered: _answered,
                      selectedAnswer: _selectedAnswer,
                      typeController: _typeController,
                      onSelect: _selectAnswer,
                      onSubmitType: _submitType,
                      onNext: _next,
                    ),
    );
  }
}

class _Question {
  final Word word;
  final String prompt;
  final String answer;
  final List<String> options;
  _Question({
    required this.word,
    required this.prompt,
    required this.answer,
    required this.options,
  });
}

class _QuizBody extends StatelessWidget {
  final _Question question;
  final int current;
  final int total;
  final _QuizMode mode;
  final bool answered;
  final int? selectedAnswer;
  final TextEditingController typeController;
  final ValueChanged<int> onSelect;
  final VoidCallback onSubmitType;
  final VoidCallback onNext;

  const _QuizBody({
    required this.question,
    required this.current,
    required this.total,
    required this.mode,
    required this.answered,
    required this.selectedAnswer,
    required this.typeController,
    required this.onSelect,
    required this.onSubmitType,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LinearProgressIndicator(value: (current + 1) / total),
          const SizedBox(height: 4),
          Text('${current + 1} / $total',
              style: Theme.of(context).textTheme.labelSmall,
              textAlign: TextAlign.right),
          const SizedBox(height: 20),
          Text(question.prompt,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(color: cs.onSurfaceVariant)),
          const SizedBox(height: 8),
          Text(
            mode == _QuizMode.multipleChoice ? question.word.word : '',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold, color: cs.primary),
          ),
          const SizedBox(height: 24),
          if (mode == _QuizMode.multipleChoice)
            ...List.generate(question.options.length, (i) {
              final isCorrect = question.options[i] == question.answer;
              final isSelected = selectedAnswer == i;

              Color? tileColor;
              if (answered) {
                if (isCorrect) tileColor = Colors.green.withOpacity(0.15);
                if (isSelected && !isCorrect) tileColor = Colors.red.withOpacity(0.15);
              }

              return Card(
                color: tileColor,
                child: ListTile(
                  title: Text(question.options[i]),
                  leading: answered
                      ? Icon(
                          isCorrect
                              ? Icons.check_circle
                              : (isSelected ? Icons.cancel : null),
                          color: isCorrect ? Colors.green : Colors.red,
                        )
                      : CircleAvatar(
                          radius: 12,
                          child: Text(String.fromCharCode(65 + i)),
                        ),
                  onTap: answered ? null : () => onSelect(i),
                ),
              );
            })
          else ...[
            TextField(
              controller: typeController,
              decoration: const InputDecoration(
                labelText: 'Type the word',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => answered ? onNext() : onSubmitType(),
              enabled: !answered,
            ),
            const SizedBox(height: 8),
            if (answered)
              Card(
                color: typeController.text.trim().toLowerCase() ==
                        question.answer.toLowerCase()
                    ? Colors.green.withOpacity(0.15)
                    : Colors.red.withOpacity(0.15),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text('Correct answer: ${question.answer}'),
                ),
              ),
          ],
          const Spacer(),
          if (answered)
            FilledButton(
              onPressed: onNext,
              child: const Text('Next'),
            )
          else if (mode == _QuizMode.typeTheWord)
            FilledButton(
              onPressed: onSubmitType,
              child: const Text('Check'),
            ),
        ],
      ),
    );
  }
}

class _ResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final VoidCallback onRetry;

  const _ResultScreen({required this.score, required this.total, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final pct = total == 0 ? 0 : (score / total * 100).round();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Quiz Complete!',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            Text('$score / $total correct  ($pct%)',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              pct >= 80
                  ? 'Excellent work!'
                  : pct >= 60
                      ? 'Good job, keep practicing!'
                      : 'Keep studying, you can do it!',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotEnoughWords extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.info_outline, size: 48),
            const SizedBox(height: 16),
            Text('You need at least 4 words to start a quiz.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
