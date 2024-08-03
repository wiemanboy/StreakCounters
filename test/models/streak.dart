import 'package:flutter_test/flutter_test.dart';
import 'package:streak_counters/models/count.dart';
import 'package:streak_counters/models/enums/count_state.dart';
import 'package:streak_counters/models/enums/streak_interval.dart';
import 'package:streak_counters/models/streak.dart';
import 'package:clock/clock.dart';

void main() {
  group('Count Class Tests', () {
    withClock(Clock.fixed(DateTime(2000)), () {
      test('Three day streak', () {
        final Streak streak = createStreakWithCounts(StreakInterval.daily, [
          createCountMinus(Duration(days: 2), CountState.completed),
          createCountMinus(Duration(days: 1), CountState.completed),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(3));
        expect(streak.isCompletedToday(), isTrue);
      });

      test('Three day streak with a skipped day', () {
        final Streak streak = createStreakWithCounts(StreakInterval.daily, [
          createCountMinus(Duration(days: 2), CountState.completed),
          createCountMinus(Duration(days: 1), CountState.skipped),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(2));
        expect(streak.isCompletedToday(), isTrue);
      });

      test('Broken streak', () {
        final Streak streak = createStreakWithCounts(StreakInterval.daily, [
          createCountMinus(Duration(days: 2), CountState.completed),
          createCountMinus(Duration(days: 1), CountState.missed),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(1));
        expect(streak.isCompletedToday(), isTrue);
      });

      test('Missiong count objects', () {
        final Streak streak = createStreakWithCounts(StreakInterval.daily, [
          createCountMinus(Duration(days: 3), CountState.completed),
          createCountMinus(Duration(days: 2), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(0));
        expect(streak.isCompletedToday(), isFalse);
      });

      test('Missing count objects in middle', () {
        final Streak streak = createStreakWithCounts(StreakInterval.daily, [
          createCountMinus(Duration(days: 3), CountState.completed),
          createCountMinus(Duration(days: 2), CountState.completed),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(1));
        expect(streak.isCompletedToday(), isTrue);
      });

      test('shuffled count objects', () {
        final Streak streak = createStreakWithCounts(StreakInterval.daily, [
          createCountMinus(Duration(days: 1), CountState.completed),
          createCountMinus(Duration(days: 2), CountState.completed),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(3));
        expect(streak.isCompletedToday(), isTrue);
      });

      test('Last days skipped', () {
        final Streak streak = createStreakWithCounts(StreakInterval.daily, [
          createCountMinus(Duration(days: 2), CountState.completed),
          createCountMinus(Duration(days: 1), CountState.skipped),
          createCountMinus(Duration(days: 0), CountState.skipped),
        ]);

        expect(streak.getStreakLength(), equals(1));
        expect(streak.isActiveToday(), isTrue);
      });

      test('Week streak', () {
        final Streak streak = createStreakWithCounts(StreakInterval.weekly, [
          createCountMinus(Duration(days: 14), CountState.completed),
          createCountMinus(Duration(days: 7), CountState.completed),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(3));
        expect(streak.isCompletedToday(), isTrue);
      });

      test('Week streak with a skipped day', () {
        final Streak streak = createStreakWithCounts(StreakInterval.weekly, [
          createCountMinus(Duration(days: 14), CountState.completed),
          createCountMinus(Duration(days: 7), CountState.skipped),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(2));
        expect(streak.isCompletedToday(), isTrue);
      });

      test('Week streak with a missed day', () {
        final Streak streak = createStreakWithCounts(StreakInterval.weekly, [
          createCountMinus(Duration(days: 14), CountState.completed),
          createCountMinus(Duration(days: 7), CountState.missed),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(1));
        expect(streak.isCompletedToday(), isTrue);
      });

      test('Week streak with a missing day', () {
        final Streak streak = createStreakWithCounts(StreakInterval.weekly, [
          createCountMinus(Duration(days: 14), CountState.completed),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(1));
        expect(streak.isCompletedToday(), isTrue);
      });

      test('Week streak with extra days', () {
        final Streak streak = createStreakWithCounts(StreakInterval.weekly, [
          createCountMinus(Duration(days: 2), CountState.completed),
          createCountMinus(Duration(days: 1), CountState.completed),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(1));
        expect(streak.isCompletedToday(), isTrue);
      });

      test('Month streak', () {
        final Streak streak = createStreakWithCounts(StreakInterval.monthly, [
          createCountMinus(Duration(days: 60), CountState.completed),
          createCountMinus(Duration(days: 30), CountState.completed),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(3));
        expect(streak.isCompletedToday(), isTrue);
      });

      test('Month streak with a skipped day', () {
        final Streak streak = createStreakWithCounts(StreakInterval.monthly, [
          createCountMinus(Duration(days: 60), CountState.completed),
          createCountMinus(Duration(days: 30), CountState.skipped),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(2));
        expect(streak.isCompletedToday(), isTrue);
      });

      test('Month streak with a missed day', () {
        final Streak streak = createStreakWithCounts(StreakInterval.monthly, [
          createCountMinus(Duration(days: 60), CountState.completed),
          createCountMinus(Duration(days: 30), CountState.missed),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(1));
        expect(streak.isCompletedToday(), isTrue);
      });

      test('Month streak with a missing day', () {
        final Streak streak = createStreakWithCounts(StreakInterval.monthly, [
          createCountMinus(Duration(days: 60), CountState.completed),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(1));
        expect(streak.isCompletedToday(), isTrue);
      });

      test('Year streak', () {
        final Streak streak = createStreakWithCounts(StreakInterval.yearly, [
          createCountMinus(Duration(days: 600), CountState.completed),
          createCountMinus(Duration(days: 400), CountState.completed),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(3));
        expect(streak.isCompletedToday(), isTrue);
      });

      test('Year streak with a skipped day', () {
        final Streak streak = createStreakWithCounts(StreakInterval.yearly, [
          createCountMinus(Duration(days: 600), CountState.completed),
          createCountMinus(Duration(days: 400), CountState.skipped),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(2));
        expect(streak.isCompletedToday(), isTrue);
      });

      test('Year streak with a missed day', () {
        final Streak streak = createStreakWithCounts(StreakInterval.yearly, [
          createCountMinus(Duration(days: 366), CountState.completed),
          createCountMinus(Duration(days: 365), CountState.missed),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(1));
        expect(streak.isCompletedToday(), isTrue);
      });

      test('Year streak with a missing day', () {
        final Streak streak = createStreakWithCounts(StreakInterval.yearly, [
          createCountMinus(Duration(days: 600), CountState.completed),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(1));
        expect(streak.isCompletedToday(), isTrue);
      });
    });
  });
}

Streak createStreakWithCounts(StreakInterval interval, List<Count> counts) {
  final Streak streak = Streak(name: 'Test Streak', interval: interval);
  counts.forEach((count) => streak.addCount(count));
  return streak;
}

Count createCountMinus(Duration duration, CountState countState) {
  return Count(date: DateTime.now().subtract(duration), countState: countState);
}
