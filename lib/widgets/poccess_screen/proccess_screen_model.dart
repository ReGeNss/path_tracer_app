import 'dart:async';
import 'package:flutter/material.dart';
import '../../entities.dart/index.dart';
import '../../pathfinder.dart';
import '../../services/http_service.dart';

const _loadedTaskProgress = 50;

class ProccessScreenModel extends ChangeNotifier{
  final String url;
  final _httpService = HttpService();
  List<Task> _tasks = [];
  String? error; 

  final streamController = StreamController<int>.broadcast();
  Stream<int> get progressStream => streamController.stream;

  ProccessScreenModel(this.url){
    proccessTasks();
  }

  Future<void> proccessTasks() async{
    streamController.add(0);
    await loadTasks();
    streamController.add(_loadedTaskProgress);
    _tasks.add(Task(id: '1', 
      field: [
        [true, true, true],
        [true, false, true],
        [true, false, true]
      ],
     start: Coordinates(x: 0, y: 2), end: Coordinates(x: 2, y: 2)));
    final grid = Grid.generateFromMatrix(_tasks[0].field,);
    final pathfinder = Pathfinder(grid: grid, emitProgressEvent: setFindingProgress);
    final path = pathfinder.findPath(_tasks[0].start, _tasks[0].end);
    streamController.add(100);
  }

  void setFindingProgress(int progress) {
    streamController.add(50 + progress ~/ 2);
  }

  Future<void> loadTasks() async {
    try{
      _tasks = await _httpService.getTasks(url);
    }catch(e){
      error = e.toString();
      print('Error loading tasks: $e');
    }
    notifyListeners();
  }
}