import 'package:floor/floor.dart';

@entity
class Todo {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final String quantity;

  Todo({this.id, required this.name, required this.quantity});
}
