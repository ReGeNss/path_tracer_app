import 'package:json_annotation/json_annotation.dart';

part 'response.g.dart'; 

@JsonSerializable(explicitToJson: true, genericArgumentFactories: true, createToJson: false)
class ApiResponse<T>{
  final bool error; 
  final String message;
  final List<T> data;

  ApiResponse({required this.error, required this.message, required this.data});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$ApiResponseFromJson(json, fromJsonT);

}

@JsonSerializable(createToJson: false)
class ApiFailureResponse{
  final bool error; 
  final String message;
  final dynamic data;

  ApiFailureResponse({required this.error, required this.message, required this.data});

  factory ApiFailureResponse.fromJson(Map<String, dynamic> json) => _$ApiFailureResponseFromJson(json);
}