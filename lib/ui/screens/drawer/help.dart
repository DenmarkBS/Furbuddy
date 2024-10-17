import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../util/constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Help Desk',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Help(),
    );
  }
}

class Help extends StatefulWidget {
  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  final TextEditingController problemController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactInfoController = TextEditingController();
  bool receiveUpdates = false;
  bool isLoading = false;

  final CollectionReference problemsCollection =
      FirebaseFirestore.instance.collection('problems');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Help Desk',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      backgroundColor: kPrimaryColor, // Set body color to white

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Help and Support',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'If you have any problems or need assistance, please let us know by filling out the form below.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              TextField(
                controller: problemController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Describe Your Problem',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white, // Set background color to white
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Your Name (Optional)',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white, // Set background color to white
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: contactInfoController,
                decoration: InputDecoration(
                  labelText: 'Contact Information (Optional)',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white, // Set background color to white
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: receiveUpdates,
                    onChanged: (value) {
                      setState(() {
                        receiveUpdates = value ?? false;
                      });
                    },
                  ),
                  Text('Receive updates on your reported problem'),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: isLoading ? null : submitProblem,
                child: isLoading
                    ? CircularProgressIndicator()
                    : Text(
                        'Submit Problem',
                        style: TextStyle(
                          color: Colors.white, // Set text color to white
                          fontSize: 16.0,
                        ),
                      ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors
                      .deepOrange, // Set button background color to orange
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10.0), // Set button border radius
                  ),
                  elevation: 0, // Remove button shadow
                  padding: EdgeInsets.symmetric(vertical: 16.0), // Set padding
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submitProblem() async {
    setState(() {
      isLoading = true;
    });

    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        final String? userEmail = user.email;
        if (userEmail != null) {
          await problemsCollection.doc(userEmail).set({
            'problem': problemController.text,
            'name': nameController.text,
            'contactInfo': contactInfoController.text,
            'receiveUpdates': receiveUpdates,
            'timestamp': DateTime.now(),
          });

          // Show a success message to the user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Problem submitted successfully!'),
              duration: Duration(seconds: 2),
            ),
          );

          // Clear the text fields after successful submission
          problemController.clear();
          nameController.clear();
          contactInfoController.clear();
          setState(() {
            receiveUpdates = false;
          });
        }
      }
    } catch (e) {
      // Handle network or other errors
      print('Error: $e');

      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again later.'),
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
