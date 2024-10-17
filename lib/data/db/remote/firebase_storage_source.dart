import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tinder_new/data/db/remote/response.dart';

class FirebaseStorageSource {
  FirebaseStorage instance = FirebaseStorage.instance;

  Future<Response<String>> uploadUserProfilePhoto(
      String filePath, String userId) async {
    return _uploadPhoto(filePath, userId, 'profile_photo');
  }

  Future<Response<String>> uploadAlbumPhoto(
      String filePath, String userId, String albumName) async {
    return _uploadPhoto(filePath, userId, albumName);
  }

  Future<Response<String>> _uploadPhoto(
      String filePath, String userId, String photoType) async {
    String photoPath = "user_photos/$userId/$photoType";

    try {
      await instance.ref(photoPath).putFile(File(filePath));
      String downloadUrl = await instance.ref(photoPath).getDownloadURL();
      return Response.success(downloadUrl);
    } catch (e) {
      return Response.error(((e as FirebaseException).message ?? e.toString()));
    }
  }
}
