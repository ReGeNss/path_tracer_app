import 'package:json_annotation/json_annotation.dart';
import 'index.dart';

part 'task.g.dart';

@JsonSerializable(createToJson: false, explicitToJson: true)
class Task{
  final String id;
  @JsonKey(fromJson: _fieldToLists)
  final List<List<bool>> field;
  final Coordinates start;
  final Coordinates end;

  Task({required this.id, required this.field, required this.start, required this.end});
  
  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  static List<Task> listFromJson(List<dynamic> json) {
    return json.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();
  }

  static List<List<bool>> _fieldToLists(List<dynamic> rows){
    return rows.map((row) => (row as String).split('').map((char) => char == '.').toList()).toList();
  }
}