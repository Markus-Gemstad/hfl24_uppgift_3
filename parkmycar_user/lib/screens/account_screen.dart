import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:parkmycar_client_repo/parkmycar_http_repo.dart';
import 'package:parkmycar_shared/parkmycar_shared.dart';
import 'package:parkmycar_user/globals.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final formKey = GlobalKey<FormState>();
  String? name;

  void saveForm(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      if (!mounted) return;

      formKey.currentState!.save();

      try {
        currentPerson!.name = name!;
        await PersonHttpRepository.instance.update(currentPerson!);

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Person uppdaterad!')));
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Person kunde inte sparas!')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Center(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                initialValue: currentPerson!.name,
                maxLength: 255,
                validator: (value) {
                  if (!Validators.isValidName(value)) {
                    return 'Ange ett giltigt namn.';
                  }
                  return null;
                },
                onFieldSubmitted: (_) => saveForm(context),
                onSaved: (newValue) => name = newValue,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(), labelText: 'Namn'),
              ),
              TextFormField(
                initialValue: currentPerson!.email,
                readOnly: true,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'E-post (går inte att ändra)'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Spara'),
                onPressed: () async => saveForm(context),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(Icons.logout),
                label: const Text('Logga ut'),
                onPressed: () => Navigator.pop(context),
              ),
              Visibility(
                visible: kDebugMode,
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    TextButton(
                        onPressed: () async => createBaseData,
                        child: Text('Fyll på med basdata')),
                    TextButton(
                        onPressed: () async => createParkingSpaces,
                        child: Text('Fyll på med parkeringsplatser')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void createBaseData() async {
  Person? person = await PersonHttpRepository.instance
      .create(Person("Markus Gemstad", "1122334455"));

  await VehicleHttpRepository.instance
      .create(Vehicle("ABC123", person!.id, VehicleType.car));
  await VehicleHttpRepository.instance
      .create(Vehicle("BCD234", person.id, VehicleType.motorcycle));

  // DateTime endTime = DateTime.now().add(const Duration(hours: 1));
  // await ParkingHttpRepository.instance
  //     .create(Parking(1, 1, DateTime.now(), endTime));
}

void createParkingSpaces() async {
  await ParkingSpaceHttpRepository.instance
      .create(ParkingSpace('Nya Stadens Torg 1', '531 31', 'Lidköping', 40));
  await ParkingSpaceHttpRepository.instance
      .create(ParkingSpace('Gamla Stadens Torg 4', '531 32', 'Lidköping', 15));
  await ParkingSpaceHttpRepository.instance
      .create(ParkingSpace('Esplanaden 6', '531 33', 'Lidköping', 35));
  await ParkingSpaceHttpRepository.instance
      .create(ParkingSpace('Rådagatan 10', '531 35', 'Lidköping', 50));
  await ParkingSpaceHttpRepository.instance
      .create(ParkingSpace('Östbygatan 18', '531 37', 'Lidköping', 25));
  await ParkingSpaceHttpRepository.instance
      .create(ParkingSpace('Stenportsgatan 9', '531 40', 'Lidköping', 40));
  await ParkingSpaceHttpRepository.instance
      .create(ParkingSpace('Kållandsgatan 22', '531 44', 'Lidköping', 20));
  await ParkingSpaceHttpRepository.instance
      .create(ParkingSpace('Skaragatan 5', '531 30', 'Lidköping', 50));
  await ParkingSpaceHttpRepository.instance
      .create(ParkingSpace('Sockerbruksgatan 15', '531 40', 'Lidköping', 20));
  await ParkingSpaceHttpRepository.instance
      .create(ParkingSpace('Mariestadsvägen 2', '531 60', 'Lidköping', 40));
  await ParkingSpaceHttpRepository.instance
      .create(ParkingSpace('Torggatan 3', '531 31', 'Lidköping', 10));
  await ParkingSpaceHttpRepository.instance
      .create(ParkingSpace('Hamngatan 12', '531 32', 'Lidköping', 20));
  await ParkingSpaceHttpRepository.instance
      .create(ParkingSpace('Västra Hamngatan 5', '531 33', 'Lidköping', 20));
  await ParkingSpaceHttpRepository.instance
      .create(ParkingSpace('Framnäsvägen 1', '531 36', 'Lidköping', 40));
  await ParkingSpaceHttpRepository.instance
      .create(ParkingSpace('Götgatan 7', '531 31', 'Lidköping', 40));
  await ParkingSpaceHttpRepository.instance
      .create(ParkingSpace('Östra Hamnen 10', '531 32', 'Lidköping', 10));
  await ParkingSpaceHttpRepository.instance
      .create(ParkingSpace('Viktoriagatan 14', '531 30', 'Lidköping', 30));
  await ParkingSpaceHttpRepository.instance
      .create(ParkingSpace('Majorsallén 3', '531 40', 'Lidköping', 40));
  await ParkingSpaceHttpRepository.instance
      .create(ParkingSpace('Hovbygatan 20', '531 41', 'Lidköping', 15));
  await ParkingSpaceHttpRepository.instance
      .create(ParkingSpace('Kvarngatan 9', '531 42', 'Lidköping', 45));
}
