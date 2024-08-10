import 'package:flutter_test/flutter_test.dart';
import 'package:streak_counters/models/count.dart';
import 'package:streak_counters/models/enums/count_state.dart';
import 'package:streak_counters/models/enums/streak_interval.dart';
import 'package:streak_counters/models/streak.dart';
import 'package:clock/clock.dart';

void main() {
  group('Count Class Tests', () {
    test('Three day streak', () {
      withClock(Clock.fixed(DateTime(2000)), () {
        final Streak streak = createStreakWithCounts(StreakInterval.daily, [
          createCountMinus(Duration(hours: 49), CountState.completed),
          createCountMinus(Duration(hours: 25), CountState.completed),
          createCountMinus(Duration(hours: 1), CountState.completed),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(4));
        expect(streak.isCompletedToday(), isTrue);
      });
    });

    test('duplicate days', () {
      withClock(Clock.fixed(DateTime(2000)), () {
        final Streak streak = createStreakWithCounts(StreakInterval.daily, [
          createCountMinus(Duration(days: 0), CountState.completed),
          createCountMinus(Duration(days: 0), CountState.completed),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(1));
        expect(streak.isCompletedToday(), isTrue);
      });
    });

    test('Three day streak with a skipped day', () {
      withClock(Clock.fixed(DateTime(2000)), () {
        final Streak streak = createStreakWithCounts(StreakInterval.daily, [
          createCountMinus(Duration(days: 2), CountState.completed),
          createCountMinus(Duration(days: 1), CountState.skipped),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(2));
        expect(streak.isCompletedToday(), isTrue);
      });
    });

    test('Broken streak', () {
      withClock(Clock.fixed(DateTime(2000)), () {
        final Streak streak = createStreakWithCounts(StreakInterval.daily, [
          createCountMinus(Duration(days: 2), CountState.completed),
          createCountMinus(Duration(days: 1), CountState.missed),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);
        expect(streak.getStreakLength(), equals(1));
        expect(streak.isCompletedToday(), isTrue);
      });
    });

    test('Missing count objects', () {
      withClock(Clock.fixed(DateTime(2000)), () {
        final Streak streak = createStreakWithCounts(StreakInterval.daily, [
          createCountMinus(Duration(days: 3), CountState.completed),
          createCountMinus(Duration(days: 2), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(0));
        expect(streak.isCompletedToday(), isFalse);
      });
    });

    test('Missing count objects in middle', () {
      withClock(Clock.fixed(DateTime(2000)), () {
        final Streak streak = createStreakWithCounts(StreakInterval.daily, [
          createCountMinus(Duration(days: 3), CountState.completed),
          createCountMinus(Duration(days: 2), CountState.completed),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(1));
        expect(streak.isCompletedToday(), isTrue);
      });
    });

    test('shuffled count objects', () {
      withClock(Clock.fixed(DateTime(2000)), () {
        final Streak streak = createStreakWithCounts(StreakInterval.daily, [
          createCountMinus(Duration(days: 1), CountState.completed),
          createCountMinus(Duration(days: 2), CountState.completed),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(3));
        expect(streak.isCompletedToday(), isTrue);
      });
    });

    test('Last days skipped', () {
      withClock(Clock.fixed(DateTime(2000)), () {
        final Streak streak = createStreakWithCounts(StreakInterval.daily, [
          createCountMinus(Duration(days: 2), CountState.completed),
          createCountMinus(Duration(days: 1), CountState.skipped),
          createCountMinus(Duration(days: 0), CountState.skipped),
        ]);

        expect(streak.getStreakLength(), equals(1));
        expect(streak.isActiveToday(), isTrue);
      });
    });

    test('Maintained streak', () {
      withClock(Clock.fixed(DateTime(2024, 8, 8)), () {
        final Streak streak = createStreakWithCounts(StreakInterval.daily, [
          Count(date: DateTime(2024, 8, 3), countState: CountState.completed),
          Count(date: DateTime(2024, 8, 4), countState: CountState.completed),
          Count(date: DateTime(2024, 8, 5), countState: CountState.completed),
          Count(date: DateTime(2024, 8, 6), countState: CountState.completed),
          Count(date: DateTime(2024, 8, 7), countState: CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(5));
        expect(streak.isActiveToday(), isTrue);
      });
    });

    test('Week streak', () {
      withClock(Clock.fixed(DateTime(2000, DateTime.january, 3)), () {
        final Streak streak = createStreakWithCounts(StreakInterval.weekly, [
          createCountMinus(Duration(days: 8), CountState.completed),
          createCountMinus(Duration(days: 1), CountState.completed),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(3));
        expect(streak.isCompletedToday(), isTrue);
      });
    });

    test('Week streak with a skipped week', () {
      withClock(Clock.fixed(DateTime(2000, DateTime.january, 3)), () {
        final Streak streak = createStreakWithCounts(StreakInterval.weekly, [
          createCountMinus(Duration(days: 8), CountState.completed),
          createCountMinus(Duration(days: 1), CountState.skipped),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(2));
        expect(streak.isCompletedToday(), isTrue);
      });
    });

    test('Week streak with a missed week', () {
      withClock(Clock.fixed(DateTime(2000, DateTime.january, 3)), () {
        final Streak streak = createStreakWithCounts(StreakInterval.weekly, [
          createCountMinus(Duration(days: 8), CountState.completed),
          createCountMinus(Duration(days: 1), CountState.missed),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(1));
        expect(streak.isCompletedToday(), isTrue);
      });
    });

    test('Week streak with a missing week', () {
      withClock(Clock.fixed(DateTime(2000, DateTime.january, 3)), () {
        final Streak streak = createStreakWithCounts(StreakInterval.weekly, [
          createCountMinus(Duration(days: 8), CountState.completed),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(1));
        expect(streak.isCompletedToday(), isTrue);
      });
    });

    test('Week streak with extra week', () {
      withClock(Clock.fixed(DateTime(2000, DateTime.january, 3)), () {
        final Streak streak = createStreakWithCounts(StreakInterval.weekly, [
          createCountMinus(Duration(days: 8), CountState.completed),
          createCountMinus(Duration(days: 7), CountState.completed),
          createCountMinus(Duration(days: 1), CountState.completed),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);
        expect(streak.getStreakLength(), equals(3));
        expect(streak.isActiveToday(), isTrue);
      });
    });

    test('Not yet completed this week', () {
      withClock(Clock.fixed(DateTime(2024, 8, 7)), () {
        final Streak streak = createStreakWithCounts(StreakInterval.weekly, [
          Count(date: DateTime(2024, 7, 28), countState: CountState.completed),
          Count(date: DateTime(2024, 8, 3), countState: CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(2));
        expect(streak.isGoing(), isTrue);
      });
    });

    test('Month streak', () {
      withClock(Clock.fixed(DateTime(2000)), () {
        final Streak streak = createStreakWithCounts(StreakInterval.monthly, [
          createCountMinus(Duration(days: 60), CountState.completed),
          createCountMinus(Duration(days: 30), CountState.completed),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(3));
        expect(streak.isCompletedToday(), isTrue);
      });
    });

    test('Month streak with a skipped month', () {
      withClock(Clock.fixed(DateTime(2000)), () {
        final Streak streak = createStreakWithCounts(StreakInterval.monthly, [
          createCountMinus(Duration(days: 60), CountState.completed),
          createCountMinus(Duration(days: 30), CountState.skipped),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(2));
        expect(streak.isCompletedToday(), isTrue);
      });
    });

    test('Month streak with a missed month', () {
      withClock(Clock.fixed(DateTime(2000)), () {
        final Streak streak = createStreakWithCounts(StreakInterval.monthly, [
          createCountMinus(Duration(days: 60), CountState.completed),
          createCountMinus(Duration(days: 30), CountState.missed),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(1));
        expect(streak.isCompletedToday(), isTrue);
      });
    });

    test('Month streak with a missing month', () {
      withClock(Clock.fixed(DateTime(2000)), () {
        final Streak streak = createStreakWithCounts(StreakInterval.monthly, [
          createCountMinus(Duration(days: 60), CountState.completed),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(1));
        expect(streak.isCompletedToday(), isTrue);
      });
    });

    test('Year streak', () {
      withClock(Clock.fixed(DateTime(2000)), () {
        final Streak streak = createStreakWithCounts(StreakInterval.yearly, [
          createCountMinus(Duration(days: 366), CountState.completed),
          createCountMinus(Duration(days: 365), CountState.completed),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(3));
        expect(streak.isCompletedToday(), isTrue);
      });
    });

    test('Year streak with a skipped year', () {
      withClock(Clock.fixed(DateTime(2000)), () {
        final Streak streak = createStreakWithCounts(StreakInterval.yearly, [
          createCountMinus(Duration(days: 366), CountState.completed),
          createCountMinus(Duration(days: 365), CountState.skipped),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(2));
        expect(streak.isCompletedToday(), isTrue);
      });
    });

    test('Year streak with a missed year', () {
      withClock(Clock.fixed(DateTime(2000)), () {
        final Streak streak = createStreakWithCounts(StreakInterval.yearly, [
          createCountMinus(Duration(days: 366), CountState.completed),
          createCountMinus(Duration(days: 365), CountState.missed),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(1));
        expect(streak.isCompletedToday(), isTrue);
      });
    });
  });

  test('Year streak with a missing year', () {
    withClock(Clock.fixed(DateTime(2000)), () {
      final Streak streak = createStreakWithCounts(StreakInterval.yearly, [
        createCountMinus(Duration(days: 366), CountState.completed),
        createCountMinus(Duration(days: 0), CountState.completed),
      ]);

      expect(streak.getStreakLength(), equals(1));
      expect(streak.isCompletedToday(), isTrue);
    });
  });
}

Streak createStreakWithCounts(StreakInterval interval, List<Count> counts) {
  final Streak streak = Streak(name: 'Test Streak', interval: interval);
  for (var count in counts) {
    streak.addCount(count);
  }
  return streak;
}

Count createCountMinus(Duration duration, CountState countState) {
  return Count(date: clock.now().subtract(duration), countState: countState);
}
