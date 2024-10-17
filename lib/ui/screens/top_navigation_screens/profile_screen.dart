import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tinder_new/data/db/entity/app_user.dart';
import 'package:tinder_new/data/provider/user_provider.dart';
import 'package:tinder_new/ui/screens/start_screen.dart';
import 'package:tinder_new/ui/widgets/custom_modal_progress_hud.dart';
import 'package:tinder_new/ui/widgets/input_dialog.dart';
import 'package:tinder_new/ui/widgets/rounded_icon_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void showLogoutConfirmation(UserProvider userProvider, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout Confirmation'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                logoutPressed(userProvider, context); // Call logout function
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void logoutPressed(UserProvider userProvider, BuildContext context) async {
    userProvider.logoutUser();
    Navigator.pop(context);
    Navigator.pushNamed(context, StartScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Center(
          child: Text(
            'PROFILE',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 42.0,
            horizontal: 18.0,
          ),
          margin: const EdgeInsets.only(bottom: 40),
          child: Consumer<UserProvider>(builder: (context, userProvider, child) {
            return FutureBuilder<AppUser?>(
              future: userProvider.user,
              builder: (context, userSnapshot) {
                return CustomModalProgressHUD(
                  inAsyncCall: userProvider.isLoading,
                  offset: null,
                  child: userSnapshot.hasData
                      ? Column(
                    children: [
                      getProfileImage(userSnapshot.data!.profilePhotoPath,
                          userProvider),
                      const SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // To make the row just fit to its children
                          mainAxisAlignment: MainAxisAlignment.center, // To center horizontally
                          crossAxisAlignment: CrossAxisAlignment.center, // To center vertically
                          children: [
                            Text(
                              '${userSnapshot.data!.dogName}, ',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.grey[600], // Set text color to orange
                              ),
                            ),
                            Text(
                              '${userSnapshot.data!.dogAge}',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.grey[600], // Set text color to orange
                              ),
                            ),
                            if (userSnapshot.data!.gender == 'Male') // Check if gender is Male
                              Icon(
                                Icons.male,
                                color: Colors.blue, // Set male icon color
                              ),
                            if (userSnapshot.data!.gender == 'Female') // Check if gender is Female
                              Icon(
                                Icons.female,
                                color: Colors.pink, // Set female icon color
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      getUserDetails(userSnapshot.data!, userProvider),
                      const SizedBox(height: 4),
                      getBio(userSnapshot.data!, userProvider),
                      const SizedBox(height: 4),
                      getLocation(userSnapshot.data!, userProvider),
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Dog Personalities:',
                            style: TextStyle(
                              color: Colors.orange, // Orange color for label text
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            alignment: WrapAlignment.center, // Align chips to start from the center
                            children: (userSnapshot.data?.dogPersonality ?? '')
                                .split(',')
                                .map((personality) {
                              return Chip(
                                label: Text(personality.trim()),
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  side: BorderSide(color: Colors.grey),
                                ),
                                labelStyle: TextStyle(color: Colors.grey[600]),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: getAlbumImage(
                                  userSnapshot.data!.album1,
                                  userProvider,
                                  1)),
                          const SizedBox(width: 20),
                          Expanded(
                              child: getAlbumImage(
                                  userSnapshot.data!.album2,
                                  userProvider,
                                  2)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: getAlbumImage(
                                  userSnapshot.data!.album3,
                                  userProvider,
                                  3)),
                          const SizedBox(width: 20),
                          Expanded(
                              child: getAlbumImage(
                                  userSnapshot.data!.album4,
                                  userProvider,
                                  4)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () {
                          showLogoutConfirmation(userProvider, context);
                        },
                        child: const Text('LOGOUT'),
                      )
                    ],
                  )
                      : Container(),
                );
              },
            );
          }),
        ),
      ),
    );
  }

  Widget getUserDetails(AppUser user, UserProvider userProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Dog Breed: ',
                    style: TextStyle(
                      color: Colors.orange, // Orange color for label text
                      fontWeight: FontWeight.bold,
                      fontSize: 24, // Adjust font size here
                    ),
                  ),
                  Text(
                    '${user.dogBreed}',
                    style: TextStyle(
                      color: Colors.grey[600], // Different color for output text
                      fontSize: 20,
                      fontWeight: FontWeight.w700, // Adjust font size here
                    ),
                  ),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Dog Size: ',
                    style: TextStyle(
                      color: Colors.orange, // Orange color for label text
                      fontWeight: FontWeight.bold,
                      fontSize: 24, // Adjust font size here
                    ),
                  ),
                  Text(
                    '${user.dogSize}',
                    style: TextStyle(
                        color: Colors.grey[600], // Different color for output text
                        fontSize: 20,
                        fontWeight: FontWeight.w700 // Adjust font size here
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getBio(AppUser user, UserProvider userProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text.rich(
                    TextSpan(
                      text: 'Details: ',
                      style: TextStyle(
                        color: Colors.orange, // Change color of "Bio:"
                        fontWeight: FontWeight.bold,
                        fontSize: 24, // Change font weight of "Bio:"
                      ),
                      children: [
                        TextSpan(
                          text: user.bio.isNotEmpty ? user.bio : "No bio.",
                          style: TextStyle(
                            color: Colors.grey[600], // Color for the bio text
                            fontSize: 20,
                            fontWeight: FontWeight.w700, // Font weight for the bio text
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: RoundedIconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => InputDialog(
                      onSavePressed: (value) =>
                          userProvider.updateUserBio(value),
                      labelText: 'Details',
                      startInputText: user.bio,
                    ),
                  );
                },
                iconData: Icons.edit,
                iconSize: 18,
                buttonColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget getLocation(AppUser user, UserProvider userProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text.rich(
                    TextSpan(
                      text: 'Location: ',
                      style: TextStyle(
                        color: Colors.orange, // Change color of "Bio:"
                        fontWeight: FontWeight.bold,
                        fontSize: 24, // Change font weight of "Bio:"
                      ),
                      children: [
                        TextSpan(
                          text: user.location.isNotEmpty ? user.location : "No bio.",
                          style: TextStyle(
                            color: Colors.grey[600], // Color for the bio text
                            fontSize: 20,
                            fontWeight: FontWeight.w700, // Font weight for the bio text
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: RoundedIconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => InputDialog(
                      onSavePressed: (value) =>
                          userProvider.updateUserLocation(value),
                      labelText: 'Location',
                      startInputText: user.location,
                    ),
                  );
                },
                iconData: Icons.edit,
                iconSize: 18,
                buttonColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget getProfileImage(String imagePath, UserProvider firebaseProvider) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey, width: 1.0),
          ),
          child: CircleAvatar(
            backgroundImage: NetworkImage(imagePath),
            radius: 100,
          ),
        ),
        Positioned(
          right: 10.0,
          bottom: 0.0,
          child: RoundedIconButton(
            onPressed: () async {
              final pickedFile =
              await ImagePicker().pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                firebaseProvider.updateUserProfilePhoto(
                  pickedFile.path,
                  _scaffoldKey,
                );
              }
            },
            iconData: Icons.edit,
            iconSize: 18,
            buttonColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget getAlbumImage(
      String imagePath, UserProvider firebaseProvider, int albumNumber) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey, width: 1.0),
          ),
          width: 150,
          height: 150,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: RoundedIconButton(
            onPressed: () async {
              final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                firebaseProvider.updateUserAlbumImage(
                  pickedFile.path,
                  albumNumber,
                  _scaffoldKey,
                );
              }
            },
            iconData: Icons.edit,
            iconSize: 18,
            buttonColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
