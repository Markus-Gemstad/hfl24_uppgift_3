import 'package:flutter/material.dart';
import 'package:parkmycar_client_repo/parkmycar_http_repo.dart';
import 'package:parkmycar_shared/parkmycar_shared.dart';
import 'package:parkmycar_user/globals.dart';
import 'package:parkmycar_user/screens/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  String? email;

  void saveForm(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      if (!mounted) return;

      formKey.currentState!.save();

      // TODO: Ersätt med smartare funktion för att hämta användare baserat på email.
      // Gör detta med nästa repo (firebase).
      try {
        List<Person> all = await PersonHttpRepository.instance.getAll();
        var filtered = all.where((e) => e.email == email);
        if (filtered.isNotEmpty) {
          currentPerson = filtered.first;

          Navigator.push(
            // ignore: use_build_context_synchronously
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  const MainScreen(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        } else {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Inloggningen misslyckades!')));
        }
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Det blev nåt fel: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                initialValue: 'markus@gemstad.se',
                validator: (value) {
                  if (!Validators.isValidEmail(value)) {
                    return 'Ange en giltig e-postadress.';
                  }
                  return null;
                },
                onFieldSubmitted: (_) async => saveForm(context),
                onSaved: (newValue) => email = newValue,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(), labelText: 'E-postadress'),
              ),
            ),
            ElevatedButton(
              child: const Text('Logga in'),
              onPressed: () async => saveForm(context),
            ),
          ],
        ),
      ),
    );
  }
}
