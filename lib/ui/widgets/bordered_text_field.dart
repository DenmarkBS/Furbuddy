import 'package:flutter/material.dart';

class BorderedTextField extends StatelessWidget {
  final String labelText;
  final Function(String) onChanged;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool autoFocus;
  final TextCapitalization textCapitalization;
  final TextEditingController? textController;

  const BorderedTextField({
    Key? key,
    required this.labelText,
    required this.onChanged,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.autoFocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.textController,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color color = Colors.white;
    Color tColor = Colors.black; // Change text color to black
    Color labelColor = Colors.black45;

    return TextField(
      controller: textController,
      onChanged: onChanged,
      obscureText: obscureText,
      autofocus: autoFocus,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      style: TextStyle(color: tColor), // Set text color to black
      decoration: InputDecoration(
        fillColor: Colors.grey[200],
        filled: true,
        labelText: labelText,
        labelStyle: TextStyle(color: labelColor),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1), // Border width 2 pixels
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1), // Border width 2 pixels
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1), // Border width 2 pixels
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

}
