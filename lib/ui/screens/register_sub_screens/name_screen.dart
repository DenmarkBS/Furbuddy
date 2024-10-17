import 'package:flutter/material.dart';
import 'package:tinder_new/ui/widgets/bordered_text_field.dart';

class NameScreen extends StatefulWidget {
  final Function(String) userName;
  final Function(num) userAge;
  final Function(String) emailOnChanged;
  final Function(String) passwordOnChanged;
  final Function(String) confirmPasswordOnChanged;

  const NameScreen({
    Key? key,
    required this.userName,
    required this.userAge,
    required this.emailOnChanged,
    required this.passwordOnChanged,
    required this.confirmPasswordOnChanged
  }) : super(key: key);

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Icon(Icons.pets, size: 140, color: Colors.deepOrange), // Icon only
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              'HELLO THERE',
              style: TextStyle(
                  fontSize: 50, color: Colors.black, fontFamily: 'Default',
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: const Text(
              'Register Below',
              style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black
              ),
            ),
          ),
          const SizedBox(height: 25),
          BorderedTextField(
            labelText: "Username",
            onChanged: widget.userName,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 10),
          BorderedTextField(
            labelText: "Age",
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {});
              widget.userAge(int.tryParse(value) ?? 0);
            },
          ),
          const SizedBox(height: 10),
          BorderedTextField(
            labelText: 'Email',
            onChanged: widget.emailOnChanged,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 10),
          BorderedTextField(
            labelText: 'Password',
            onChanged: widget.passwordOnChanged,
            obscureText: false,
          ),
          const SizedBox(height: 10),
          BorderedTextField(
            labelText: 'Confirm Password',
            onChanged: widget.confirmPasswordOnChanged,
            obscureText: true,
          ),
        ],
      ),
    );
  }
}
