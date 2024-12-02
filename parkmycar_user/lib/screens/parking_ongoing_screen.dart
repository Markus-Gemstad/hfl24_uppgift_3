import 'dart:async';
import 'package:flutter/material.dart';
import 'package:parkmycar_shared/parkmycar_shared.dart';
import 'package:parkmycar_user/globals.dart';

class ParkingOngoingScreen extends StatefulWidget {
  const ParkingOngoingScreen({super.key, required this.onEndParking});

  final Function onEndParking;

  @override
  State<ParkingOngoingScreen> createState() => _ParkingOngoingScreenState();
}

class _ParkingOngoingScreenState extends State<ParkingOngoingScreen> {
  Timer? _timer;
  String overdueWarning = '';

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {
          if (ongoingParking!.isOverdue) {
            overdueWarning = 'OBS! Din parkeringstid har gått ut!';
          }
        });
      },
    );
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ParkingSpace parkingSpace = currentParkingSpace!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pågående parkering'),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              ListTile(
                leading: Hero(
                  tag: 'parkingicon${parkingSpace.id}',
                  child: Image.asset(
                    'assets/parking_icon.png',
                    width: 60.0,
                  ),
                ),
                title: Text(parkingSpace.streetAddress),
                subtitle:
                    Text('${parkingSpace.postalCode} ${parkingSpace.city}\n'
                        'Pris per timme: ${parkingSpace.pricePerHour} kr'),
              ),
              SizedBox(height: 20),
              Text(
                  'Starttid: ${dateTimeFormat.format(ongoingParking!.startTime)}'),
              Text(
                  'Sluttid: ${dateTimeFormat.format(ongoingParking!.endTime)}'),
              SizedBox(height: 20.0),
              Text('Förfluten tid: ${ongoingParking!.elapsedTimeToString()}',
                  style: TextStyle(fontSize: 20)),
              Text('Kostnad: ${ongoingParking!.elapsedCostToString()}',
                  style: TextStyle(fontSize: 20)),
              Text(
                overdueWarning,
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  widget.onEndParking();
                },
                child: Text('Avsluta parkering'),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
    super.dispose();
  }
}
