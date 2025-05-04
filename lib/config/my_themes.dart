import 'package:chatsetgo/config/cust_colors.dart';
import 'package:flutter/material.dart';

var lightTheme = ThemeData();
var darkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,

  inputDecorationTheme: InputDecorationTheme(
    fillColor: dbackgroundColor,
    filled: true,
  ),

  appBarTheme: AppBarTheme(
    backgroundColor: dbackgroundColor,
    foregroundColor: dprimaryColor,
    // elevation: 0,
  ),

  colorScheme: const ColorScheme.dark(
    primary: dprimaryColor,
    onPrimary: dOnbackgroundColor,
    surface: dbackgroundColor,
    onSurface: dOnbackgroundColor,
    primaryContainer: dContainerColor,
    onPrimaryContainer: dOnContainerColor,
  ),

  textTheme: TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32,
      color: dprimaryColor,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w800, // ExtraBold
    ),
    headlineMedium: TextStyle(
      fontSize: 30,
      color: dOnbackgroundColor,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w600, // SemiBold
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      color: dprimaryColor,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w700, // Bold
    ),
    labelLarge: TextStyle(
      fontSize: 15,
      color: dOnContainerColor,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w400, // Regular
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      color: dOnContainerColor,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w400, // Regular
    ),
    labelSmall: TextStyle(
      fontSize: 10,
      color: dOnContainerColor,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w300, // Regular
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: dOnbackgroundColor,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w500, // Regular
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      color: dOnbackgroundColor,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w500, // Regular
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      color: dOnbackgroundColor,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w400, // Regular
    ),
  ),
);
