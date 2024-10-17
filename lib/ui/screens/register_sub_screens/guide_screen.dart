import 'package:flutter/material.dart';
import 'package:tinder_new/ui/widgets/bordered_text_field.dart';

class GuideScreen extends StatefulWidget {

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Tutorial Page',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          SizedBox(height: 25),
          Container(
            width: 350,
            height: 560,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[200],
              image: DecorationImage(
                image: AssetImage('images/tutorial.png'), // replace with your image asset
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
