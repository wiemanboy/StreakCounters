import 'package:objectbox/objectbox.dart';
import 'package:streak_counters/models/streak.dart';
import '../objectbox.dart';
import 'enums/count_state.dart';
import 'enums/streak_interval.dart';

@Entity()
class Count {
  @Id()
  int id = 0;

  ToOne<Streak> streak = ToOne<Streak>();

  @Property(type: PropertyType.date)
  DateTime date;

  @Transient()
  CountState? countState;

  Count({required this.date, this.countState});

  int? get dbCountState {
    return countState?.index;
  }

  set dbCountState(int? value) {
    countState = value != null ? CountState.values[value] : null;
  }

  bool isCompleted() {
    return countState == CountState.completed;
  }

  bool isSkipped() {
    return countState == CountState.skipped;
  }

  bool isActive() {
    return isCompleted() || isSkipped();
  }

  bool isOn(DateTime date, StreakInterval interval) {
    switch (interval) {
      case StreakInterval.daily:
        return _isOnDaily(date);
      case StreakInterval.weekly:
        return _isOnWeekly(date);
      case StreakInterval.monthly:
        return _isOnMonthly(date);
      case StreakInterval.yearly:
        return _isOnYearly(date);
    }
  }

  int compareDate(Count other) {
    return date.compareTo(other.date);
  }

  int dateDifference(DateTime date, StreakInterval interval) {
    switch (interval) {
      case StreakInterval.daily:
        return dayDifference(date);
      case StreakInterval.weekly:
        return weeksDifference(date);
      case StreakInterval.monthly:
        return monthsDifference(date);
      case StreakInterval.yearly:
        return yearsDifference(date);
    }
  }

  int dayDifference(DateTime date) {
    return this.date.difference(date).inDays;
  }

  int weeksDifference(DateTime date) {
    return (this.date.difference(date).inDays / 7).round();
  }

  int monthsDifference(DateTime date) {
    return this.date.year * 12 +
        this.date.month -
        (date.year * 12 + date.month);
  }

  int yearsDifference(DateTime date) {
    return this.date.year - date.year;
  }

  int _getWeekOfYear(DateTime dateTime) {
    final startOfYear = DateTime(dateTime.year, 1, 1);
    final daysElapsed = dateTime.difference(startOfYear).inDays;
    return ((daysElapsed + startOfYear.weekday - 1) ~/ 7) + 1;
  }

  bool _isOnDaily(DateTime date) {
    return this.date.year == date.year &&
        this.date.month == date.month &&
        this.date.day == date.day;
  }

  bool _isOnWeekly(DateTime date) {
    return this.date.year == date.year &&
        _getWeekOfYear(this.date) == _getWeekOfYear(date);
  }

  bool _isOnMonthly(DateTime date) {
    return this.date.year == date.year && this.date.month == date.month;
  }

  bool _isOnYearly(DateTime date) {
    return this.date.year == date.year;
  }

  String getDateString(DateTime date, StreakInterval streakInterval) {
    switch (streakInterval) {
      case StreakInterval.daily:
        return '${date.day}-${date.month}-${date.year}';
      case StreakInterval.weekly:
        return '${_getWeekOfYear(date)}-${date.year}';
      case StreakInterval.monthly:
        return '${date.month}-${date.year}';
      case StreakInterval.yearly:
        return '${date.year}';
      default:
        throw ArgumentError('Invalid streak interval');
    }
  }

  @override
  String toString() {
    return 'date: ${getDateString(date, StreakInterval.daily)} $countState';
  }
}
