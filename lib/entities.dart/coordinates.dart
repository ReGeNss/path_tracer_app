
import 'package:json_annotation/json_annotation.dart';

part 'coordinates.g.dart';

@JsonSerializable()
class Coordinates{
  final int x;
  final int y;

  Coordinates(this.x, this.y);

  factory Coordinates.fromJson(Map<String, dynamic> json) => _$CoordinatesFromJson(json);
  Map<String, dynamic> toJson() => _$CoordinatesToJson(this);

  @override 
  String toString() => '($x,$y)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Coordinates) return false;
    return x == other.x && y == other.y;
  }

  operator +(Coordinates other) => Coordinates(x + other.x, y + other.y);

  operator -(Coordinates other) => Coordinates(x - other.x, y - other.y);
  
  @override
  int get hashCode => x.hashCode ^ y.hashCode;
  
}