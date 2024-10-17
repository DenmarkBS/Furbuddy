import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  String id;
  String name;
  String email;
  int age;
  String profilePhotoPath;
  String dogName;
  String gender;
  String dogPersonality;
  String dogBreed;
  String dogAge;
  String bio;
  String dogSize;
  String album1;
  String album2;
  String album3;
  String album4;
  String location;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.profilePhotoPath,
    required this.dogName,
    required this.gender,
    required this.dogPersonality,
    required this.dogBreed,
    required this.dogAge,
    required this.bio,
    required this.dogSize,
    required this.album1,
    required this.album2,
    required this.album3,
    required this.album4,
    required this.location,
  });

  AppUser.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot['id'],
        name = snapshot['name'],
        email = snapshot['email'],
        age = snapshot['age'],
        profilePhotoPath = snapshot['profile_photo_path'],
        dogName = snapshot['dogName'],
        gender = snapshot['gender'],
        dogPersonality = snapshot['dogPersonality'],
        dogBreed = snapshot['dogBreed'],
        dogAge = snapshot['dogAge'],
        bio = snapshot['bio'],
        dogSize = snapshot['dogSize'],
        album1 = snapshot['album1'],
        album2 = snapshot['album2'],
        album3 = snapshot['album3'],
        album4 = snapshot['album4'],
        location = snapshot['location'];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'profile_photo_path': profilePhotoPath,
      'dogName': dogName,
      'gender': gender,
      'dogPersonality': dogPersonality,
      'dogBreed': dogBreed,
      'dogAge': dogAge,
      'bio': bio,
      'dogSize': dogSize,
      'album1': album1,
      'album2': album2,
      'album3': album3,
      'album4': album4,
      'location': location
    };
  }
}
