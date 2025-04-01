import 'dart:async';

import 'package:flutter/material.dart';

class ProgressCounter {
  int _progress = 0;
  int get progress => _progress;
  int _currentOperation = 0;
  int _previousOperationsProgress = 0;

  final List<double> operationsCoefficients = [];

  ProgressCounter();

  final _streamController = StreamController<int>.broadcast();
  Stream<int> get progressStream => _streamController.stream;



  void setProgress(int progress) {
    if (_currentOperation >= operationsCoefficients.length) {
      return;
    }

    double weightedProgress =
        (_previousOperationsProgress + progress * operationsCoefficients[_currentOperation]);

    _progress = weightedProgress.clamp(0, 100).toInt();
    _streamController.add(_progress);

    debugPrint('Progress: $_progress, Current Op: $_currentOperation');

    if (_progress >= 100) {
      nextOperation();
    }

    
  }

  void dispose(){
    _progress = 0;
    _currentOperation = 0;
    _previousOperationsProgress = 0;
    operationsCoefficients.clear();
    _streamController.close();
  }

  void nextOperation() {
    if (_currentOperation < operationsCoefficients.length - 1) {
      _previousOperationsProgress = _progress;
      _currentOperation++;
    }
  }

  void addOperations(List<double> coefficients) {
    double sum = operationsCoefficients.fold(0, (a, b) => a + b);
    List<double> normalizedCoefficients = coefficients.map((coef) => coef * (1 - sum)).toList();
    operationsCoefficients.addAll(normalizedCoefficients);
  }
}