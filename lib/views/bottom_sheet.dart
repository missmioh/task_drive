import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/view_models/app_view_model.dart';

class BottomSheetView extends StatelessWidget {
  final String initialText;
  final void Function(String) onSubmit;

  const BottomSheetView({
    super.key,
    required this.initialText,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final entryController = TextEditingController(text: initialText);

    return Consumer<AppViewModel>(
      builder: (context, viewModel, child) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SizedBox(
            height: 100,
            child: Center(
              child: SizedBox(
                height: 40,
                width: 250,
                child: TextField(
                  controller: entryController,
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      onSubmit(value.trim());
                    }
                    Navigator.of(context).pop();
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 5),
                    filled: true,
                    fillColor: viewModel.colorLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      // removes border at the bottom
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                  ),
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  cursorColor: viewModel.colorDarkest,
                  autofocus: true,
                  autocorrect: false,
                  style: TextStyle(
                    color: viewModel.colorDarkest,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
