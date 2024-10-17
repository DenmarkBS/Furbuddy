import 'package:flutter/material.dart';
import 'package:tinder_new/ui/widgets/bordered_text_field.dart';
import 'package:tinder_new/ui/widgets/bordered_text_field2.dart';

class EmailAndPasswordScreen extends StatefulWidget {
  final Function(String) location;

  const EmailAndPasswordScreen({Key? key, required this.location}) : super(key: key);

  @override
  State<EmailAndPasswordScreen> createState() => _EmailAndPasswordScreenState();
}

class _EmailAndPasswordScreenState extends State<EmailAndPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Location',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          SizedBox(height: 25),
          Container(
            width: 350,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.transparent,
              image: DecorationImage(
                image: AssetImage('images/map.png'), // replace with your image asset
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: 10),
          BorderedTextField2(
            labelText: "Enter your City Location",
            onChanged: widget.location,
            textCapitalization: TextCapitalization.words,
            suggestions: [
              "Manila City",
              "Quezon City",
              "Caloocan City",
              "Pasay City",
              "Makati City",
              "Taguig City",
              "Mandaluyong City",
              "Pasig City",
              "Marikina City",
              "Muntinlupa City",
              "Parañaque City",
              "Las Piñas City",
              "Valenzuela City",
              "Navotas City",
              "Malabon City"],
          ),
        ],
      ),
    );
  }
}
