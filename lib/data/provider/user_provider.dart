import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tinder_new/data/db/entity/chat.dart';
import 'package:tinder_new/data/db/remote/firebase_auth_source.dart';
import 'package:tinder_new/data/db/remote/firebase_database_source.dart';
import 'package:tinder_new/data/db/remote/firebase_storage_source.dart';
import 'package:tinder_new/data/db/remote/response.dart';
import 'package:tinder_new/data/model/chat_with_user.dart';
import 'package:tinder_new/data/model/user_registration.dart';
import 'package:tinder_new/util/shared_preferences_utils.dart';
import 'package:tinder_new/data/db/entity/app_user.dart';
import 'package:tinder_new/util/utils.dart';
import 'package:tinder_new/data/db/entity/match.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseAuthSource _authSource = FirebaseAuthSource();
  final FirebaseStorageSource _storageSource = FirebaseStorageSource();
  final FirebaseDatabaseSource _databaseSource = FirebaseDatabaseSource();

  bool isLoading = false;
  AppUser? _user;

  Future<AppUser?> get user => _getUser();

  Future<Response> loginUser(String email, String password,
      GlobalKey<ScaffoldState> errorScaffoldKey) async {
    Response<dynamic> response = await _authSource.signIn(email, password);
    if (response is Success<UserCredential>) {
      String id = response.value.user!.uid;
      SharedPreferencesUtil.setUserId(id);
    } else if (response is Error) {
      showSnackBar(errorScaffoldKey, response.message);
    }
    return response;
  }

  Future<Response> registerUser(UserRegistration userRegistration,
      GlobalKey<ScaffoldState> errorScaffoldKey) async {
    print(userRegistration);
    Response<dynamic> response = await _authSource.register(
        userRegistration.email, userRegistration.password);
    if (response is Success<UserCredential>) {
      String id = response.value.user!.uid;
      response = await _storageSource.uploadUserProfilePhoto(
          userRegistration.localProfilePhotoPath, id);

      if (response is Success<String>) {
        String profilePhotoUrl = response.value;
        // Upload album1 photo
        response = await _storageSource.uploadAlbumPhoto(
            userRegistration.album1, id, 'album1');
        if (response is Success<String>) {
          String album1Url = response.value;
          // Upload album2 photo
          response = await _storageSource.uploadAlbumPhoto(
              userRegistration.album2, id, 'album2');
          if (response is Success<String>) {
            String album2Url = response.value;
            // Upload album3 photo
            response = await _storageSource.uploadAlbumPhoto(
                userRegistration.album3, id, 'album3');
            if (response is Success<String>) {
              String album3Url = response.value;
              // Upload album4 photo
              response = await _storageSource.uploadAlbumPhoto(
                  userRegistration.album4, id, 'album4');
              if (response is Success<String>) {
                String album4Url = response.value;
                AppUser user = AppUser(
                  id: id,
                  name: userRegistration.name,
                  email: userRegistration.email,
                  age: userRegistration.age,
                  profilePhotoPath: profilePhotoUrl,
                  dogName: userRegistration.dogName,
                  gender: userRegistration.gender,
                  dogPersonality: userRegistration.dogPersonality,
                  dogBreed: userRegistration.dogBreed,
                  dogAge: userRegistration.dogAge,
                  bio: userRegistration.bio,
                  dogSize: userRegistration.dogSize,
                  album1: album1Url,
                  album2: album2Url,
                  album3: album3Url,
                  album4: album4Url,
                  location: userRegistration.location,
                );
                _databaseSource.addUser(user);
                SharedPreferencesUtil.setUserId(id);
                _user = _user;
                return Response.success(user);
              }
            }
          }
        }
      }
    }
    if (response is Error) showSnackBar(errorScaffoldKey, response.message);
    return response;
  }

  Future<AppUser?> _getUser() async {
    if (_user != null) return _user!;
    String? id = await SharedPreferencesUtil.getUserId();
    _user = AppUser.fromSnapshot(await _databaseSource.getUser(id ?? ''));
    return _user;
  }

  void updateUserProfilePhoto(
      String localFilePath, GlobalKey<ScaffoldState> errorScaffoldKey) async {
    isLoading = true;
    notifyListeners();
    Response<dynamic> response =
    await _storageSource.uploadUserProfilePhoto(localFilePath, _user!.id);
    isLoading = false;
    if (response is Success<String>) {
      _user!.profilePhotoPath = response.value;
      _databaseSource.updateUser(_user!);
    } else if (response is Error) {
      showSnackBar(errorScaffoldKey, response.message);
    }
    notifyListeners();
  }

  void updateUserBio(String newBio) {
    _user!.bio = newBio;
    _databaseSource.updateUser(_user!);
    notifyListeners();
  }

  void updateUserLocation(String newLocation) {
    _user!.location = newLocation;
    _databaseSource.updateUser(_user!);
    notifyListeners();
  }

  void updateUserAlbumImage(
      String localFilePath, int albumNumber, GlobalKey<ScaffoldState> errorScaffoldKey) async {
    isLoading = true;
    notifyListeners();
    String albumField;
    switch (albumNumber) {
      case 1:
        albumField = 'album1';
        break;
      case 2:
        albumField = 'album2';
        break;
      case 3:
        albumField = 'album3';
        break;
      case 4:
        albumField = 'album4';
        break;
      default:
        albumField = 'album1';
    }

    Response<dynamic> response =
    await _storageSource.uploadAlbumPhoto(localFilePath, _user!.id, albumField);

    isLoading = false;
    if (response is Success<String>) {
      switch (albumNumber) {
        case 1:
          _user!.album1 = response.value;
          break;
        case 2:
          _user!.album2 = response.value;
          break;
        case 3:
          _user!.album3 = response.value;
          break;
        case 4:
          _user!.album4 = response.value;
          break;
      }
      _databaseSource.updateUser(_user!);
    } else if (response is Error) {
      showSnackBar(errorScaffoldKey, response.message);
    }
    notifyListeners();
  }

  Future<void> logoutUser() async {
    _user = null;
    await SharedPreferencesUtil.removeUserId();
  }

  Future<List<ChatWithUser>> getChatsWithUser(String userId) async {
    var matches = await _databaseSource.getMatches(userId);
    List<ChatWithUser> chatWithUserList = [];

    for (var i = 0; i < matches.size; i++) {
      Match match = Match.fromSnapshot(matches.docs[i]);
      AppUser matchedUser =
      AppUser.fromSnapshot(await _databaseSource.getUser(match.id));

      String chatId = compareAndCombineIds(match.id, userId);

      Chat chat = Chat.fromSnapshot(await _databaseSource.getChat(chatId));
      ChatWithUser chatWithUser = ChatWithUser(chat, matchedUser);
      chatWithUserList.add(chatWithUser);
    }
    return chatWithUserList;
  }
}
