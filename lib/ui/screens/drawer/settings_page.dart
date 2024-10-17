import 'package:flutter/material.dart';

import '../../../util/constants.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

double _startValue = 1.0;
double _endValue = 10.0;
List<double> _availableValues = List.generate(10, (index) => index + 1);

class _SettingsPageState extends State<SettingsPage> {
  bool receiveNotifications = true;
  bool darkMode = false;
  int selectedFontSize = 1; // 0: Small, 1: Medium, 2: Large
  double locationSliderValue = 5;
  TextEditingController locationController = TextEditingController();

  void save() {
    final String location = locationController.text;
    final String selectedRange = '$_startValue - $_endValue kilometers';

    // Show SnackBar with the updated location and selected range
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Updated Location: $location\nSelected Range: $selectedRange'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
        // Set app bar color to orange
      ),
      backgroundColor: kPrimaryColor, // Set body color to white
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSwitchTile(
              'Receive Notifications',
              'Enable or disable notifications',
              receiveNotifications,
              (value) {
                setState(() {
                  receiveNotifications = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
      String title, String subtitle, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildDropdownTile(String title, String subtitle, List<String> options,
      int value, Function(int?) onChanged) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: DropdownButton<int>(
        value: value,
        items: List.generate(
          options.length,
          (index) => DropdownMenuItem<int>(
            value: index,
            child: Text(options[index]),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SettingsPage(),
  ));
}
