import 'package:flutter/material.dart';

const kDefaultPadding = EdgeInsets.symmetric(
  vertical: 36.0,
  horizontal: 26.0,
);

const kPrimaryColor = Color(0xFFFFDCB2);
const kSecondaryColor = Colors.black;
const kAccentColor = Colors.black;

const kColorPrimaryVariant = Color(0xFF424242);
const kBackgroundColor = Color(0xFF1D1C1C);
const kBackgroundColorInt = 0xFFFFFFFF;
const kFontFamily = 'Nunito';

const kTextTheme = TextTheme(
  displayLarge: TextStyle(),
  bodyLarge: TextStyle(),
  bodyMedium: TextStyle(),
);

const kButtonTheme = ButtonThemeData(
  splashColor: Colors.transparent,
  padding: EdgeInsets.symmetric(vertical: 14),
  buttonColor: Color(0xFFFFFFFF),
  textTheme: ButtonTextTheme.accent,
  highlightColor: Color.fromRGBO(0, 0, 0, .3),
  focusColor: Color.fromRGBO(0, 0, 0, .3),
);

const Map<int, Color> kThemeMaterialColor = {
  50: Color.fromRGBO(0, 0, 0, .1),
  100: Color.fromRGBO(0, 0, 0, .2),
  200: Color.fromRGBO(0, 0, 0, .3),
  300: Color.fromRGBO(0, 0, 0, .4),
  400: Color.fromRGBO(0, 0, 0, .5),
  500: Color.fromRGBO(0, 0, 0, .6),
  600: Color.fromRGBO(0, 0, 0, .7),
  700: Color.fromRGBO(0, 0, 0, .8),
  800: Color.fromRGBO(0, 0, 0, .9),
  900: Color.fromRGBO(0, 0, 0, 1),
};
