import 'package:objectbox/objectbox.dart';

@Entity()
class Counter {
  int id = 0;

  @Unique()
  String key;

  int value;

  Counter({required this.key, this.value = 0});
}
