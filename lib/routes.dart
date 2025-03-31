import 'package:flutter/material.dart';
import 'widgets/main_screen/main_screen.dart';
import 'widgets/poccess_screen/proccess_screen.dart';

class MainRoutes{
	static const String mainScreen = '/';
	static const String proccessScreen = '/poccess';

	static Map<String,Widget Function(BuildContext)> routes = {
		mainScreen: (context) => const MainScreen(),
		proccessScreen: (context) {
			final args = ModalRoute.of(context)!.settings.arguments as String;
			return ProccessScreen(url: args);
		},
	};
}