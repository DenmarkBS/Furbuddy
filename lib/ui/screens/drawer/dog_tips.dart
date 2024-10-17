import 'package:flutter/material.dart';

class DogTipsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dog Tips',
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
        child: ListView(
          children: [
            _buildTipCard(
              'Proper Nutrition',
              'Ensure your dog receives a balanced diet with the right amount of nutrients suitable for its age, size, and breed.',
            ),
            _buildTipCard(
              'Regular Exercise',
              'Provide your dog with regular exercise to keep them healthy and happy. The amount of exercise needed varies by breed.',
            ),
            _buildTipCard(
              'Veterinary Check-ups',
              'Schedule regular visits to the vet for check-ups, vaccinations, and preventive care to ensure your dogs well-being.',
            ),
            _buildTipCard(
              'Training and Socialization',
              'Train your dog and socialize them from a young age. Basic commands and positive interactions with others are essential.',
            ),
            _buildTipCard(
              'Grooming',
              'Regular grooming, including brushing, bathing, and nail trimming, helps maintain your dog\'s hygiene and health.',
            ),
            _buildTipCard(
              'Safe Environment',
              'Create a safe environment for your dog. Remove hazards, keep harmful substances out of reach, and provide a comfortable space.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard(String title, String description) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(description),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DogTipsPage(),
  ));
}
