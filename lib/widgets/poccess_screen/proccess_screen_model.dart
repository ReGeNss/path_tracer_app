import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_tracer_app/utils/progress_counter.dart';
import '../../entities.dart/index.dart';
import '../../utils/grid.dart';
import '../../utils/pathfinder.dart';
import '../../services/http_service.dart';


class ProccessScreenModel extends ChangeNotifier{
  final String url;
  final _httpService = HttpService();
  final ProgressCounter _progressCounter = ProgressCounter();
  final List<TaskResult> results = [];
  String? error; 
  bool _isProccessed = false;
  bool? get isLoadingSuccess{
    if(error != null) return false;
    if(_isProccessed) return true;
    return null;
  }

  Stream<int>? get progressStream => _progressCounter.progressStream;

  ProccessScreenModel(this.url){
    proccessTasks();
  }

  Future<void> proccessTasks() async{
    _progressCounter.addOperations([0.5]); 
    _progressCounter.setProgress(0);
    final tasks = await loadTasks();
    _progressCounter.setProgress(100);
    _progressCounter.addOperations(List.filled(tasks.length, 1/tasks.length));
    _progressCounter.nextOperation();
    for (final task in tasks){
      final grid = Grid.generateFromMatrix(task.field);
      final pathfinder = Pathfinder(
        grid: grid,
        emitProgressEvent: _progressCounter.setProgress,
      );
      final path = pathfinder.findPath(task.start, task.end);
      final result = ProcessedTaskPath(id: task.id, result: Result(path, path.map((task) => task.toString()).toList().join('->') ));
      results.add(TaskResult(grid, result, task.start, task.end));
      _progressCounter.nextOperation();
    }
    _isProccessed = true;
    _progressCounter.dispose(); 
    notifyListeners();
  }

  Future<List<Task>> loadTasks() async {
    try{
      return await _httpService.getTasks(url);
    }catch(e){
      error = e.toString();
      notifyListeners();
      return [];
    }
  }

  Future<List<TaskStatus>> sendResults() async{
    _isProccessed = false; 
    notifyListeners();
    final response = await _httpService.sendResults(url, results.map((e) => e.processedTaskPath).toList());
    for(final taskStatus in response){
      if(!taskStatus.correct) throw Exception();
    }
    _isProccessed = true;
    return response;
  }
}