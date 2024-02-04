// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kaz_app_kaz/colors.dart';
import 'package:kaz_app_kaz/responsive/mobile.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(color: Theme.of(context).colorScheme.background,
      debugShowCheckedModeBanner: false,
      theme:LightMode,
      darkTheme: DarkMode,
      home: const SplashScreen(), // Use the SplashScreen as the initial screen
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay for 2 seconds and then navigate to MobileScreen
    Timer(
      const Duration(seconds: 2),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MobileScreen()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(backgroundColor: Theme.of(context).colorScheme.background,
      body:Center(
        child: Container(
          child: Image.asset("assets/logo1.png",height: 300,),),
      )
    );
  }
}

class MobileScreen extends StatelessWidget {
  const MobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MobileScerren();
  }
}
