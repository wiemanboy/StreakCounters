import 'package:streak_counters/objectbox.g.dart'; // generated code
import 'package:streak_counters/models/streak.dart';

class ObjectBoxHelper {
  late final Store store;
  late final Box<Streak> counterBox;

  ObjectBoxHelper._create(this.store) {
    counterBox = Box<Streak>(store);
  }

  static Future<ObjectBoxHelper> create() async {
    final store = await openStore();
    return ObjectBoxHelper._create(store);
  }

  void addCounter(Streak counter) {
    counterBox.put(counter);
  }

  List<Streak> getAllCounters() {
    return counterBox.getAll();
  }

  void updateCounter(Streak counter) {
    counterBox.put(counter);
  }

  void removeCounter(int id) {
    counterBox.remove(id);
  }
}
