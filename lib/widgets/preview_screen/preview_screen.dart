import 'package:flutter/material.dart';
import 'package:path_tracer_app/entities.dart/index.dart';
import 'package:path_tracer_app/styles.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key, required this.taskResult});

  final TaskResult taskResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview', style: standardTextStyle),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Expanded(
              child: taskResult.grid.buildGridWithPath(
                taskResult.start,
                taskResult.end,
                taskResult.processedTaskPath.result.steps,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  maxLines: null,
                  taskResult.processedTaskPath.result.path,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}