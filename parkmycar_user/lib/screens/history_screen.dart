import 'package:flutter/material.dart';
import 'package:parkmycar_client_repo/parkmycar_http_repo.dart';
import 'package:parkmycar_shared/parkmycar_shared.dart';

import '../globals.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Future<List<Parking>> getAllParkings() async {
    var items = await ParkingHttpRepository.instance
        .getAll((a, b) => b.startTime.compareTo(a.startTime));
    // TODO: Ersätt med bättre relationer mellan parkering och person
    items = items
        .where((element) =>
            !element.isOngoing && element.personId == currentPerson!.id)
        .toList();

    // Added delay to demonstrate loading animation
    return Future.delayed(
        Duration(milliseconds: delayLoadInMilliseconds), () => items);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: FutureBuilder<List<Parking>>(
          future: getAllParkings(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var item = snapshot.data![index];
                  return ListTile(
                      leading: Icon(Icons.local_parking, color: Colors.blue),
                      //title: Text(item.endTime.toString()),
                      subtitle: Text(
                          // TODO: Lägga till adress
                          'Start: ${dateTimeFormat.format(item.startTime)}\n'
                          'Slut: ${dateTimeFormat.format(item.endTime)}\n'
                          'Pris: ${item.totalCost} kr'));
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
    );
  }
}
