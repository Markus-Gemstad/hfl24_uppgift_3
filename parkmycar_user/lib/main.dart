import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:parkmycar_client_repo/parkmycar_client_stuff.dart';
import '/screens/main_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthService(),
      child: const ParkMyCarApp(),
    ),
  );
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
      home: const AuthViewSwitcher(),
    );
  }
}

class AuthViewSwitcher extends StatelessWidget {
  const AuthViewSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final authStatus = context.watch<AuthService>().status;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: authStatus == AuthStatus.authenticated
          ? const MainScreen()
          : const LoginScreen(title: 'ParkMyCar'),
    );
  }
}
