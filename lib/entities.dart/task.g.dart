// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      id: json['id'] as String,
      field: Task._fieldToLists(json['field'] as List<dynamic>),
      start: Coordinates.fromJson(json['start'] as Map<String, dynamic>),
      end: Coordinates.fromJson(json['end'] as Map<String, dynamic>),
    );
