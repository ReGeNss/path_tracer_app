import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_tracer_app/utils/progress/progress_handler.dart';
import '../../entities.dart/index.dart';
import '../../utils/grid.dart';
import '../../utils/pathfinder.dart';
import '../../services/http_service.dart';

const _taskLoadingProgressKoef = 0.5; 
const _expectedServerResponseTime = Duration(seconds: 5);

class ProccessScreenModel extends ChangeNotifier{
  final String url;
  final _httpService = HttpService();
  final ProgressHandler _progressHandler = ProgressHandler();
  final List<TaskResult> _results = [];
  List<TaskResult> get results => _results;
  bool error = false;
  String? _message; 
  String? get message => _message;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool isResultsSended = false;

  Stream<int>? get progressStream => _progressHandler.progressStream;

  ProccessScreenModel(this.url){
    proccess(proccessTasks, 'Loading tasks', 'Tasks loaded and calculated successfully!');
  }

  Future<void> proccess(Function funcToProcess, String proccessingMessage, String completeMessage) async{
    _message = proccessingMessage;
    _isLoading = true;
    notifyListeners();
    try{
      await funcToProcess();
      _message = completeMessage;
    }catch(e){
      _message = 'Error while $proccessingMessage: ${e.toString()}';
      error = true;
    } finally{
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<void> proccessTasks() async{
    final progress = _progressHandler.createProgress(_taskLoadingProgressKoef);
    final tasks = await loadTasks();
    progress.addOperations(List.filled(tasks.length, 1/tasks.length));
    progress.nextOperation();
    for (final task in tasks){
      final grid = Grid.generateFromMatrix(task.field);
      final pathfinder = Pathfinder(
        grid: grid,
        emitProgressEvent: progress.setProgress,
      );
      final path = await pathfinder.findPath(task.start, task.end);
      final result = ProcessedTaskPath(id: task.id, result: Result(path, path.map((task) => task.toString()).toList().join('->') ));
      _results.add(TaskResult(grid, result, task.start, task.end, null));
      progress.nextOperation();
    }
    _progressHandler.dispose(); 
    notifyListeners();
  }

  Future<List<Task>> loadTasks() async {
    return await _httpService.getTasks(url);
  }

  Future<void> sendResults() async{
    if(_results.isEmpty) return;
    _progressHandler.createImaginaryProgress(const Duration(seconds: 10));
    await proccess(_sendResults, 'Sending results', 'Results sent successfully!');
    _progressHandler.dispose();
  }

  Future<List<TaskStatus>> _sendResults() async{
    notifyListeners();
    await Future.delayed(_expectedServerResponseTime);
    final response = await _httpService.sendResults(url, _results.map((e) => e.processedTaskPath).toList());
    for(final taskStatus in response){
      final task = _results.firstWhere((element) => element.processedTaskPath.id == taskStatus.id);
      task.correct = taskStatus.correct;
      if(!taskStatus.correct) {
        error = true;
        _message = 'Error: ${taskStatus.id } - ${taskStatus.correct}';
      }
    }
    isResultsSended = true;
    return response;
  }
}