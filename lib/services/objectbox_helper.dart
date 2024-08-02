import 'package:streak_counters/objectbox.g.dart'; // generated code
import 'package:streak_counters/models/counter.dart';

class ObjectBoxHelper {
  late final Store store;
  late final Box<Counter> counterBox;

  ObjectBoxHelper._create(this.store) {
    counterBox = Box<Counter>(store);
  }

  static Future<ObjectBoxHelper> create() async {
    final store = await openStore();
    return ObjectBoxHelper._create(store);
  }

  void addCounter(Counter counter) {
    counterBox.put(counter);
  }

  List<Counter> getAllCounters() {
    return counterBox.getAll();
  }

  void updateCounter(Counter counter) {
    counterBox.put(counter);
  }

  void removeCounter(int id) {
    counterBox.remove(id);
  }
}
