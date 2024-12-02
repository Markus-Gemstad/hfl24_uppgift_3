import 'package:flutter/material.dart';
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
      home: AuthViewSwitcher(),
      // home: MainScreen(
      //   onLogout: () {},
      // ),
    );
  }
}

class AuthViewSwitcher extends StatelessWidget {
  AuthViewSwitcher({super.key});

  final _isLoggedIn = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<bool>(
          valueListenable: _isLoggedIn,
          builder: (context, isLoggedIn, child) {
            return AnimatedSwitcher(
                duration: Duration(milliseconds: 250),
                // switchInCurve: Curves.easeOut,
                // switchOutCurve: Curves.easeOut,
                // transitionBuilder: (child, animation) {
                //   return SlideTransition(
                //     position: Tween<Offset>(
                //       begin: const Offset(0, 1),
                //       end: Offset.zero,
                //     ).animate(animation),
                //     child: child,
                //   );
                // },
                child: isLoggedIn
                    ? MainScreen(
                        onLogout: () => _isLoggedIn.value = false,
                      )
                    : LoginScreen(
                        onLogin: () => _isLoggedIn.value = true,
                      ));
          }),
    );
  }
}
