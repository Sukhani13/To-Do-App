import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType()
class Note extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  Note(this.title, this.description);
}
