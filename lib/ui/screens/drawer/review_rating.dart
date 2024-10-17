import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseFirestore.instance.settings;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Review & Rating Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ReviewRatingPage(),
    );
  }
}

class ReviewRatingPage extends StatefulWidget {
  @override
  _ReviewRatingPageState createState() => _ReviewRatingPageState();
}

class _ReviewRatingPageState extends State<ReviewRatingPage> {
  int userRating = 1;
  String userReview = '';
  final CollectionReference ratingsCollection =
  FirebaseFirestore.instance.collection('ratings');
  User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rate this App',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildEmojiLabel('😡', 'Angry'),
                _buildEmojiLabel('😟', 'Sad'),
                _buildEmojiLabel('😐', 'Neutral'),
                _buildEmojiLabel('🙂', 'Happy'),
                _buildEmojiLabel('😄', 'Very Happy'),
              ],
            ),
            Slider(
              value: userRating.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              onChanged: (value) {
                setState(() {
                  userRating = value.toInt();
                });
              },
              label: userRating.toString(),
            ),
            TextField(
              controller: reviewController,
              decoration: InputDecoration(
                labelText: 'Leave a review or comment',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            FloatingActionButton.extended(
              onPressed: () {
                userReview = reviewController.text;
                _storeOrUpdateRating(userRating, userReview);
                _showThankYouDialog();
                reviewController.clear();  // Clear the text field
              },
              label: Text('Submit'),
              icon: Icon(Icons.check),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmojiLabel(String emoji, String label) {
    return Column(
      children: [
        Text(
          emoji,
          style: TextStyle(fontSize: 30),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  void _storeOrUpdateRating(int rating, String review) async {
    if (user != null) {
      final String? userEmail = user!.email;
      if (userEmail != null) {
        final QuerySnapshot<Object?> existingRatings =
        await ratingsCollection.where('userId', isEqualTo: userEmail).get();

        if (existingRatings.docs.isNotEmpty) {
          // If user has previously rated, update their rating and review
          ratingsCollection.doc(existingRatings.docs.first.id).update({
            'rating': rating,
            'review': review,
            'timestamp': DateTime.now(),
          });
        } else {
          // If user has not previously rated, add their rating and review
          ratingsCollection.add({
            'userId': userEmail,
            'rating': rating,
            'review': review,
            'timestamp': DateTime.now(),
          });
        }
      }
    }
  }

  void _showThankYouDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Thank you for your review."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
