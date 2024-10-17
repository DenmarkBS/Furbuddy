import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinder_new/data/db/entity/app_user.dart';
import 'package:tinder_new/data/db/entity/chat.dart';
import 'package:tinder_new/data/db/entity/match.dart';
import 'package:tinder_new/data/db/entity/swipe.dart';
import 'package:tinder_new/data/db/remote/firebase_database_source.dart';
import 'package:tinder_new/data/provider/user_provider.dart';
import 'package:tinder_new/ui/screens/matched_screen.dart';
import 'package:tinder_new/ui/screens/top_navigation_screens/suggestions.dart';
import 'package:tinder_new/ui/widgets/custom_modal_progress_hud.dart';
import 'package:tinder_new/ui/widgets/rounded_icon_button.dart';
import 'package:tinder_new/ui/widgets/swipe_card.dart';
import 'package:tinder_new/util/utils.dart';

import '../drawer/about_us_page.dart';
import '../drawer/dog_tips.dart';
import '../drawer/help.dart';
import '../drawer/review_rating.dart';
import '../drawer/settings_page.dart';
import '../start_screen.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({super.key});

  @override
  MatchScreenState createState() => MatchScreenState();
}

class MatchScreenState extends State<MatchScreen> {
  final FirebaseDatabaseSource _databaseSource = FirebaseDatabaseSource();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String>? _ignoreSwipeIds;

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

  Future<AppUser?> loadPerson(String myUserId) async {
    if (_ignoreSwipeIds == null) {
      _ignoreSwipeIds = <String>[];
      var swipes = await _databaseSource.getSwipes(myUserId);
      for (var i = 0; i < swipes.size; i++) {
        Swipe swipe = Swipe.fromSnapshot(swipes.docs[i]);
        _ignoreSwipeIds!.add(swipe.id);
      }
      _ignoreSwipeIds!.add(myUserId);
    }
    var res = await _databaseSource.getPersonsToMatchWith(1, _ignoreSwipeIds!);
    if (res.docs.isNotEmpty) {
      var userToMatchWith = AppUser.fromSnapshot(res.docs.first);
      return userToMatchWith;
    } else {
      return null;
    }
  }

  void personSwiped(AppUser myUser, AppUser otherUser, bool isLiked) async {
    _databaseSource.addSwipedUser(myUser.id, Swipe(otherUser.id, isLiked));
    _ignoreSwipeIds!.add(otherUser.id);

    if (isLiked == true) {
      if (await isMatch(myUser, otherUser) == true) {
        _databaseSource.addMatch(myUser.id, Match(otherUser.id));
        _databaseSource.addMatch(otherUser.id, Match(myUser.id));
        String chatId = compareAndCombineIds(myUser.id, otherUser.id);
        _databaseSource.addChat(Chat(chatId, null));

        if (context.mounted) {
          Navigator.pushNamed(context, MatchedScreen.id, arguments: {
            "my_user_id": myUser.id,
            "my_profile_photo_path": myUser.profilePhotoPath,
            "other_user_profile_photo_path": otherUser.profilePhotoPath,
            "other_user_id": otherUser.id
          });
        }
      }
    }
    setState(() {});
  }

  Future<bool> isMatch(AppUser myUser, AppUser otherUser) async {
    DocumentSnapshot swipeSnapshot =
    await _databaseSource.getSwipe(otherUser.id, myUser.id);
    if (swipeSnapshot.exists) {
      Swipe swipe = Swipe.fromSnapshot(swipeSnapshot);

      if (swipe.liked == true) {
        return true;
      }
    }
    return false;
  }

  void checkIfUserBanned(String userId) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists && userDoc['isBanned'] == true) {
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dialog from closing by tapping outside
        builder: (context) => AlertDialog(
          title: Text('Account Banned'),
          content: Text('Your account has been banned. Please contact furbuddysupport@gmail.com to get unbanned.'),
          actions: [
            TextButton(
              onPressed: () {
                final userProvider = Provider.of<UserProvider>(context, listen: false);
                logoutPressed(userProvider, context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Center(
            child: Text(
              'FURBUDDY',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
            ),
          ),
          backgroundColor: Colors.orange,
          automaticallyImplyLeading: true, // To remove the default back button leading to the drawer
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.map, color: Colors.black87,) ,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LocationContentPage()),
                );
              },
            ),

          ],
        ),
        drawer: Drawer(
          child: Container(
            color: Colors.orange[100],
            child: ListView(
              children: [
                DrawerHeader(
                  child: Center(
                    child: Icon(
                      Icons.pets_outlined,
                      color: Colors.deepOrangeAccent,
                      size: 100,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text(
                    'Settings',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.question_mark_outlined),
                  title: const Text(
                    'About us',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AboutUsPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.help),
                  title: const Text(
                    'Help Desk',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Help(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.tips_and_updates_outlined),
                  title: const Text(
                    'Tips',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DogTipsPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.rate_review),
                  title: const Text(
                    'Rate our App',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ReviewRatingPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text(
                    'Log Out',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    final userProvider = Provider.of<UserProvider>(context, listen: false);
                    showLogoutConfirmation(userProvider, context);
                  },
                ),
              ],
            ),
          ),
        ),
        body: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            return FutureBuilder<AppUser?>(
              future: userProvider.user,
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.done && userSnapshot.hasData) {
                  checkIfUserBanned(userSnapshot.data!.id);
                }
                return CustomModalProgressHUD(
                  inAsyncCall: userProvider.isLoading,
                  offset: null,
                  child: (userSnapshot.hasData)
                      ? FutureBuilder<AppUser?>(
                      future: loadPerson(userSnapshot.data!.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.done &&
                            !snapshot.hasData) {
                          return Center(
                            child: Text('No users',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium),
                          );
                        }
                        if (!snapshot.hasData) {
                          return CustomModalProgressHUD(
                            inAsyncCall: true,
                            offset: null,
                            child: Container(),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SwipeCard(person: snapshot.data!),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 45),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        RoundedIconButton(
                                          onPressed: () {
                                            personSwiped(userSnapshot.data!,
                                                snapshot.data!, false);
                                          },
                                          iconData: Icons.clear_rounded,
                                          buttonColor: Colors.red,
                                          iconColor: Colors.white,
                                          iconSize: 30,
                                        ),
                                        RoundedIconButton(
                                          onPressed: () {
                                            personSwiped(userSnapshot.data!,
                                                snapshot.data!, true);
                                          },
                                          iconData: Icons.check,
                                          iconSize: 30,
                                          iconColor: Colors.white,
                                          buttonColor: Colors.green,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      })
                      : Container(),
                );
              },
            );
          },
        ));
  }
}
