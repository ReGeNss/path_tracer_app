import 'package:json_annotation/json_annotation.dart';
import 'index.dart';

part 'result.g.dart';

@JsonSerializable(explicitToJson: true)
class Result {
  final String id; 
  final List<Coordinates> result; 
  final String path;

  Result({required this.id, required this.result, required this.path});  

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);
  Map<String, dynamic> toJson() => _$ResultToJson(this);
}