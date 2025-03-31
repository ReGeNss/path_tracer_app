import 'package:flutter/material.dart';
import 'package:path_tracer_app/routes.dart';
import 'package:path_tracer_app/widgets/main_screen/main_screen_model.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MainScreenModel(),
      child: Scaffold(
        body: MainScreenBodyWidget()
      ),
    );
  }
}

class MainScreenBodyWidget extends StatelessWidget {
  MainScreenBodyWidget({
    super.key,
  });

  final textFieldController = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    textFieldController.text = 'https://flutter.webspark.dev/flutter/api'; 
    final model = context.read<MainScreenModel>();
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InputFieldWidget(textFieldController: textFieldController), 
          FilledButton(
            onPressed: (){
              if(!model.validateApiUrl(textFieldController.text)){
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter valid API base URL'))
                );
                return;
              }
              model.setApiBaseUrl(textFieldController.text);
              Navigator.pushNamed(context, MainRoutes.proccessScreen, arguments: textFieldController.text);
            }, 
            child: Text('Start counting prossess')
          ),
        ],
      ),
    );
  }
}

class InputFieldWidget extends StatelessWidget {
  const InputFieldWidget({super.key, required this.textFieldController});
  final TextEditingController textFieldController; 

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Enter valid API base URL',),
          TextField(
            controller: textFieldController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'API Base URL',
            ),
        ),
      ],
    );
  }
}

