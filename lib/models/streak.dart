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

  bool isCompletedToday() {
    return isCompletedOn(DateTime.now());
  }

  bool isCompletedOn(DateTime date) {
    return counts.any((Count count) =>
        count.isOn(date) &&
        count.isCompleted());
  }

  int getStreakLength() {
    return counts.reversed
        .takeWhile((Count count) => count.isActive())
        .where((Count count) => count.isCompleted())
        .length;
  }
}
