import 'package:flutter/material.dart';
import 'package:tinder_new/util/constants.dart';
import 'dart:io';

enum ImageType { ASSET_IMAGE, FILE_IMAGE, NONE }

class AlbumPortrait extends StatelessWidget {
  final double height;
  final String imagePath;
  final ImageType imageType;

  const AlbumPortrait(
      {super.key, required this.imageType, required this.imagePath, this.height = 250.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: height * 0.65,
      height: MediaQuery.of(context).size.height / 3,
      decoration: BoxDecoration(
          border: Border.all(width: 2, color: Colors.white),
          borderRadius: const BorderRadius.all(Radius.circular(25.0))),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22.0),
        child: getImage(),
      ),
    );
  }

  Widget? getImage() {
    if (imageType == ImageType.NONE || imagePath == null) return null;
    if (imageType == ImageType.FILE_IMAGE) {
      return Image.file(File(imagePath), fit: BoxFit.cover);
    } else if (imageType == ImageType.ASSET_IMAGE) {
      return Image.asset(imagePath, fit: BoxFit.cover);
    } else {
      return null;
    }
  }
}
