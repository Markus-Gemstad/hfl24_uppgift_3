import 'package:flutter/material.dart';
import 'package:parkmycar_client_repo/parkmycar_client_stuff.dart';
import 'package:parkmycar_client_repo/parkmycar_http_repo.dart';
import 'package:parkmycar_shared/parkmycar_shared.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key, this.isEditMode = true, this.doPop = false});

  final bool isEditMode;
  final bool doPop;

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _email;

  void savePerson(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      if (!mounted) return;

      _formKey.currentState!.save();

      try {
        if (widget.isEditMode) {
          // Update currently logged in person
          Person? currentPerson = context.read<AuthService>().currentPerson;
          currentPerson!.name = _name!;
          await PersonHttpRepository.instance.update(currentPerson);
        } else {
          // Save new person
          await PersonHttpRepository.instance.create(Person(_name!, _email!));
        }

        String successMessage =
            (widget.isEditMode) ? 'Person uppdaterad!' : 'Person skapad!';
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(successMessage)));
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Person kunde inte sparas!')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Person? currentPerson = context.read<AuthService>().currentPerson;
    String title = (widget.isEditMode) ? 'Redigera konto' : 'Skapa konto';

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: Theme.of(context).textTheme.headlineSmall),
                TextFormField(
                  initialValue: currentPerson?.name,
                  validator: (value) => Validators.isValidName(value)
                      ? null
                      : 'Ange ett giltigt namn.',
                  onFieldSubmitted: (_) => savePerson(context),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onSaved: (newValue) => _name = newValue,
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(), labelText: 'Namn'),
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: currentPerson?.email,
                  autovalidateMode: AutovalidateMode.onUnfocus,
                  validator: (value) => Validators.isValidEmail(value)
                      ? null
                      : 'Ange en giltig e-postadress',
                  readOnly: widget.isEditMode,
                  onSaved: (newValue) => _email = newValue,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: (widget.isEditMode)
                          ? 'E-post (går inte att ändra)'
                          : 'E-post'),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Visibility(
                      visible: widget.doPop,
                      child: ElevatedButton(
                        child: const Text('Avbryt'),
                        onPressed: () {
                          if (widget.doPop) {
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 20),
                    FilledButton(
                      child: const Text('Spara'),
                      onPressed: () async {
                        savePerson(context);
                        if (widget.doPop) {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
