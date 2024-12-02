import 'package:flutter/material.dart';
import 'package:parkmycar_client_repo/parkmycar_http_repo.dart';
import 'package:parkmycar_shared/parkmycar_shared.dart';
import 'package:parkmycar_user/globals.dart';

class ParkingStartDialog extends StatefulWidget {
  const ParkingStartDialog(this.parkingSpace, {super.key});

  final ParkingSpace parkingSpace;

  @override
  State<ParkingStartDialog> createState() => _ParkingStartDialogState();
}

class _ParkingStartDialogState extends State<ParkingStartDialog> {
  late ParkingSpace parkingSpace;
  late int _selectedVehicleId;
  DateTime _selectedEndTime = DateTime.now().add(Duration(minutes: 5));

  Future<List<Vehicle>> getAllVehicles() async {
    return await VehicleHttpRepository.instance.getAll();
  }

  @override
  void initState() {
    super.initState();
    parkingSpace = widget.parkingSpace;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Starta parkering'),
        centerTitle: false,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              ListTile(
                leading: Hero(
                    tag: 'parkingicon${parkingSpace.id}',
                    transitionOnUserGestures: true,
                    child: Image.asset(
                      'assets/parking_icon.png',
                      width: 60.0,
                    )),
                title: Text(parkingSpace.streetAddress),
                subtitle:
                    Text('${parkingSpace.postalCode} ${parkingSpace.city}\n'
                        'Pris per timme: ${parkingSpace.pricePerHour} kr'),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    timeOnlyFormat.format(_selectedEndTime),
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    child: Text('Välj sluttid', style: TextStyle(fontSize: 18)),
                    onPressed: () async {
                      final TimeOfDay? timeOfDay = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (timeOfDay != null) {
                        setState(() {
                          _selectedEndTime = timeOfDayToDateTime(timeOfDay,
                              dateTime: _selectedEndTime);
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dateFormat.format(_selectedEndTime),
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    child:
                        Text('Välj slutdatum', style: TextStyle(fontSize: 18)),
                    onPressed: () async {
                      final DateTime? dateTime = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 7)),
                        initialDate: DateTime.now(),
                      );
                      if (dateTime != null) {
                        setState(() {
                          _selectedEndTime = dateTime;
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Fordon:', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 20),
                  FutureBuilder(
                    future: getAllVehicles(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        _selectedVehicleId = snapshot.data!.first.id;
                        return DropdownMenu(
                          initialSelection: snapshot.data!.first,
                          dropdownMenuEntries: snapshot.data!
                              .map<DropdownMenuEntry<Vehicle>>(
                                  (Vehicle vehicle) {
                            return DropdownMenuEntry<Vehicle>(
                                value: vehicle, label: vehicle.regNr);
                          }).toList(),
                          onSelected: (value) {
                            _selectedVehicleId = value!.id;
                          },
                        );
                      }

                      if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text('Error: ${snapshot.error}'),
                        );
                      }

                      return CircularProgressIndicator();
                    },
                  )
                ],
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                child: Text('Starta parkering', style: TextStyle(fontSize: 24)),
                onPressed: () async {
                  currentParkingSpace = parkingSpace;
                  Parking parking = Parking(
                      currentPerson!.id,
                      _selectedVehicleId,
                      parkingSpace.id,
                      DateTime.now(),
                      _selectedEndTime,
                      parkingSpace.pricePerHour);
                  Navigator.of(context).pop(parking);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

DateTime timeOfDayToDateTime(TimeOfDay timeOfDay, {DateTime? dateTime}) {
  if (dateTime != null) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day, timeOfDay.hour,
        timeOfDay.minute);
  } else {
    final now = DateTime.now();
    return DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
  }
}
