import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tinder_new/util/constants.dart';
import 'package:tinder_new/ui/widgets/app_image_with_text.dart';
import 'package:tinder_new/ui/screens/login_screen.dart';
import 'package:tinder_new/ui/screens/register_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'google_logged_in_page.dart';

class GoogleSignInApi {
  static final _googleSignIn = GoogleSignIn();

  static Future<GoogleSignInAccount?> login() {
    return _googleSignIn.signIn();
  }

  static Future logout() async {
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.disconnect();
  }
}

class StartScreen extends StatelessWidget {
  static const String id = 'start_screen';

  const StartScreen({super.key});

  Future<UserCredential?> loginWithGoogle(BuildContext context) async {
    GoogleSignInAccount? user = await GoogleSignInApi.login();

    GoogleSignInAuthentication? googleAuth = await user!.authentication;
    var credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    UserCredential? userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    if (userCredential != null) {
      print('Login Success === Google');
      print(userCredential);

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) =>
              GoogleLoggedInPage(userCredential: userCredential)));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Login failed === Google')));
    }

    return userCredential;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: kDefaultPadding,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10, top: 20),
            child: Column(
              children: [
                AppIconTitle(),
                Expanded(child: Container()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                OutlinedButton(
                  style: ElevatedButton.styleFrom(
                      side: BorderSide(color: Colors.white, width: 1.0),
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.grey.shade100,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset('images/google_logo.png',
                          width: 30, height: 30, fit: BoxFit.fill),
                      const Text(
                        'GOOGLE LOGIN',
                        style: TextStyle(fontSize: 20, color: Colors.green),
                      ),
                      Opacity(
                        opacity: 0.0,
                        child: Image.asset('images/google_logo.png',
                            width: 20, height: 20, fit: BoxFit.fill),
                      )
                    ],
                  ),
                  onPressed: () async {
                    await loginWithGoogle(context);
                  },
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  style: ElevatedButton.styleFrom(
                      side: BorderSide(color: Colors.white, width: 1.0),
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.grey.shade100,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Text(
                    'EMAIL LOGIN',
                    style: TextStyle(fontSize: 20, color: Colors.green),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, LoginScreen.id);
                  },
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  style: ElevatedButton.styleFrom(
                      side: BorderSide(color: Colors.white, width: 1.0),
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.deepOrange,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Text(
                    'CREATE ACCOUNT',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),

                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, RegisterScreen.id);
                  },
                ),
                const SizedBox(height: 100),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
