import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'proccess_screen_model.dart';

class ProccessScreen extends StatelessWidget {
  const ProccessScreen({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProccessScreenModel(url: url),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Proccess Screen'),
        ),
        body: Container(),
      ),
    );
  }
}