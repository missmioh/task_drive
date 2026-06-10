import 'package:flutter/material.dart';
import 'package:todo_app/view_models/app_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppViewModel(),
      child: const AddictiveTasks(),
    ),
  );
}

class AddictiveTasks extends StatelessWidget {
  const AddictiveTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Consumer<AppViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: viewModel.colorDarkest,
              title: const Text('Addictive Tasks'),
            ),
            body: Column(
              children: [
                // header, wo z.B. User-Daten stehen könnten
                Expanded(
                  flex: 1,
                  child: Container(color: viewModel.colorLight),
                ),

                // Infos über die Tasks (z.B. wie viele übrig sind)
                // Könnte aber auch für die Kategorien-Unterseite sein
                Expanded(
                  flex: 1,
                  child: Container(color: viewModel.colorMedium),
                ),

                // Ansicht der Listen-Elemente
                Expanded(flex: 7, child: Container(color: viewModel.colorDark)),
              ],
            ),

            floatingActionButton: FloatingActionButton(
              onPressed: () {
                print('printing pressed...');
              },
              backgroundColor: viewModel.colorDarkest,
              child: Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
