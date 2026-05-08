import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/providers/ai_providers.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/word_input/word_input_screen.dart';
import '../../features/word_list/word_list_screen.dart';
import '../../features/flashcard/flashcard_screen.dart';
import '../../features/quiz/quiz_screen.dart';
import '../../features/settings/settings_screen.dart';

class _RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  _RouterNotifier(this._ref) {
    _ref.listen(aiSettingsProvider, (_, __) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);

  return GoRouter(
    refreshListenable: notifier,
    initialLocation: '/',
    redirect: (context, state) {
      final settings = ref.read(aiSettingsProvider);
      if (settings.isLoading) return null;

      final hasKey = settings.valueOrNull != null;
      final isOnboarding = state.matchedLocation == '/onboarding';

      if (!hasKey && !isOnboarding) return '/onboarding';
      if (hasKey && isOnboarding) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (_, __) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/input',
        builder: (_, __) => const WordInputScreen(),
      ),
      GoRoute(
        path: '/words',
        builder: (_, __) => const WordListScreen(),
      ),
      GoRoute(
        path: '/flashcard',
        builder: (_, __) => const FlashcardScreen(),
      ),
      GoRoute(
        path: '/quiz',
        builder: (_, __) => const QuizScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (_, __) => const SettingsScreen(),
      ),
    ],
  );
});
