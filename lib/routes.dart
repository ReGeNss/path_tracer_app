import 'package:flutter/material.dart';
import 'package:path_tracer_app/widgets/preview_screen/preview_screen.dart';
import 'package:path_tracer_app/widgets/result_list_screen/result_list_screen.dart';
import 'entities.dart/index.dart';
import 'widgets/main_screen/main_screen.dart';
import 'widgets/poccess_screen/proccess_screen.dart';

class MainRoutes{
	static const String mainScreen = '/';
	static const String proccessScreen = '/proccess';
  static const String resultListScreen = 'proccess/result_list';
  static const String previewScreen = 'proccess/result_list/preview';

	static Map<String,Widget Function(BuildContext)> routes = {
		mainScreen: (context) => const MainScreen(),
		proccessScreen: (context) {
			final args = ModalRoute.of(context)!.settings.arguments as String;
			return ProccessScreen(url: args);
		},
    resultListScreen: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as List<TaskResult>;
      return ResultListScreen(results: args);
    },
    previewScreen: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as TaskResult;
      return PreviewScreen(taskResult: args);
    },
	};
}