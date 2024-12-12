import 'package:flutter/material.dart';
import 'package:parkmycar_client_shared/parkmycar_client_stuff.dart';
import 'package:parkmycar_client_shared/parkmycar_http_repo.dart';
import 'package:parkmycar_shared/parkmycar_shared.dart';
import 'package:parkmycar_user/screens/vehicle_edit_dialog.dart';
import 'package:provider/provider.dart';

import '../globals.dart';

class VehicleScreen extends StatefulWidget {
  const VehicleScreen({super.key});

  @override
  State<VehicleScreen> createState() => _VehicleScreenState();
}

class _VehicleScreenState extends State<VehicleScreen> {
  Future<List<Vehicle>> getAllVehicles() async {
    var items = await VehicleHttpRepository.instance
        .getAll((a, b) => a.regNr.compareTo(b.regNr));

    if (context.mounted) {
      // ignore: use_build_context_synchronously
      Person? currentPerson = context.read<AuthService>().currentPerson;

      // TODO Ersätt med bättre relationer mellan Vehicle och Person
      items = items
          .where((element) => element.personId == currentPerson!.id)
          .toList();
    }

    // Added delay to demonstrate loading animation
    return Future.delayed(
        Duration(milliseconds: delayLoadInMilliseconds), () => items);
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    String successMessage;
    try {
      if (vehicle.id > 0) {
        await VehicleHttpRepository.instance.update(vehicle);
        successMessage = 'Fordonet ${vehicle.regNr} har updaterats!';
      } else {
        await VehicleHttpRepository.instance.create(vehicle);
        successMessage = 'Fordonet ${vehicle.regNr} har lagts till!';
      }

      // Update listview
      setState(() {
        getAllVehicles();
      });

      // Use to avoid use_build_context_synchronously warning
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(successMessage)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Det gick inte att spara fordonet ${vehicle.regNr}!')));
    }
  }

  Future<void> removeVehicle(Vehicle item) async {
    try {
      await VehicleHttpRepository.instance.delete(item.id);

      // Update listview
      setState(() {
        getAllVehicles();
      });

      // Use !mounted to avoid use_build_context_synchronously warning
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fordonet ${item.regNr} har tagits bort!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Det gick inte att ta bort fordonet ${item.regNr}!')));
    }
  }

  Future<bool?> showDeleteDialog(Vehicle item) {
    return showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Ta bort ${item.regNr}?'),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Avbryt')),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Ta bort')),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      FutureBuilder<List<Vehicle>>(
          future: getAllVehicles(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return SizedBox.expand(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Finns inga fordon.'),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12.0),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Vehicle item = snapshot.data![index];
                  return ListTile(
                    leading: Icon(Icons.directions_car),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () async {
                              Vehicle? vehicle = await showDialog<Vehicle>(
                                context: context,
                                builder: (context) =>
                                    VehicleEditDialog(vehicle: item),
                              );

                              debugPrint(vehicle.toString());

                              if (vehicle != null && vehicle.isValid()) {
                                await updateVehicle(vehicle);
                              }
                            }),
                        IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              var delete = await showDeleteDialog(item);
                              if (delete == true) {
                                await removeVehicle(item);
                              }
                            }),
                      ],
                    ),
                    title: Text(item.regNr),
                  );
                },
              );
            }

            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Error: ${snapshot.error}'),
              );
            }

            return Center(child: CircularProgressIndicator());
          }),
      Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () async {
              Vehicle? vehicle = await showDialog<Vehicle>(
                context: context,
                builder: (context) => VehicleEditDialog(),
              );

              debugPrint(vehicle.toString());

              if (vehicle != null && vehicle.isValid()) {
                await updateVehicle(vehicle);
              }
            },
            child: Icon(Icons.add),
          )),
    ]);
  }
}
