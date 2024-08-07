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
          createCountMinus(Duration(days: 2), CountState.completed),
          createCountMinus(Duration(days: 1), CountState.completed),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(3));
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

    test('Missiong count objects', () {
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

    test('Week streak', () {
      withClock(Clock.fixed(DateTime(2000)), () {
        final Streak streak = createStreakWithCounts(StreakInterval.weekly, [
          createCountMinus(Duration(days: 14), CountState.completed),
          createCountMinus(Duration(days: 7), CountState.completed),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(3));
        expect(streak.isCompletedToday(), isTrue);
      });
    });

    test('Week streak with a skipped week', () {
      withClock(Clock.fixed(DateTime(2000)), () {
        final Streak streak = createStreakWithCounts(StreakInterval.weekly, [
          createCountMinus(Duration(days: 14), CountState.completed),
          createCountMinus(Duration(days: 7), CountState.skipped),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(2));
        expect(streak.isCompletedToday(), isTrue);
      });
    });

    test('Week streak with a missed week', () {
      withClock(Clock.fixed(DateTime(2000)), () {
        final Streak streak = createStreakWithCounts(StreakInterval.weekly, [
          createCountMinus(Duration(days: 14), CountState.completed),
          createCountMinus(Duration(days: 7), CountState.missed),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(1));
        expect(streak.isCompletedToday(), isTrue);
      });
    });

    test('Week streak with a missing week', () {
      withClock(Clock.fixed(DateTime(2000)), () {
        final Streak streak = createStreakWithCounts(StreakInterval.weekly, [
          createCountMinus(Duration(days: 14), CountState.completed),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);

        expect(streak.getStreakLength(), equals(1));
        expect(streak.isCompletedToday(), isTrue);
      });
    });

    test('Week streak with extra week', () {
      withClock(Clock.fixed(DateTime(2000)), () {
        final Streak streak = createStreakWithCounts(StreakInterval.weekly, [
          createCountMinus(Duration(days: 8), CountState.completed),
          createCountMinus(Duration(days: 7), CountState.completed),
          createCountMinus(Duration(days: 6), CountState.completed),
          createCountMinus(Duration(days: 5), CountState.completed),
          createCountMinus(Duration(days: 4), CountState.completed),
          createCountMinus(Duration(days: 3), CountState.completed),
          createCountMinus(Duration(days: 2), CountState.completed),
          createCountMinus(Duration(days: 1), CountState.completed),
          createCountMinus(Duration(days: 0), CountState.completed),
        ]);
        
        print(streak.counts.map((count) => count.getDateString(streak.interval!)));
        print(streak.getGroupedCounts().map((group) => group.map((count) => count.getDateString(streak.interval!))));

        expect(streak.getStreakLength(), equals(3));
        expect(streak.isCompletedToday(), isTrue);
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
          createCountMinus(Duration(days: 600), CountState.completed),
          createCountMinus(Duration(days: 400), CountState.missed),
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
        createCountMinus(Duration(days: 600), CountState.completed),
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
