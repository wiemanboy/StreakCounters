import 'package:objectbox/objectbox.dart';
import 'package:streak_counters/models/streak.dart';
import '../objectbox.dart';
import 'enums/count_state.dart';

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

  bool isOn(DateTime date) {
    return this.date.year == date.year &&
        this.date.month == date.month &&
        this.date.day == date.day;
  }

  int compareDate(Count other) {
    return date.compareTo(other.date);
  }

  Duration dateDifference(DateTime date) {
    return this.date.difference(date);
  }
}
