import 'package:flutter/material.dart';
import 'package:path_tracer_app/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: MainRoutes.routes,
    );
  }
}
