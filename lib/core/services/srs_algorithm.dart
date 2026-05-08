class SRSResult {
  final double easeFactor;
  final double intervalDays;
  final int repetitions;
  final DateTime nextReviewAt;
  final String status;

  const SRSResult({
    required this.easeFactor,
    required this.intervalDays,
    required this.repetitions,
    required this.nextReviewAt,
    required this.status,
  });
}

// SM-2 spaced repetition algorithm.
// quality: 0 = complete blackout, 5 = perfect recall
class SRSAlgorithm {
  static SRSResult calculate({
    required int quality,
    required double easeFactor,
    required double intervalDays,
    required int repetitions,
  }) {
    double newEF = easeFactor;
    double newInterval;
    int newReps;

    if (quality < 3) {
      newReps = 0;
      newInterval = 1.0;
    } else {
      newEF = easeFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
      if (newEF < 1.3) newEF = 1.3;

      newReps = repetitions + 1;
      if (newReps == 1) {
        newInterval = 1.0;
      } else if (newReps == 2) {
        newInterval = 6.0;
      } else {
        newInterval = intervalDays * newEF;
      }
    }

    final nextReview = DateTime.now().add(
      Duration(hours: (newInterval * 24).round()),
    );

    String status = 'active';
    if (newInterval >= 90) {
      status = 'achieved';
    } else if (newInterval >= 21) {
      status = 'mastered';
    }

    return SRSResult(
      easeFactor: newEF,
      intervalDays: newInterval,
      repetitions: newReps,
      nextReviewAt: nextReview,
      status: status,
    );
  }
}
