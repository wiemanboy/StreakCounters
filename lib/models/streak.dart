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

  bool isGoing() {
    return getStreakLength() > 0;
  }

  bool isActiveOn(DateTime date) {
    return counts.any((Count count) => count.isActiveOn(date, interval!));
  }

  bool isActiveToday() {
    return isActiveOn(clock.now());
  }

  bool isSkippedOn(DateTime date) {
    return counts
        .any((Count count) => count.isOn(date, interval!) && count.isSkipped());
  }

  bool isCompletedOn(DateTime date) {
    return counts.any(
        (Count count) => count.isOn(date, interval!) && count.isCompleted());
  }

  bool isSkippedToday() {
    return isSkippedOn(clock.now());
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
            .where(
                (Count count) => count.getDateString(interval!) == dateString)
            .toList())
        .toList();
  }

  /// returns a list of lists of grouped counts, each list representing a streak
  List<List<List<Count>>> getGroupedStreaks() {
    List<List<Count>> groupedCounts = getGroupedCounts()
        .where((List<Count> counts) =>
            counts.any((Count count) => count.isActive()))
        .toList();

    List<List<List<Count>>> streaks = [];
    List<List<Count>> currentStreak = [];

    groupedCounts.asMap().forEach((index, currentGroup) {
      bool isStartOfStreak = index == 0;
      bool continuesStreak = index > 0 &&
          currentGroup.first.dateDifference(clock.now(), interval!) ==
              groupedCounts[index - 1]
                      .first
                      .dateDifference(clock.now(), interval!) -
                  1;

      if (isStartOfStreak || continuesStreak) {
        currentStreak.add(currentGroup);
      } else {
        if (currentStreak.isNotEmpty) {
          streaks.add(currentStreak);
        }
        currentStreak = [currentGroup];
      }
    });

    if (currentStreak.isNotEmpty) {
      streaks.add(currentStreak);
    }

    return streaks
        .map((List<List<Count>> streak) => streak
            .where((List<Count> counts) =>
                counts.any((Count count) => count.isCompleted()))
            .toList())
        .toList();
  }

  int getStreakLength() {
    if (counts.isEmpty || !isActiveToday()) {
      return 0;
    }

    return getGroupedStreaks().first.length;
  }

  getLongestStreak() {
    return getGroupedStreaks()
        .map((List<List<Count>> streak) => streak.length)
        .reduce((int longest, int current) => current > longest ? current : longest);
  }
}
