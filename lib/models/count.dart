import 'package:streak_counters/models/streak.dart';

import '../objectbox.dart';
import 'enums/count_state.dart';

@Entity()
class Count {
  @Id()
  int id = 0;

  ToOne<Streak> streak = ToOne<Streak>();

  @Property(type: PropertyType.date)
  late DateTime date;

  @Transient()
  CountState? countState;

  int? get dbCountState {
    CountState.ensureStableEnumValues();
    return countState?.index;
  }

  set dbCountState(int? value) {
    CountState.ensureStableEnumValues();
    if (value == null) {
      countState = null;
    } else {
      countState = CountState.values[value]; // throws a RangeError if not found
    }
  }

  Count({this.countState = CountState.missed, required DateTime date});

  bool isActiveOn(DateTime date) {
    final dayBefore = date.subtract(Duration(days: 1));
    return this.date.isAfter(dayBefore) &&
        this.date.isBefore(date.add(Duration(days: 1))) &&
        isActive();
  }

  bool isActive() {
    return countState == CountState.completed ||
        countState == CountState.skipped;
  }
}
