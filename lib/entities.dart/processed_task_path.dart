import 'package:json_annotation/json_annotation.dart';
import 'index.dart';

part 'processed_task_path.g.dart';

@JsonSerializable(explicitToJson: true)
class ProcessedTaskPath extends Sendable{
  final String id; 
  final Result result; 

  ProcessedTaskPath({required this.id, required this.result});  

  factory ProcessedTaskPath.fromJson(Map<String, dynamic> json) => _$ProcessedTaskPathFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$ProcessedTaskPathToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Result{
  final List<Coordinates> steps; 
  final String path;
  Result(this.steps, this.path);

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);
  Map<String, dynamic> toJson() => _$ResultToJson(this);
}