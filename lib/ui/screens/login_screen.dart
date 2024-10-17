import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinder_new/data/db/remote/response.dart';
import 'package:tinder_new/data/provider/user_provider.dart';
import 'package:tinder_new/ui/screens/register_screen.dart';
import 'package:tinder_new/ui/screens/top_navigation_screen.dart';
import 'package:tinder_new/ui/widgets/bordered_text_field.dart';
import 'package:tinder_new/ui/widgets/custom_modal_progress_hud.dart';
import 'package:tinder_new/util/constants.dart';

import '../widgets/app_image_with_text.dart';
import 'forgot_pw_page.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _inputEmail = '';
  String _inputPassword = '';
  bool _isLoading = false;
  late UserProvider _userProvider;

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of(context, listen: false);
  }

  void loginPressed() async {
    setState(() {
      _isLoading = true;
    });
    await _userProvider
        .loginUser(_inputEmail, _inputPassword, _scaffoldKey)
        .then((response) {
      if (response is Success<UserCredential>) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(TopNavigationScreen.id, (route) => false);
      } else if (response is Error) {
        // Show error message in a snackbar
        String errorMessage = 'Incorrect email or password.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: CustomModalProgressHUD(
          inAsyncCall: _isLoading,
          offset: null,
          child: SingleChildScrollView(
            child: Padding(
              padding: kDefaultPadding,
              child: Container(
                margin: const EdgeInsets.only(bottom: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    const Icon(
                      Icons.pets_outlined,
                      color: Colors.deepOrange,
                      size: 250,
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      '-FURBUDDY-',
                      style: TextStyle(fontSize: 40, color: Colors.black87, fontFamily: 'Default'),
                    ),
                    const SizedBox(height: 10.0), // Add spacing between the texts
                    Text(
                      "Let's find a Companion for your pet",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.w100),
                    ),
                    const SizedBox(height: 40),
                    BorderedTextField(
                      labelText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) => _inputEmail = value,
                    ),
                    const SizedBox(height: 10),
                    BorderedTextField(
                      labelText: 'Password',
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      onChanged: (value) => _inputPassword = value,
                    ),

                    const SizedBox(height: 10),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return const ForgotPasswordPage();
                                },
                                ),
                              );
                            },

                            child: const Text('Forgot Password?',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.deepOrange, // Text color
                        minimumSize: const Size.fromHeight(50),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'LOGIN',
                        style: TextStyle(fontSize: 24),
                      ),
                      onPressed: () {
                        loginPressed();
                      },
                    ),

                    const SizedBox(height: 35),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Not a member?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, RegisterScreen.id);
                          },
                          child: const Text(
                            '  Register now',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
