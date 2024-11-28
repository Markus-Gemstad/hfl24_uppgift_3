import 'package:flutter/material.dart';
import 'package:parkmycar_user/globals.dart';
import 'package:parkmycar_user/screens/login_screen.dart';
import '/screens/main_screen.dart';

void main() {
  runApp(const ParkMyCarApp());
}

class ParkMyCarApp extends StatelessWidget {
  const ParkMyCarApp({super.key, this.dark = false});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Color.fromRGBO(85, 234, 242, 1.0),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Color.fromRGBO(85, 234, 242, 1.0),
      ),
      // theme: ThemeData(
      //     useMaterial3: true,
      //     colorSchemeSeed: Color.fromRGBO(85, 234, 242, 1.0)),
      home: (isLoggedIn) ? MainScreen() : LoginScreen(),
    );
  }
}
