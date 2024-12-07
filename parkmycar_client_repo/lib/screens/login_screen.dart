import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:parkmycar_shared/parkmycar_shared.dart';

import 'account_screen.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final usernameFocus = FocusNode();
    // final passwordFocus = FocusNode();
    final authService = context.watch<AuthService>();
    String? email;

    // Request focus only when not authenticating
    if (authService.status == AuthStatus.unauthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        usernameFocus.requestFocus();
      });
    }

    Future<void> login() async {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        AuthStatus authStatus =
            await context.read<AuthService>().login(email!, admin: true);

        if (authStatus == AuthStatus.unauthenticated) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Inloggningen misslyckades!')));
        }
      }
    }

    return Scaffold(
      body: Center(
        child: Form(
          key: formKey,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  focusNode: usernameFocus,
                  initialValue: 'markus@gemstad.se',
                  enabled: authService.status != AuthStatus.authenticating,
                  decoration: const InputDecoration(
                    labelText: 'E-postadress',
                    prefixIcon: Icon(Icons.person),
                  ),
                  autovalidateMode: AutovalidateMode.onUnfocus,
                  validator: (value) => Validators.isValidEmail(value)
                      ? null
                      : 'Ange en giltig e-postadress',
                  onFieldSubmitted: (_) => login(),
                  onSaved: (newValue) => email = newValue,
                ),
                // const SizedBox(height: 16),
                // TextFormField(
                //   focusNode: passwordFocus,
                //   obscureText: true,
                //   enabled: authService.status != AuthStatus.authenticating,
                //   decoration: const InputDecoration(
                //     labelText: 'Lösenord',
                //     prefixIcon: Icon(Icons.lock),
                //   ),
                //   validator: (value) =>
                //       value?.isEmpty ?? true ? 'Ange ett lösenord' : null,
                //   onFieldSubmitted: (_) {
                //     if (formKey.currentState!.validate()) {
                //       context.read<AuthService>().login();
                //     }
                //   },
                // ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: authService.status == AuthStatus.authenticating
                      ? FilledButton(
                          onPressed: () {},
                          child: SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        )
                      : FilledButton(
                          onPressed: () => login(),
                          child: const Text('Logga in'),
                        ),
                ),
                const SizedBox(height: 32),
                Text('Eller saknar du konto?'),
                const SizedBox(height: 16),
                TextButton(
                    onPressed: () {
                      formKey.currentState!.reset();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AccountScreen(
                                isEditMode: false,
                                doPop: true,
                              )));
                    },
                    child: Text('Skapa nytt konto'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
