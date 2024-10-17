import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:tinder_new/data/db/remote/response.dart';
import 'package:tinder_new/data/model/user_registration.dart';
import 'package:tinder_new/data/provider/user_provider.dart';
import 'package:tinder_new/ui/screens/register_sub_screens/add_photo_screen.dart';
import 'package:tinder_new/ui/screens/register_sub_screens/age_screen.dart';
import 'package:tinder_new/ui/screens/register_sub_screens/guide_screen.dart';
import 'package:tinder_new/ui/screens/register_sub_screens/sexual_screen.dart';
import 'package:tinder_new/ui/screens/register_sub_screens/email_and_password_screen.dart';
import 'package:tinder_new/ui/screens/register_sub_screens/name_screen.dart';
import 'package:tinder_new/ui/screens/register_sub_screens/terms_and_condition.dart';
import 'package:tinder_new/ui/screens/top_navigation_screen.dart';
import 'package:tinder_new/ui/widgets/custom_modal_progress_hud.dart';
import 'package:tinder_new/util/constants.dart';
import 'package:tinder_new/util/utils.dart';
import 'package:tinder_new/ui/screens/start_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = 'register_screen';

  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final UserRegistration _userRegistration = UserRegistration();
  String confirmPassword = "";
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final int _endScreenIndex = 6;
  int _currentScreenIndex = 0;
  bool _isLoading = false;
  late UserProvider _userProvider;
  final log = Logger('_RegisterScreenState');

  @override
  void initState() {
    log.fine('initState');

    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  void registerUser() async {
    log.fine('registerUser');

    setState(() {
      _isLoading = true;
    });

    log.fine('_userProvide call');
    await _userProvider
        .registerUser(_userRegistration, _scaffoldKey)
        .then((response) {
      if (response is Success) {
        Navigator.pop(context);
        Navigator.pushNamed(context, TopNavigationScreen.id);
      }
    });

    setState(() {
      _isLoading = false;
    });
  }

  void goBackPressed() {
    if (_currentScreenIndex == 0) {
      Navigator.pop(context);
      Navigator.pushNamed(context, StartScreen.id);
    } else {
      setState(() {
        _currentScreenIndex--;
      });
    }
  }

  Widget getSubScreen() {
    switch (_currentScreenIndex) {
      case 0:
        return NameScreen(
          userName: (value) => {_userRegistration.name = value},
          userAge: (value) => {_userRegistration.age = value.toInt()},
          emailOnChanged: (value) => {_userRegistration.email = value},
          passwordOnChanged: (value) => {_userRegistration.password = value},
          confirmPasswordOnChanged: (value) => {confirmPassword = value},
        );

      case 1:
        return TermsAndConditionsScreen();

      case 2:
        return AddPhotoScreen(
            onPhotoChanged: (value) =>
            {_userRegistration.localProfilePhotoPath = value},
            userDogName: (value) => {_userRegistration.dogName = value},
            selectedGender: (value) => {_userRegistration.gender = value},
            dogBreed: (value) => {_userRegistration.dogBreed = value},
            dogAge: (value) => {_userRegistration.dogAge = value},
            bio: (value) => {_userRegistration.bio = value},
            dogSize: (value) => {_userRegistration.dogSize = value});
      case 3:
        return AgeScreen(
          album1: (value) => {_userRegistration.album1 = value},
          album2: (value) => {_userRegistration.album2 = value},
          album3: (value) => {_userRegistration.album3 = value},
          album4: (value) => {_userRegistration.album4 = value},
        );
      case 4:
        return EmailAndPasswordScreen(
            location: (value) => {_userRegistration.location = value});
      case 5:
        return SexualScreen(
            selectedPersonality: (value) =>
            {_userRegistration.dogPersonality = value}
        );
      case 6:
        return GuideScreen();
      default:
        return Container();
    }
  }

  bool canContinueToNextSubScreen() {
    switch (_currentScreenIndex) {
      case 0:
        return (_userRegistration.name.isNotEmpty &&
            _userRegistration.age != null &&
            _userRegistration.email.isNotEmpty &&
            _userRegistration.password.isNotEmpty &&
            confirmPassword.isNotEmpty &&
            _userRegistration.password == confirmPassword);
      case 1:
        return true;
      case 2:
        return (_userRegistration.localProfilePhotoPath.isNotEmpty &&
            _userRegistration.dogName.isNotEmpty &&
            _userRegistration.gender.isNotEmpty &&
            _userRegistration.dogBreed.isNotEmpty &&
            _userRegistration.dogAge.isNotEmpty &&
            _userRegistration.bio.isNotEmpty &&
            _userRegistration.dogSize.isNotEmpty);
      case 3:
        return true;
      case 4:
        return true;
      case 5:
        return true;
      case 6:
        return true;
      default:
        return false;
    }
  }

  String getInvalidRegistrationMessage() {
    switch (_currentScreenIndex) {
      case 0:
        if (_userRegistration.name.isEmpty ||
            _userRegistration.age == null ||
            _userRegistration.email.isEmpty ||
            _userRegistration.password.isEmpty ||
            confirmPassword.isEmpty) {
          return "Missing input";
        } else if (_userRegistration.password != confirmPassword) {
          return "Password doesn't match";
        }
        return "Invalid";
      case 1:
         return "Invalid";
      case 2:
        if (_userRegistration.localProfilePhotoPath.isEmpty ||
            _userRegistration.dogName.isEmpty ||
            _userRegistration.gender.isEmpty ||
            _userRegistration.dogBreed.isEmpty ||
            _userRegistration.dogAge.isEmpty ||
            _userRegistration.bio.isEmpty ||
            _userRegistration.dogSize.isEmpty) {
          return "Missing input";
        }
        return "Invalid";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        body: CustomModalProgressHUD(
          inAsyncCall: _isLoading,
          offset: null,
          child: Container(
            margin: const EdgeInsets.only(bottom: 0),
            child: Column(
              children: [
                LinearPercentIndicator(
                    lineHeight: 5,
                    percent: (_currentScreenIndex / _endScreenIndex),
                    progressColor: Colors.deepOrange,
                    padding: EdgeInsets.zero),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      padding: kDefaultPadding.copyWith(
                          left: kDefaultPadding.left / 2.0,
                          right: 0.0,
                          bottom: 0,
                          top: 0),
                      child: IconButton(
                        padding: const EdgeInsets.all(0.0),
                        icon: Icon(
                          _currentScreenIndex == 0
                              ? Icons.clear
                              : Icons.arrow_back,
                          color: Colors.grey,
                          size: 42.0,
                        ),
                        onPressed: () {
                          goBackPressed();
                        },
                      )),
                ),
                Expanded(
                  child: Container(
                      width: double.infinity,
                      padding: kDefaultPadding.copyWith(top: 0, bottom: 0),
                      child: getSubScreen()),
                ),
                Container(
                  padding: kDefaultPadding,
                  child: _currentScreenIndex == _endScreenIndex
                      ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.orange, // Text color
                      minimumSize: const Size.fromHeight(50),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'REGISTER',
                      style: TextStyle(fontSize: 24),
                    ),
                    onPressed: () {
                      _isLoading == false ? registerUser() : null;
                    },
                  )
                      : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.orange, // Text color
                      minimumSize: const Size.fromHeight(50),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'CONTINUE',
                      style: TextStyle(fontSize: 24),
                    ),
                    onPressed: () {
                      if (canContinueToNextSubScreen()) {
                        setState(() {
                          _currentScreenIndex++;
                        });
                      } else {
                        showSnackBarNew(
                            context, getInvalidRegistrationMessage());
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}