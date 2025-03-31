import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'proccess_screen_model.dart';

class ProccessScreen extends StatelessWidget {
  const ProccessScreen({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      lazy: false,
      create: (_) => ProccessScreenModel(url),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Proccessing'),
        ),
        body: ProccessScreenBody(),
      ),
    );
  }
}

class ProccessScreenBody extends StatelessWidget {
  const ProccessScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(child: ProccessingBar()),
            FilledButton(
              onPressed: () => {},
              child: const Text('Send result'),
            ),
          ]
        ),
      ),
    );
  }
}

class ProccessingBar extends StatelessWidget {
  const ProccessingBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 20,
      children: [
        Text('Proccessing...'),
        ProgressCounter(),
        const CircularProgressIndicator(),
      ],
    );
  }
}

class ProgressCounter extends StatelessWidget {
  const ProgressCounter({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context.watch<ProccessScreenModel>().progressStream,
      builder: (context, snapshot) {
        return Text((snapshot.data ?? '0').toString());
      }
    );
  }
}
