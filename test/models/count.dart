import 'package:flutter_test/flutter_test.dart';
import 'package:streak_counters/models/count.dart';
import 'package:streak_counters/models/enums/count_state.dart';

void main() {
  group('Count Class Tests', () {
    test('Should initialize with the correct date and countState', () {
      final DateTime testDate = DateTime(2024, 8, 1);
      const CountState testState = CountState.completed;

      final Count count = Count(date: testDate, countState: testState);

      expect(count.date, equals(testDate));
      expect(count.countState, equals(testState));
    });

    test('Should convert countState to dbCountState correctly', () {
      final Count count = Count(date: DateTime.now(), countState: CountState.skipped);

      expect(count.dbCountState, equals(CountState.skipped.index));

      count.dbCountState = CountState.completed.index;
      expect(count.countState, equals(CountState.completed));
    });

    test('Should return correct isCompleted value', () {
      final Count completedCount = Count(date: DateTime.now(), countState: CountState.completed);
      final Count skippedCount = Count(date: DateTime.now(), countState: CountState.skipped);

      expect(completedCount.isCompleted(), isTrue);
      expect(skippedCount.isCompleted(), isFalse);
    });

    test('Should return correct isSkipped value', () {
      final Count skippedCount = Count(date: DateTime.now(), countState: CountState.skipped);
      final Count completedCount = Count(date: DateTime.now(), countState: CountState.completed);

      expect(skippedCount.isSkipped(), isTrue);
      expect(completedCount.isSkipped(), isFalse);
    });

    test('Should return correct isActive value', () {
      final Count activeCount = Count(date: DateTime.now(), countState: CountState.skipped);
      final Count inactiveCount = Count(date: DateTime.now(), countState: null);

      expect(activeCount.isActive(), isTrue);
      expect(inactiveCount.isActive(), isFalse);
    });

    test('Should return true for isOn if dates match', () {
      final DateTime testDate = DateTime(2024, 8, 1);
      final Count count = Count(date: testDate);

      expect(count.isOn(testDate), isTrue);
    });

    test('Should return false for isOn if dates do not match', () {
      final DateTime countDate = DateTime(2024, 8, 1);
      final DateTime testDate = DateTime(2024, 8, 2);
      final Count count = Count(date: countDate);

      expect(count.isOn(testDate), isFalse);
    });
  });
}
