import 'package:flutter/material.dart';
import 'package:tinder_new/ui/widgets/bordered_text_field.dart';
import 'package:tinder_new/util/constants.dart';

class InputDialog extends StatefulWidget {
  final String labelText;
  final Function(String) onSavePressed;
  final String startInputText;

  const InputDialog({
    Key? key,
    required this.labelText,
    required this.onSavePressed,
    this.startInputText = '',
  }) : super(key: key);

  @override
  InputDialogState createState() => InputDialogState();
}

class InputDialogState extends State<InputDialog> {
  late String inputText;
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    inputText = widget.startInputText;
    textController.text = inputText;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(16.0),
      content: BorderedTextField(
        textCapitalization: TextCapitalization.sentences,
        labelText: widget.labelText,
        autoFocus: true,
        keyboardType: TextInputType.text,
        onChanged: (value) => setState(() => inputText = value),
        textController: textController,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'CANCEL',
            style: TextStyle(
              color: Colors.orange, // Set text color to orange
              fontSize: 16, // Adjust font size
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            widget.onSavePressed(inputText);
            Navigator.pop(context);
          },
          child: Text(
            'SAVE',
            style: TextStyle(
              color: Colors.orange, // Set text color to orange
              fontSize: 16, // Adjust font size
            ),
          ),
        ),
      ],
    );
  }
}
