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
    return getDateString(interval) == _getDateStringOn(date, interval);
  }

  int compareDate(Count other) {
    return date.compareTo(other.date);
  }

  int dateDifference(DateTime date, StreakInterval interval) {
    switch (interval) {
      case StreakInterval.daily:
        return _dayDifference(date);
      case StreakInterval.weekly:
        return _weeksDifference(date);
      case StreakInterval.monthly:
        return _monthsDifference(date);
      case StreakInterval.yearly:
        return _yearsDifference(date);
    }
  }

  String getDateString(StreakInterval streakInterval) {
    return _getDateStringOn(date, streakInterval);
  }

  int _dayDifference(DateTime date) {
    return this.date.difference(date).inDays;
  }

  int _weeksDifference(DateTime date) {
    return (_getWeekOfYear(this.date) + this.date.year * 52) -
        (_getWeekOfYear(date) + date.year * 52);
  }

  int _monthsDifference(DateTime date) {
    return this.date.year * 12 +
        this.date.month -
        (date.year * 12 + date.month);
  }

  int _yearsDifference(DateTime date) {
    return this.date.year - date.year;
  }

  int _getWeekOfYear(DateTime dateTime) {
    final startOfYear = DateTime(dateTime.year, 1, 1);
    final daysElapsed = dateTime.difference(startOfYear).inDays;
    return ((daysElapsed + startOfYear.weekday - 1) ~/ 7) + 1;
  }

  String _getDateStringOn(DateTime date, StreakInterval interval) {
    switch (interval) {
      case StreakInterval.daily:
        return '${date.day}-${date.month}-${date.year}';
      case StreakInterval.weekly:
        return '${_getWeekOfYear(date) + date.year * 52}';
      case StreakInterval.monthly:
        return '${date.month}-${date.year}';
      case StreakInterval.yearly:
        return '${date.year}';
    }
  }

  @override
  String toString() {
    return 'date: ${getDateString(StreakInterval.daily)} $countState';
  }
}
