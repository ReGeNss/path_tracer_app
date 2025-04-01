// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponse<T> _$ApiResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    ApiResponse<T>(
      error: json['error'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>).map(fromJsonT).toList(),
    );

ApiFailureResponse _$ApiFailureResponseFromJson(Map<String, dynamic> json) =>
    ApiFailureResponse(
      error: json['error'] as bool,
      message: json['message'] as String,
      data: json['data'],
    );
