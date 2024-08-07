import 'package:clock/clock.dart';

import '../objectbox.dart';
import 'count.dart';
import 'enums/count_state.dart';
import 'enums/streak_interval.dart';

@Entity()
class Streak {
  @Id()
  int id = 0;

  String name;

  @Backlink()
  ToMany<Count> counts = ToMany<Count>();

  @Transient()
  StreakInterval? interval;

  int? get dbInterval {
    return interval?.index;
  }

  set dbInterval(int? value) {
    interval = value != null ? StreakInterval.values[value] : null;
  }

  Streak({required this.name, this.interval});

  void completeToday() {
    addCount(Count(date: clock.now(), countState: CountState.completed));
  }

  void addCount(Count newCount) {
    counts.add(Count(date: newCount.date, countState: newCount.countState));
  }

  bool isActiveOn(DateTime date) {
    return counts
        .any((Count count) => count.isOn(date, interval!) && count.isActive());
  }

  bool isActiveToday() {
    return isActiveOn(clock.now());
  }

  bool isCompletedOn(DateTime date) {
    return counts.any(
        (Count count) => count.isOn(date, interval!) && count.isCompleted());
  }

  bool isCompletedToday() {
    return isCompletedOn(clock.now());
  }

  List<List<Count>> getGroupedCounts() {
    counts.sort((Count countA, Count countB) => countB.compareDate(countA));
    return counts
        .map((Count count) => count.getDateString(interval!))
        .toSet()
        .map((String dateString) => counts
            .where((Count count) =>
                count.getDateString(interval!) == dateString)
            .toList())
        .toList();
  }

  int getStreakLength() {
    if (counts.isEmpty) {
      return 0;
    }

    counts.sort((Count countA, Count countB) => countB.compareDate(countA));

    return getGroupedCounts()
        .indexed
        .takeWhile(((int, List<Count>) indexedCounts) =>
            indexedCounts.$2.any((Count count) => count.isActive()) &&
            indexedCounts.$2.any((Count count) =>
                count.dateDifference(clock.now(), interval!) * -1 ==
                indexedCounts.$1))
        .where(((int, List<Count>) indexedCounts) =>
            indexedCounts.$2.any((Count count) => count.isCompleted()))
        .toList()
        .length;
  }
}
