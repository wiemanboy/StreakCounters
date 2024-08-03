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
    addCount(Count(date: DateTime.now(), countState: CountState.completed));
  }

  void addCount(Count newCount) {
    counts.add(Count(date: newCount.date, countState: newCount.countState));
  }

  bool isActiveOn(DateTime date) {
    return counts
        .any((Count count) => count.isOn(date, interval!) && count.isActive());
  }

  bool isActiveToday() {
    return isActiveOn(DateTime.now());
  }

  bool isCompletedOn(DateTime date) {
    return counts.any(
        (Count count) => count.isOn(date, interval!) && count.isCompleted());
  }

  bool isCompletedToday() {
    return isCompletedOn(DateTime.now());
  }

  int getStreakLength() {
    if (counts.isEmpty || !isActiveToday()) {
      return 0;
    }

    counts.sort((Count countA, Count countB) => countB.compareDate(countA));

    return counts
        .takeWhile((Count count) =>
            count.isActive() &&
            count.dateDifference(DateTime.now(), interval!) * -1 ==
                counts.indexOf(count))
        .where((Count count) => count.isCompleted())
        .length;
  }
}
