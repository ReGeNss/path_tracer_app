import 'package:flutter/material.dart';
import 'package:path_tracer_app/styles.dart';
import 'package:provider/provider.dart';
import '../../routes.dart';
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
          centerTitle: true,
          title: const Text(
            'Proccessing',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ), 
          ),
          backgroundColor: Colors.blue,
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
    final model = context.watch<ProccessScreenModel>();
    return Padding(
      padding: standartPadding,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: model.isLoadingSuccess == null
                ? const ProccessingBar()
                : model.isLoadingSuccess == false
                    ? Text(
                      'Something went wrong\n${model.error}',
                      style: standardTextStyle, 
                      textAlign: TextAlign.center,
                    )
                    : const Text(
                      'Tasks proccessed successfully',
                      style: standardTextStyle,
                      textAlign: TextAlign.center,
                    ),
            ),
            AbsorbPointer(
              absorbing: model.isLoadingSuccess != true,
              child: FilledButton(
                onPressed: () {
                  model.sendResults().then(
                    (value) => Navigator.pushNamed(context, MainRoutes.resultListScreen, arguments: model.results)
                  ).catchError(
                    (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $error')),
                      );
                      return false;
                    }
                  );
                  
                },
                child: Text('Send result', style: standardTextStyle.copyWith(
                  color: Colors.white,
                )),
              ),
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
        Text('Proccessing...', style: standardTextStyle.copyWith(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        )),
        const CircularProgressIndicator(
          constraints: BoxConstraints(
            minWidth: 50,
            minHeight: 50,
          ),
        ),
        ProgressCounter(textStyle: standardTextStyle.copyWith(fontSize: 30),),
      ],
    );
  }
}

class ProgressCounter extends StatelessWidget {
  const ProgressCounter({super.key, required this.textStyle});

  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context.watch<ProccessScreenModel>().progressStream,
      builder: (context, snapshot) {
        if(snapshot.data == null) {
          return Container(); 
        }
        return Text("${snapshot.data ?? '0'}%", style: textStyle);
      }
    );
  }
}
