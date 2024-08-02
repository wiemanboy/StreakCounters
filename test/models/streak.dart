import 'package:flutter_test/flutter_test.dart';
import 'package:streak_counters/models/count.dart';
import 'package:streak_counters/models/enums/count_state.dart';
import 'package:streak_counters/models/streak.dart';
import 'package:clock/clock.dart';

void main() {
  group('Count Class Tests', () {
    withClock(Clock.fixed(DateTime(2000)), () {
      test('Three day streak', () {
        final DateTime testDate = DateTime.now();
        final Count count1 = Count(
            date: testDate.subtract(Duration(days: 2)),
            countState: CountState.completed);
        final Count count2 = Count(
            date: testDate.subtract(Duration(days: 1)),
            countState: CountState.completed);
        final Count count3 = Count(
            date: testDate.subtract(Duration(days: 0)),
            countState: CountState.completed);

        final Streak streak = Streak(name: 'Test Streak');
        streak.addCount(count1);
        streak.addCount(count2);
        streak.addCount(count3);

        expect(streak.getStreakLength(), equals(3));
        expect(streak.isCompletedToday(), isTrue);
      });

      test('Three day streak with a skipped day', () {
        final DateTime testDate = DateTime.now();
        final Count count1 = Count(
            date: testDate.subtract(Duration(days: 2)),
            countState: CountState.completed);
        final Count count2 = Count(
            date: testDate.subtract(Duration(days: 1)),
            countState: CountState.skipped);
        final Count count3 = Count(
            date: testDate.subtract(Duration(days: 0)),
            countState: CountState.completed);

        final Streak streak = Streak(name: 'Test Streak');
        streak.addCount(count1);
        streak.addCount(count2);
        streak.addCount(count3);

        expect(streak.getStreakLength(), equals(2));
        expect(streak.isCompletedToday(), isTrue);
      });

      test('Broken streak', () {
        final DateTime testDate = DateTime.now();
        final Count count1 = Count(
            date: testDate.subtract(Duration(days: 2)),
            countState: CountState.completed);
        final Count count2 = Count(
            date: testDate.subtract(Duration(days: 1)),
            countState: CountState.missed);
        final Count count3 = Count(
            date: testDate.subtract(Duration(days: 0)),
            countState: CountState.completed);

        final Streak streak = Streak(name: 'Test Streak');
        streak.addCount(count1);
        streak.addCount(count2);
        streak.addCount(count3);

        expect(streak.getStreakLength(), equals(1));
        expect(streak.isCompletedToday(), isTrue);
      });

      test('Missiong count objects', () {
        final DateTime testDate = DateTime.now();
        final Count count1 =
            Count(date: testDate.subtract(Duration(days: 3)), countState: CountState.completed);
        final Count count2 = Count(
            date: testDate.subtract(Duration(days: 2)),
            countState: CountState.completed);

        final Streak streak = Streak(name: 'Test Streak');
        streak.addCount(count1);
        streak.addCount(count2);

        expect(streak.getStreakLength(), equals(0));
        expect(streak.isCompletedToday(), isFalse);
      });

      test('Missing count objects in middle', () {
        final DateTime testDate = DateTime.now();
        final Count count1 =
        Count(date: testDate.subtract(Duration(days: 3)), countState: CountState.completed);
        final Count count2 = Count(
            date: testDate.subtract(Duration(days: 2)),
            countState: CountState.completed);
        final Count count3 = Count(
            date: testDate.subtract(Duration(days: 0)),
            countState: CountState.completed);

        final Streak streak = Streak(name: 'Test Streak');
        streak.addCount(count1);
        streak.addCount(count2);
        streak.addCount(count3);

        expect(streak.getStreakLength(), equals(1));
        expect(streak.isCompletedToday(), isTrue);
      });

      test('shuffled count objects', () {
        final DateTime testDate = DateTime.now();
        final Count count1 = Count(
            date: testDate.subtract(Duration(days: 1)),
            countState: CountState.completed);
        final Count count2 = Count(
            date: testDate.subtract(Duration(days: 2)),
            countState: CountState.completed);
        final Count count3 = Count(
            date: testDate.subtract(Duration(days: 0)),
            countState: CountState.completed);

        final Streak streak = Streak(name: 'Test Streak');
        streak.addCount(count1);
        streak.addCount(count2);
        streak.addCount(count3);

        expect(streak.getStreakLength(), equals(3));
        expect(streak.isCompletedToday(), isTrue);
      });

      test('Last day skipped', () {
        final DateTime testDate = DateTime.now();
        final Count count1 = Count(
            date: testDate.subtract(Duration(days: 2)),
            countState: CountState.completed);
        final Count count2 = Count(
            date: testDate.subtract(Duration(days: 1)),
            countState: CountState.skipped);
        final Count count3 = Count(
            date: testDate.subtract(Duration(days: 0)),
            countState: CountState.skipped);

        final Streak streak = Streak(name: 'Test Streak');
        streak.addCount(count1);
        streak.addCount(count2);
        streak.addCount(count3);

        expect(streak.getStreakLength(), equals(1));
        expect(streak.isActiveToday(), isTrue);
      });
    });
  });
}
