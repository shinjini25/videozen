import 'package:flutter/material.dart';
import 'package:videozen/constants.dart';
import 'package:videozen/views/screens/auth/login_screen.dart';
import 'package:videozen/views/screens/auth/signup_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: backgroundColor,
        ),
        title: 'Videozen',
        home: SignupScreen());
  }
}
