import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'progress_counter.dart';

const _maxProgress = 100;

class RealProgressCounter extends ProgressCounter{
  int _progress = 0;
  int get progress => _progress;
  int _currentOperation = 0;
  int _previousOperationsProgress = 0;

  final List<double> operationsCoefficients = [];

  RealProgressCounter(double startOperationKoef) {
    operationsCoefficients.add(startOperationKoef);
  }

  final _streamController = BehaviorSubject<int>.seeded(0);
  @override
  Stream<int> get progressStream => _streamController.stream;

  void setProgress(int progress) {
    if (_currentOperation >= operationsCoefficients.length) {
      return;
    }

    double newProgress = _previousOperationsProgress + progress * operationsCoefficients[_currentOperation];
    _progress = newProgress.clamp(0, _maxProgress).toInt();
    _streamController.add(_progress);
    debugPrint('Progress: $_progress, Current Op: $_currentOperation');
  }

  void nextOperation() {
    setProgress(_maxProgress);
    if (_currentOperation < operationsCoefficients.length - 1) {
      _previousOperationsProgress = _progress;
      _currentOperation++;
    }
  }

  void addOperations(List<double> coefficients) {
    double sum = operationsCoefficients.fold(0, (a, b) => a + b);
    List<double> normalizedCoefficients = coefficients.map((coef) => coef * (1 - sum)).toList();
    operationsCoefficients.addAll(normalizedCoefficients);
    if(_progress >= 100 &&  operationsCoefficients.length - 1 - _currentOperation == 1){
      nextOperation();
    }
  }

  @override
  void dispose(){
    _streamController.close();
  }
}

