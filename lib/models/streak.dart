import '../objectbox.dart';

@Entity()
class Streak {
  @Id()
  int id = 0;

  String name;

  int value;



  Streak({required this.name, this.value = 0});
}
