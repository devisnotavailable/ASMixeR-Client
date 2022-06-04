import 'package:flutter/material.dart';

import '../styles/styles.dart';

enum ThemeType { SYSTEM, DARK, LIGHT }

const double defaultBorderRadius = 36;
const double defaultPadding = 25;

final lightTheme = ThemeData(
  colorScheme:
      const ColorScheme.light(primary: Colors.blue, secondary: Colors.white),
  tabBarTheme: const TabBarTheme(
      labelColor: Colors.blue, unselectedLabelColor: Colors.black),
  appBarTheme: const AppBarTheme(
    titleTextStyle: MediumTextStyleBlack(),
    centerTitle: true,
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    elevation: 0,
  ),
  indicatorColor: Colors.blue,
  primaryColorLight: Colors.white,
  primaryColorDark: Colors.black,
  hintColor: const Color(0x80ffffff),
);

final darkTheme = ThemeData(
    colorScheme:
        const ColorScheme.dark(primary: Colors.blue, secondary: Colors.blue),
    scaffoldBackgroundColor: Colors.grey[850],
    tabBarTheme: const TabBarTheme(
        labelColor: Colors.blue, unselectedLabelColor: Colors.white),
    appBarTheme: AppBarTheme(
      titleTextStyle: const MediumTextStyle(),
      centerTitle: true,
      backgroundColor: Colors.grey[850],
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      elevation: 0,
    ),
    primaryColorLight: Colors.grey[800],
    primaryColorDark: Colors.white,
    indicatorColor: Colors.blue,
    hintColor: const Color(0x80ffffff));
