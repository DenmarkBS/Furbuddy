import 'package:flutter/material.dart';

class AppIconTitle extends StatelessWidget {
  const AppIconTitle({Key? key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          const Icon(
            Icons.pets_outlined,
            color: Colors.deepOrange,
            size: 250,
          ),
          const SizedBox(height: 5.0),
          Text(
            '-FURMATES-',
            style: TextStyle(fontSize: 50, color: Colors.black87),
          ),
          const SizedBox(height: 10.0), // Add spacing between the texts
          Text(
            'Furbuddy find a Companion for your pet',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.w100),
          ),
        ],
      ),
    );
  }
}
