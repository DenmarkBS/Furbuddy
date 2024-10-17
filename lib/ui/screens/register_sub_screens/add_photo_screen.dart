import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tinder_new/ui/widgets/bordered_text_field2.dart';
import 'package:tinder_new/ui/widgets/image_portrait.dart';

import '../../widgets/bordered_text_field.dart';

class AddPhotoScreen extends StatefulWidget {
  final Function(String) onPhotoChanged;
  final Function(String) userDogName;
  final Function(String) selectedGender;
  final Function(String) dogBreed;
  final Function(String) dogAge;
  final Function(String) bio;
  final Function(String) dogSize;

  const AddPhotoScreen({
    Key? key,
    required this.onPhotoChanged,
    required this.userDogName,
    required this.selectedGender,
    required this.dogBreed,
    required this.dogAge,
    required this.bio,
    required this.dogSize,

  }) : super(key: key);

  @override
  AddPhotoScreenState createState() => AddPhotoScreenState();
}

class AddPhotoScreenState extends State<AddPhotoScreen> {
  final picker = ImagePicker();
  String? _imagePath;
  bool _granted = false; // Simulated permission flag
  String _dogGender = ''; // Variable to store selected dog gender

  Future<void> pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      widget.onPhotoChanged(pickedFile.path);

      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<void> pickImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      widget.onPhotoChanged(pickedFile.path);

      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<void> _showImageSourceDialog() async {
    if (!_granted) {
      // Simulate permission request
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('File Permission'),
            content: Text(
              'This app needs access to your Camera and Files to upload an image, Do you agree?',
              style:
              TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _granted = true;
                  });
                  Navigator.of(context).pop();
                },
                child: Text('Grant'),
              ),
            ],
          );
        },
      );
    }

    if (_granted) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Choose Image Source'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.camera),
                  title: Text('Take a photo'),
                  onTap: () {
                    Navigator.of(context).pop();
                    pickImageFromCamera();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.image),
                  title: Text('Select from gallery'),
                  onTap: () {
                    Navigator.of(context).pop();
                    pickImageFromGallery();
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Dog Profile',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          SizedBox(height: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Stack(
                children: [
                  Container(
                    child: _imagePath == null
                        ? ImagePortrait(
                      imageType: ImageType.NONE,
                      imagePath: '',
                    )
                        : ImagePortrait(
                      imagePath: _imagePath!,
                      imageType: ImageType.FILE_IMAGE,
                    ),
                  ),
                  Positioned(
                    bottom: 8.0,
                    right: 1.0,
                    child: IconButton(
                      onPressed: _showImageSourceDialog,
                      icon: Icon(
                        Icons.add_a_photo,
                        size: 40,
                        color: Colors.deepOrange,
                      ),
                      tooltip: 'Edit Image',
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChoiceChip(
                label: Text(
                  'Male',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
                ),
                selected: _dogGender == 'Male',
                onSelected: (selected) {
                  setState(() {
                    _dogGender = selected ? 'Male' : '';
                    widget.selectedGender(_dogGender);
                  });
                },
                backgroundColor: Colors.grey.shade100,
                selectedColor: Colors.deepOrange,
                labelStyle: TextStyle(color: Colors.black),
                elevation: 2,
                pressElevation: 4,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              SizedBox(width: 100),
              ChoiceChip(
                label: Text(
                  'Female',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
                ),
                selected: _dogGender == 'Female',
                onSelected: (selected) {
                  setState(() {
                    _dogGender = selected ? 'Female' : '';
                    widget.selectedGender(_dogGender);
                  });
                },
                backgroundColor: Colors.grey.shade100,
                selectedColor: Colors.deepOrange,
                labelStyle: TextStyle(color: Colors.black),
                elevation: 2,
                pressElevation: 4,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          BorderedTextField(
            labelText: "Dog Name",
            onChanged: widget.userDogName,
            textCapitalization: TextCapitalization.words,
          ),
          SizedBox(height: 10),
          BorderedTextField2(
            labelText: "Dog Breed",
            onChanged: widget.dogBreed,
            textCapitalization: TextCapitalization.words,
           suggestions: [
              'Labrador', 'Golden Retriever', 'Bulldog', 'Poodle', 'German Shepherd',
              'Beagle', 'Rottweiler', 'Dachshund', 'Boxer', 'Shih Tzu',
              'Siberian Husky', 'Doberman Pinscher', 'Chihuahua', 'Pug', 'Great Dane',
              'Border Collie', 'Australian Shepherd', 'Cavalier King Charles Spaniel',
              'Shetland Sheepdog', 'Boston Terrier', 'Akita', 'Collie', 'Pomeranian',
              'Alaskan Malamute', 'Bernese Mountain Dog', 'Bichon Frise', 'Basset Hound',
              'Cocker Spaniel', 'Papillon', 'Chinese Crested', 'Borzoi', 'Basenji',
              'Bergamasco', 'Briard', 'Bolognese', 'Boerboel', 'Bouvier des Flandres',
              'Brussels Griffon', 'Bulldog (French)', 'Bullmastiff', 'Cairn Terrier',
              'Cane Corso', 'Cardigan Welsh Corgi', 'Cavachon', 'Cavapoo', 'Chesapeake Bay Retriever',
              'Chow Chow', 'Clumber Spaniel', 'Cockapoo', 'Coton de Tulear', 'Dalmatian',
              'Dandie Dinmont Terrier', 'Doberman Pinscher', 'Dogue de Bordeaux', 'English Bulldog', 'English Foxhound',
              'English Setter', 'English Springer Spaniel', 'Field Spaniel', 'Finnish Lapphund', 'Finnish Spitz',
              'Flat-Coated Retriever', 'French Bulldog', 'German Pinscher', 'German Shepherd', 'German Shorthaired Pointer',
              'German Wirehaired Pointer', 'Giant Schnauzer', 'Glen of Imaal Terrier', 'Goldador', 'Golden Retriever',
              'Goldendoodle', 'Gordon Setter', 'Great Dane', 'Great Pyrenees', 'Greater Swiss Mountain Dog',
              'Greyhound', 'Harrier', 'Havanese', 'Irish Setter', 'Irish Terrier', 'Corgi',
              // Add more dog breeds as needed
            ],
          ),

          SizedBox(height: 10),
          BorderedTextField(
            labelText: "Dog Age",
            keyboardType: TextInputType.number,
            onChanged: widget.dogAge,
            textCapitalization: TextCapitalization.words,
          ),
          SizedBox(height: 10),
          BorderedTextField(
            labelText: "Dog Details",
            onChanged: widget.bio,
            textCapitalization: TextCapitalization.words,
          ),
          SizedBox(height: 10),
          BorderedTextField2(
            labelText: "Dog Size",
            onChanged: widget.dogSize,
            textCapitalization: TextCapitalization.words,
            suggestions: ["Miniature","Small", "Medium", "Large", "Very Large"],
          ),

        ],
      ),
    );
  }
}
