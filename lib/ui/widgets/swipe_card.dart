import 'package:flutter/material.dart';
import 'package:tinder_new/data/db/entity/app_user.dart';
import 'package:tinder_new/ui/widgets/rounded_icon_button.dart';
import 'package:tinder_new/util/constants.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:math';

class SwipeCard extends StatefulWidget {
  final AppUser person;

  const SwipeCard({super.key, required this.person});

  @override
  SwipeCardState createState() => SwipeCardState();
}

class SwipeCardState extends State<SwipeCard> {
  bool showInfo = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.725,
          width: MediaQuery.of(context).size.width * 0.85,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25.0),
            child: Image.network(widget.person.profilePhotoPath,
                fit: BoxFit.cover),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Padding(
                  padding: showInfo
                      ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
                      : const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 24),
                  child: getUserContent(context)),
              showInfo ? getBottomInfo() : Container(),
            ],
          ),
        ),
      ],
    );
  }

  Widget getUserContent(BuildContext context) {
    final List<Color> chipColors = [
      Colors.orangeAccent,
      Colors.redAccent,
      Colors.blueAccent,
      Colors.green.shade300,
      Colors.purpleAccent
    ];

    Random random = Random();

    final List<String> personalities = widget.person.dogPersonality.split(',');
    final int maxChips = 5; // Maximum number of chips to be displayed
    final bool showOverflowIndicator = personalities.length > maxChips;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: 4, horizontal: 8), // Adjust padding as needed
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white), // Border color
                borderRadius: BorderRadius.circular(10), // Border radius
                color: Colors.orangeAccent, // Background color
              ),
              child: Row(
                children: [
                  Text(
                    widget.person.dogName,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    ", ",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    widget.person.dogAge,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                      width: 8), // Add spacing between dog age and gender icon
                  Container(
                    padding: EdgeInsets.all(4), // Adjust padding as needed
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), // Border radius
                      color: widget.person.gender == 'Male'
                          ? Colors.blue
                          : Colors.pink, // Background color based on gender
                    ),
                    child: Icon(
                      widget.person.gender == 'Male'
                          ? Icons.male
                          : Icons.female,
                      color: Colors.white, // Icon color
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(8), // Adjust horizontal padding as needed
              decoration: BoxDecoration(
                color: Colors.blueAccent, // Set background color to orange
                border: Border.all(color: Colors.white), // Border color
                borderRadius: BorderRadius.circular(10), // Border radius
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 24,
                    color: Colors.white, // Adjust icon color as needed
                  ),
                  SizedBox(
                      width: 4), // Add spacing between icon and location text
                  Text(
                    widget.person.location,
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white), // Adjust text color to white
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.66,
              constraints: BoxConstraints(maxHeight: 200),
              padding: EdgeInsets.zero, // Remove any padding
              child: Wrap(
                spacing: 8, // Adjust horizontal spacing between chips
                runSpacing:
                    0, // Set vertical spacing between lines of chips to 0
                children: personalities.take(maxChips).map((personality) {
                  return Chip(
                    label: Text(
                      personality.trim(),
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    backgroundColor:
                        chipColors[random.nextInt(chipColors.length)],
                    labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.all(4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.white),
                    ),
                  );
                }).toList()
                  ..addAll(showOverflowIndicator
                      ? [
                          Chip(
                            label: Text(
                              '+${personalities.length - maxChips}',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
                            ),
                            backgroundColor: Colors.grey,
                            labelPadding:
                                const EdgeInsets.symmetric(horizontal: 8),
                            padding: const EdgeInsets.all(4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Colors.white),
                            ),
                          )
                        ]
                      : []),
              ),
            ),
          ],
        ),
        RoundedIconButton(
          onPressed: () {
            setState(() {
              showInfo = !showInfo;
            });
          },
          iconData: showInfo ? Icons.arrow_downward : Icons.pets,
          iconSize: 16,
          buttonColor: Colors.white,
          iconColor: Colors.deepOrange, // Set the icon color to blue
        ),

      ],
    );
  }

  Widget getBottomInfo() {
    return Column(
      children: [
        const Divider(
          color: kAccentColor,
          thickness: 1.5,
          height: 0,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
            color: Colors.black.withOpacity(.7),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Opacity(
                  opacity: 0.8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          '-Other Info- ',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          'Dog Breed: ${widget.person.dogBreed}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          'Dog Size: ${widget.person.dogSize}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          'Dog Details: ${widget.person.bio}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Center(
                          child: Text(
                            '-Dog Album- ',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Use CarouselSlider to display album images
              CarouselSlider(
                options: CarouselOptions(
                  aspectRatio: 16 / 9,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: true,
                  viewportFraction:
                      0.6, // Set viewportFraction to show next images
                ),
                items: [
                  getAlbumImage(widget.person.album1),
                  getAlbumImage(widget.person.album2),
                  getAlbumImage(widget.person.album3),
                  getAlbumImage(widget.person.album4),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }

  Widget getAlbumImage(String imagePath) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          imagePath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
