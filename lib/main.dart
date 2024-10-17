import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tinder_new/data/provider/user_provider.dart';
import 'package:tinder_new/ui/screens/chat_screen.dart';
import 'package:tinder_new/ui/screens/login_screen.dart';
import 'package:tinder_new/ui/screens/matched_screen.dart';
import 'package:tinder_new/ui/screens/register_screen.dart';
import 'package:tinder_new/ui/screens/splash_screen.dart';
import 'package:tinder_new/ui/screens/start_screen.dart';
import 'package:tinder_new/ui/screens/top_navigation_screen.dart';
import 'package:tinder_new/util/constants.dart';
import 'package:logging/logging.dart';

void main() async {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    if (kDebugMode) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    }
  });

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(systemNavigationBarColor: Colors.black));
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => UserProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: kFontFamily,
          indicatorColor: kAccentColor,
          primarySwatch:
          const MaterialColor(kBackgroundColorInt, kThemeMaterialColor),
          scaffoldBackgroundColor: kPrimaryColor,
          hintColor: kSecondaryColor,
          textTheme: const TextTheme(
            displayLarge:
            TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            displayMedium:
            TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
            displaySmall:
            TextStyle(fontSize: 38.0, fontWeight: FontWeight.bold),
            headlineMedium:
            TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            bodyLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            bodyMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
            labelLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ).apply(
            bodyColor: kSecondaryColor,
            displayColor: kSecondaryColor,
          ),
          buttonTheme: const ButtonThemeData(
            splashColor: Colors.transparent,
            padding: EdgeInsets.symmetric(vertical: 14),
            buttonColor: kAccentColor,
            textTheme: ButtonTextTheme.normal,
            highlightColor: Color.fromRGBO(0, 0, 0, .3),
            focusColor: Color.fromRGBO(0, 0, 0, .3),
          ),
        ),
        initialRoute: SplashScreen.id,
        routes: {
          SplashScreen.id: (context) => SplashScreen(),
          StartScreen.id: (context) => Scaffold(
            body: const LoginScreen(),
          ),
          LoginScreen.id: (context) => Scaffold(
            appBar: AppBar(
              title: Center(child: Text('')),
              backgroundColor: kPrimaryColor,
              automaticallyImplyLeading: false,),
            body: LoginScreen(),
          ),
          RegisterScreen.id: (context) => Scaffold(
            appBar: AppBar(
              title: Center(
                  child: Text('FURBUDDY',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54))),
              backgroundColor: Colors.orange,
              automaticallyImplyLeading: false,),
            body: RegisterScreen(),
          ),
          TopNavigationScreen.id: (context) => TopNavigationScreen(),
          MatchedScreen.id: (context) => MatchedScreen(
            myProfilePhotoPath: (ModalRoute.of(context)!.settings.arguments
            as Map)['my_profile_photo_path'],
            myUserId: (ModalRoute.of(context)!.settings.arguments
            as Map)['my_user_id'],
            otherUserProfilePhotoPath: (ModalRoute.of(context)!
                .settings
                .arguments as Map)['other_user_profile_photo_path'],
            otherUserId: (ModalRoute.of(context)!.settings.arguments
            as Map)['other_user_id'],
          ),
          ChatScreen.id: (context) => ChatScreen(
            chatId: (ModalRoute.of(context)!.settings.arguments
            as Map)['chat_id'],
            otherUserId: (ModalRoute.of(context)!.settings.arguments
            as Map)['other_user_id'],
            myUserId: (ModalRoute.of(context)!.settings.arguments
            as Map)['user_id'],
          ),
        },
      ),
    );
  }
}
