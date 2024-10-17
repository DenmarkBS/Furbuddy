import 'package:flutter/material.dart';
import 'package:tinder_new/util/constants.dart';
import 'dart:io';

enum ImageType { ASSET_IMAGE, FILE_IMAGE, NONE }

class ImagePortrait extends StatelessWidget {
  final double size;
  final String imagePath;
  final ImageType imageType;

  const ImagePortrait({
    Key? key,
    required this.imageType,
    required this.imagePath,
    this.size = 150.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: Stack(
        children: [
          if (imagePath.isEmpty)
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.white, // Set background color to white
                shape: BoxShape.circle,
                border: Border.all(width: 1, color: Colors.white),
              ),
            ),
          ClipOval(
            child: getImage(),
          ),
        ],
      ),
    );
  }

  Widget? getImage() {
    if (imageType == ImageType.NONE || imagePath.isEmpty) return null;
    if (imageType == ImageType.FILE_IMAGE) {
      return Image.file(
        File(imagePath),
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    } else if (imageType == ImageType.ASSET_IMAGE) {
      return Image.asset(
        imagePath,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    } else {
      return null;
    }
  }
}
