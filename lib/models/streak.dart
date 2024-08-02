import '../objectbox.dart';
import 'count.dart';
import 'enums/count_state.dart';

@Entity()
class Streak {
  @Id()
  int id = 0;

  String name;

  int value;

  @Backlink()
  ToMany<Count> counts = ToMany<Count>();

  Streak({required this.name, this.value = 0});

  void completeToday() {
    counts.add(Count(date: DateTime.now(), countState: CountState.completed));
  }

  bool isActive(DateTime date) {
    if (counts.isEmpty) {
      return false;
    }
    return counts.last.isActiveOn(date);
  }

  bool isActiveToday() {
    return isActive(DateTime.now());
  }

  int getStreakLength() {
    final today = DateTime.now();

    final streakCounts = counts.reversed
        .takeWhile((count) => count.isActiveOn(today
            .subtract(Duration(days: counts.reversed.toList().indexOf(count)))))
        .toList();

    return streakCounts.length;
  }
}
