import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinder_new/data/db/entity/app_user.dart';
import 'package:tinder_new/data/provider/user_provider.dart';
import 'package:tinder_new/ui/widgets/custom_modal_progress_hud.dart';
import 'package:tinder_new/ui/widgets/swipe_card.dart';

class LocationContentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Users'),
      ),
      body: LocationContent(),
    );
  }
}

class LocationContent extends StatelessWidget {
  Future<List<AppUser>> getUsersWithSameLocation(String location) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('location', isEqualTo: location)
        .get();

    return snapshot.docs.map((doc) => AppUser.fromSnapshot(doc)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return FutureBuilder<AppUser?>(
          future: userProvider.user,
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return CustomModalProgressHUD(
                inAsyncCall: true,
                offset: null,
                child: Container(),
              );
            }
            if (!userSnapshot.hasData) {
              return Center(
                child: Text('No user data available'),
              );
            }
            return FutureBuilder<List<AppUser>>(
              future: getUsersWithSameLocation(userSnapshot.data!.location),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CustomModalProgressHUD(
                    inAsyncCall: true,
                    offset: null,
                    child: Container(),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text('No users found in your location'),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return _buildUserItem(context, snapshot.data![index]);
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildUserItem(BuildContext context, AppUser user) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfilePage(user: user)));
      },
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user.profilePhotoPath),
          ),
          title: Text(user.name),
          subtitle: Text(user.location ?? 'Unknown Location'),
        ),
      ),
    );
  }
}

class UserProfilePage extends StatelessWidget {
  final AppUser user;

  UserProfilePage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${user.name}\'s Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.profilePhotoPath),
              radius: 50,
            ),
            SizedBox(height: 16),
            Text(
              user.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Location: ${user.location}',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            CarouselSlider(
              options: CarouselOptions(
                aspectRatio: 16 / 9,
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
                viewportFraction:
                0.6, // Set viewportFraction to show next images
              ),
              items: [
                getAlbumImage(user.album1),
                getAlbumImage(user.album2),
                getAlbumImage(user.album3),
                getAlbumImage(user.album4),
              ],
            ),
          ],
        ),
      ),
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
