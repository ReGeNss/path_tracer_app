import 'package:json_annotation/json_annotation.dart';

part 'task_status.g.dart';

@JsonSerializable(createToJson: false)
class TaskStatus{
  final String id;
  final bool correct;

  TaskStatus({required this.id, required this.correct}); 

  factory TaskStatus.fromJson(Map<String, dynamic> json) => _$TaskStatusFromJson(json);
}