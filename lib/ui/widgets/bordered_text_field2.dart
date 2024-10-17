import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import 'package:easy_autocomplete/easy_autocomplete.dart'; // Import the easy_autocomplete package

class BorderedTextField2 extends StatefulWidget {
  final String labelText;
  final Function(String) onChanged;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool autoFocus;
  final TextCapitalization textCapitalization;
  final TextEditingController? textController;
  final bool showDatePicker;
  final bool readOnly;
  final List<String>? suggestions; // List of suggestions for autocomplete

  const BorderedTextField2({
    Key? key,
    required this.labelText,
    required this.onChanged,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.autoFocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.textController,
    this.showDatePicker = false,
    this.readOnly = false,
    this.suggestions, // Add suggestions parameter
  }) : super(key: key);

  @override
  _BorderedTextField2State createState() => _BorderedTextField2State();
}

class _BorderedTextField2State extends State<BorderedTextField2> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = widget.textController ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.suggestions != null) {
      return EasyAutocomplete(
        controller: _textEditingController,
        suggestions: widget.suggestions!,
        onChanged: (text) {
          widget.onChanged(text!);
        },
        textCapitalization: widget.textCapitalization,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          fillColor: Colors.grey[200],
          filled: true,
          labelText: widget.labelText,
          labelStyle: TextStyle(color: Colors.black45), // Set label color
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          suffixIcon: widget.showDatePicker ? Icon(null) : null, // Remove select date icon
        ),

      );
    } else {
      return TextField(
        controller: _textEditingController,
        onChanged: widget.onChanged,
        obscureText: widget.obscureText,
        autofocus: widget.autoFocus,
        keyboardType: widget.keyboardType,
        textCapitalization: widget.textCapitalization,
        onTap: () {
          if (widget.showDatePicker) {
            _selectDate(context);
          }
        },
        readOnly: widget.readOnly,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          fillColor: Colors.grey[200],
          filled: true,
          labelText: widget.labelText,
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          suffixIcon: widget.showDatePicker ? Icon(null) : null, // Remove select date icon
        ),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
      initialDatePickerMode: DatePickerMode.day, // Set initial mode to day
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue, // Set primary color of the date picker
              onPrimary: Colors.white, // Set text color on primary color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue, // Set text color of buttons
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != DateTime.now()) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked); // Format the date
      setState(() {
        _textEditingController.text = formattedDate; // Update the text field with formatted date
      });
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
