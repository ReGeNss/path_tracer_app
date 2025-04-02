import 'package:path_tracer_app/utils/progress/imaginary_progress_counter.dart';
import 'package:path_tracer_app/utils/progress/real_progress_counter.dart';
import 'progress_counter.dart';

class ProgressHandler {
  ProgressCounter? progressCounter;

  RealProgressCounter createProgress(double initialOpedationKoef) {
    progressCounter = RealProgressCounter(initialOpedationKoef);
    return progressCounter as RealProgressCounter;
  }
  
  ImaginaryProgress createImaginaryProgress(Duration duration){
    progressCounter = ImaginaryProgress(duration);
    return progressCounter as ImaginaryProgress;
  } 

  get progressStream => progressCounter?.progressStream;

  void dispose() {
    progressCounter?.dispose();
    progressCounter = null;
  }
}