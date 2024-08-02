import '../objectbox.dart';
import 'count.dart';
import 'enums/count_state.dart';

@Entity()
class Streak {
  @Id()
  int id = 0;

  String name;

  @Backlink()
  ToMany<Count> counts = ToMany<Count>();

  Streak({required this.name});

  void completeToday() {
    addCount(Count(date: DateTime.now(), countState: CountState.completed));
  }

  void addCount(Count newCount) {
    if (isCompletedToday()) {
      return;
    }
    counts.add(Count(date: newCount.date, countState: newCount.countState));
  }

  bool isActiveOn(DateTime date) {
    return counts.any((Count count) => count.isOn(date) && count.isActive());
  }

  bool isActiveToday() {
    return isActiveOn(DateTime.now());
  }

  bool isCompletedOn(DateTime date) {
    return counts.any((Count count) => count.isOn(date) && count.isCompleted());
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
            count.dateDifference(DateTime.now()).inDays * -1 ==
                counts.indexOf(count))
        .where((Count count) => count.isCompleted())
        .length;
  }
}
