import 'package:flutter/material.dart';

class SexualScreen extends StatefulWidget {
  final Function(String) selectedPersonality;

  const SexualScreen({Key? key, required this.selectedPersonality}) : super(key: key);

  @override
  State<SexualScreen> createState() => _SexualScreenState();
}

class _SexualScreenState extends State<SexualScreen> {
  List<String> personalities = [
    'Playful',
    'Friendly',
    'Energetic',
    'Loyal',
    'Intelligent',
    'Affectionate',
    'Calm',
    'Adventurous',
    'Independent',
    'Sociable',
    'Alert',
    'Brave',
    'Curious',
    'Gentle',
    'Outgoing',
    'Patient',
    'Protective',
    'Reserved',
    'Spirited',
    'Clever',
    'Cheerful',
    'Lazy',
    'Quirky',
    'Obedient',
    'Stubborn',
  ];

  List<String> selectedPersonalities = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Dog Personality',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          SizedBox(height: 25),
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 8.0,
              runSpacing: 4.0,
              children: List<Widget>.generate(
                personalities.length,
                    (int index) {
                  return ChoiceChip(
                    label: Text(personalities[index]),
                    selected: selectedPersonalities.contains(personalities[index]),
                    backgroundColor: Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(color: Colors.white),
                    ),
                    labelStyle: TextStyle(
                      color: selectedPersonalities.contains(personalities[index])
                          ? Colors.white
                          : Colors.black45,
                    ),
                    selectedColor: Colors.orange,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          selectedPersonalities.add(personalities[index]);
                        } else {
                          selectedPersonalities.remove(personalities[index]);
                        }
                        widget.selectedPersonality(selectedPersonalities.join(", "));
                      });
                    },
                  );
                },
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
