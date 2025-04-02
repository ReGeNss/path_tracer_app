import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'progress_counter.dart';

const _maxProgress = 99;

class ImaginaryProgress extends ProgressCounter{
  final Duration duration;
  final _streamController = BehaviorSubject<int>.seeded(0);
  Timer? _timer;

  ImaginaryProgress(this.duration){
    final time = duration.inMicroseconds;
    final interval = Duration(microseconds: time ~/ _maxProgress);
    _timer = Timer.periodic(interval, (timer) {
      if (_streamController.value >= _maxProgress) {
        timer.cancel();
      } else {
        _streamController.add(_streamController.value + 1);
      }
    });
  }

  @override
  Stream<int> get progressStream => _streamController.stream;

  @override
  void dispose(){
    _timer?.cancel();
    _streamController.close();
  }
}

