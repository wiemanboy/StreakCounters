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

  @Property(type: PropertyType.int)
  int? dbCountStateIndex;

  @Transient()
  CountState? countState;

  Count({required this.date, this.countState}) {
    dbCountStateIndex = countState?.index;
  }

  CountState? get dbCountState {
    CountState.ensureStableEnumValues();
    return dbCountStateIndex != null
        ? CountState.values[dbCountStateIndex!]
        : null;
  }

  set dbCountState(CountState? value) {
    CountState.ensureStableEnumValues();
    dbCountStateIndex = value?.index;
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
}
