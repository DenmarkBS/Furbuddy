import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/album_portrait.dart';

class AgeScreen extends StatefulWidget {
  final Function(String) album1;
  final Function(String) album2;
  final Function(String) album3;
  final Function(String) album4;

  const AgeScreen({
    Key? key,
    required this.album1,
    required this.album2,
    required this.album3,
    required this.album4,
  }) : super(key: key);

  @override
  AgeScreenState createState() => AgeScreenState();
}

class AgeScreenState extends State<AgeScreen> {
  final picker = ImagePicker();
  List<String?> _imagePaths = List.filled(4, null);

  Future pickImageFromGallery(int index) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      switch (index) {
        case 0:
          widget.album1(pickedFile.path);
          break;
        case 1:
          widget.album2(pickedFile.path);
          break;
        case 2:
          widget.album3(pickedFile.path);
          break;
        case 3:
          widget.album4(pickedFile.path);
          break;
      }

      setState(() {
        _imagePaths[index] = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Add photos',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        SizedBox(height: 25),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            children: List.generate(4, (index) {
              return GestureDetector(
                onTap: () => pickImageFromGallery(index),
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      _imagePaths[index] == null
                          ? AlbumPortrait(
                        imageType: ImageType.NONE,
                        imagePath: '',
                      )
                          : AlbumPortrait(
                        imagePath: _imagePaths[index]!,
                        imageType: ImageType.FILE_IMAGE,
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: _imagePaths[index] == null
                              ? ElevatedButton(
                            onPressed: () =>
                                pickImageFromGallery(index),
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(20),
                            ),
                            child: const Icon(Icons.add),
                          )
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
