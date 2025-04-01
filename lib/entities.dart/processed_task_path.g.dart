// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'processed_task_path.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProcessedTaskPath _$ProcessedTaskPathFromJson(Map<String, dynamic> json) =>
    ProcessedTaskPath(
      id: json['id'] as String,
      result: Result.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProcessedTaskPathToJson(ProcessedTaskPath instance) =>
    <String, dynamic>{
      'id': instance.id,
      'result': instance.result.toJson(),
    };

Result _$ResultFromJson(Map<String, dynamic> json) => Result(
      (json['steps'] as List<dynamic>)
          .map((e) => Coordinates.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['path'] as String,
    );

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'steps': instance.steps.map((e) => e.toJson()).toList(),
      'path': instance.path,
    };
