import 'package:flutter/material.dart';

import '../../../util/constants.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About Us',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
        elevation: 0, // Remove app bar shadow
      ),
      backgroundColor: kPrimaryColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to FurMates!',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'About Our App',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'FurMates is a mobile application designed to connect dog owners, share tips, find pet-friendly locations, and provide a platform for socializing among furry friends.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Email: furbuddysupport@gmail.com',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Phone: +1 (123) 456-7890',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AboutUsPage(),
  ));
}
