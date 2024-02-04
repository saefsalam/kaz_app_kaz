import 'package:flutter/material.dart';

ThemeData LightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade300,
    primary: Colors.grey.shade200,
    secondary: Colors.grey.shade100,
    onBackground: Colors.black, 
  ),
);

ThemeData DarkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: const Color.fromARGB(255, 48, 48, 48),
    primary: Color.fromARGB(255, 19, 19, 19),
    secondary: const Color.fromARGB(255, 61, 61, 61),
    onBackground: Colors.white, 
  ),
);




const mobileBackgroundColor = Color.fromRGBO(0, 0, 0, 1);
const webBackgroundColor = Color.fromRGBO(32, 33, 36, 1);
// Color primaryColor = Colors.white;
Color primaryColor1 = const Color.fromRGBO(69, 155, 150, 1);
const secondaryColor = Color.fromRGBO(13, 96, 90, 1);
const blueColor = Color.fromRGBO(0, 149, 246, 1);
