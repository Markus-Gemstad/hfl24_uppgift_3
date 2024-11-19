import 'package:flutter/material.dart';
import 'package:parkmycar_user/screens/main_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(), labelText: 'E-postadress'),
            ),
          ),
          ElevatedButton(
            child: const Text('Logga in'),
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      const MainScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
