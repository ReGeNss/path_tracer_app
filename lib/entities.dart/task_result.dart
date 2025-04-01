import 'package:path_tracer_app/entities.dart/index.dart';
import '../utils/grid.dart';

class TaskResult{
  final Grid grid;
  final ProcessedTaskPath processedTaskPath; 
  final Coordinates start; 
  final Coordinates end;

  TaskResult(this.grid, this.processedTaskPath, this.start, this.end);
}