import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppConstant {
  static String AppMainName = "E-commerece";
  static String AppPoweredNy = "Powered By Deebugs";
}

class MyTheme {
  static Color light = Color.fromARGB(255, 210, 227, 241);
  static Color medlight = Color.fromARGB(255, 188, 223, 255);
  static Color dark = Color.fromARGB(255, 69, 164, 228);
  static Color darkLight = Colors.white;
  static Color medDark = const Color.fromARGB(157, 56, 55, 55);
  static Color darkDark = const Color.fromARGB(157, 3, 3, 3);

  static ThemeData lightTheme(BuildContext context) => ThemeData(
      fontFamily: GoogleFonts.poppins().fontFamily,
      cardColor: medlight,
      canvasColor: light,
      primaryColor: Colors.white,
      primaryColorLight: Colors.white,
      colorScheme: ColorScheme.light(
          primary: light,
          onPrimary: dark,
          secondary: dark,
          surface: Colors.white,
          tertiary: Colors.black,
          onTertiary: const Color.fromARGB(255, 214, 214, 214),
          tertiaryFixed: const Color.fromARGB(255, 107, 105, 105)
          ),
        
      iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(overlayColor: WidgetStatePropertyAll(light))));

  static ThemeData darkTheme(BuildContext context) => ThemeData(
      // brightness: Brightness.dark,
      fontFamily: GoogleFonts.poppins().fontFamily,
      cardColor: medDark,
      canvasColor: darkLight,
      primaryColor: const Color.fromARGB(255, 41, 38, 38),
      primaryColorLight: const Color.fromARGB(255, 71, 71, 71),
      colorScheme: ColorScheme.dark(
          primary: darkLight, // AppBar background color
          onPrimary: Colors.white, // text color
          secondary: Colors.black, // Secondary color
          surface: const Color.fromARGB(255, 99, 98, 98),
          tertiary: Colors.white,
          onTertiary: Colors.white // Card background color
          ),
      iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(overlayColor: WidgetStatePropertyAll(medlight))),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(Colors.white),
            backgroundColor: WidgetStatePropertyAll(dark),
            splashFactory: InkRipple.splashFactory,
            overlayColor: WidgetStatePropertyAll(medlight),
          ),
        ),
        );
}
