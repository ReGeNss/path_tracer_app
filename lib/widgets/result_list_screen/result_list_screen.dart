import 'package:flutter/material.dart';
import 'package:path_tracer_app/styles.dart';
import '../../entities.dart/index.dart';
import '../../routes.dart';

class ResultListScreen extends StatelessWidget {
  const ResultListScreen({super.key, required this.results});

  final List<TaskResult> results;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Results list', style: standardTextStyle),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView.separated(
          itemCount: results.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            Color? tileColor;
            if (results[index].correct == true) {
              tileColor = Colors.green;
            } else if (results[index].correct == false) {
              tileColor = Colors.red;
            } else {
              tileColor = null;
            }
            return ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              title: Text(
                results[index].processedTaskPath.result.path,
                style: standardTextStyle
              ),
              subtitle: Text(
                "id: ${results[index].processedTaskPath.id}",
                style: standardTextStyle.copyWith(
                  fontSize: 12,
                ),
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              tileColor: tileColor,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MainRoutes.previewScreen,
                  arguments: results[index],
                );
              },
            );
          },
        ),
      )
    );
  }
}