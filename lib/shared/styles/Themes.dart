import 'package:diginote/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

MaterialColor customGum = const MaterialColor(0xFF8C52FF, {
  50: Color(0xFFE0C7FF),
  100: Color(0xFFD3AFFF),
  200: Color(0xFFC68AFF),
  300: Color(0xFFB973FF),
  400: Color(0xFFAC5BFF),
  500: Color(0xFF8C52FF),
  600: Color(0xFF824AF0),
  700: Color(0xFF7742E0),
  800: Color(0xFF6D3AD1),
  900: Color(0xFF6332C1),
});

ThemeData lightTheme = ThemeData(
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 30,
      backgroundColor: Styles.greyColor,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Styles.gumColor,
      unselectedItemColor: Styles.greyColor,
      selectedLabelStyle: TextStyle(fontFamily: 'bitter'),
    ),
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: Styles.gumColor),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Styles.whiteColor,
        statusBarIconBrightness: Brightness.dark,
      ),
      backgroundColor: Styles.whiteColor,
      elevation: 0.0,
      titleTextStyle: TextStyle(color: Styles.blackColor),
    ),
    scaffoldBackgroundColor: Styles.whiteColor,
    primarySwatch: customGum,
    textTheme: TextTheme(
      bodyMedium:
      const TextStyle(color: Styles.blackColor, fontFamily: 'bitter'),
      bodySmall: TextStyle(
          color: Styles.blackColor.withOpacity(0.5), fontFamily: 'bitter'),
    ),
    inputDecorationTheme: InputDecorationTheme(
      prefixIconColor: Styles.lightBlackColor,
      suffixIconColor: Styles.greyColor.withOpacity(0.5),
      labelStyle: const TextStyle(color: Styles.blackColor),
    )
);
ThemeData darkTheme = ThemeData(
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 30,
      backgroundColor: Styles.lightBlackColor,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Styles.gumColor,
      unselectedItemColor: Styles.greyColor,
      selectedLabelStyle: TextStyle(fontFamily: 'bitter'),
    ),
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: Styles.whiteColor),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Styles.blackColor,
        statusBarIconBrightness: Brightness.light,
      ),
      backgroundColor: Styles.blackColor,
      elevation: 0.0,
      titleTextStyle: TextStyle(color: Styles.whiteColor),
    ),
    scaffoldBackgroundColor: Styles.blackColor,
    primarySwatch: customGum,
    textTheme: TextTheme(
      bodyMedium: const TextStyle(
          color: Styles.whiteColor, fontFamily: 'bitter'),
      bodySmall: TextStyle(
          color: Styles.greyColor.withOpacity(0.5), fontFamily: 'bitter'),
    ),
    inputDecorationTheme: const InputDecorationTheme(
        prefixIconColor: Styles.greyColor,
        suffixIconColor: Styles.lightBlackColor,
        labelStyle: TextStyle(color: Styles.greyColor)));
