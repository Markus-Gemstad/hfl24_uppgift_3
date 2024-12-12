import 'package:flutter/material.dart';
import 'package:parkmycar_client_shared/parkmycar_client_stuff.dart';
import 'package:parkmycar_client_shared/parkmycar_http_repo.dart';
import 'package:parkmycar_shared/parkmycar_shared.dart';
import 'package:provider/provider.dart';

import '../globals.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<Parking>> allParkings;

  Future<List<Parking>> getAllParkings(BuildContext context) async {
    var items = await ParkingHttpRepository.instance
        .getAll((a, b) => b.startTime.compareTo(a.startTime));

    if (context.mounted) {
      // ignore: use_build_context_synchronously
      Person? currentPerson = context.read<AuthService>().currentPerson;

      // TODO Ersätt med bättre relationer mellan Parking och Person
      items = items
          .where((element) =>
              !element.isOngoing && element.personId == currentPerson!.id)
          .toList();

      List<Parking> removeItems = List.empty(growable: true);

      for (var item in items) {
        // TODO Ersätt med bättre relationer mellan Parking och ParkingSpace
        try {
          item.parkingSpace = await ParkingSpaceHttpRepository.instance
              .getById(item.parkingSpaceId);
        } catch (e) {
          debugPrint('Error getting ParkingSpace:${item.parkingSpaceId}');
          removeItems.add(item);
        }
      }

      // Remove any items where a ParkingSpace was not found.
      // Ugly handling of error with relations...
      for (var item in removeItems) {
        items.remove(item);
      }
    }

    // Added delay to demonstrate loading animation
    return Future.delayed(
        Duration(milliseconds: delayLoadInMilliseconds), () => items);
  }

  @override
  void initState() {
    super.initState();

    allParkings = getAllParkings(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Parking>>(
        future: allParkings,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return SizedBox.expand(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text('Finns ingen historik.'),
                      SizedBox(height: 10),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              allParkings = getAllParkings(context);
                            });
                          },
                          child: Text('Uppdatera'))
                    ],
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  allParkings = getAllParkings(context);
                });
              },
              child: ListView.builder(
                padding: EdgeInsets.all(12),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var item = snapshot.data![index];
                  return ListTile(
                      leading: Icon(Icons.local_parking, color: Colors.blue),
                      subtitle: Text('${item.parkingSpace!.streetAddress}, '
                          '${item.parkingSpace!.postalCode} ${item.parkingSpace!.city}\n'
                          'Tid: ${dateTimeFormatShort.format(item.startTime)} - '
                          '${dateTimeFormatShort.format(item.endTime)}\n'
                          'Pris: ${item.totalCost} kr (${item.totalTimeToString(true)})'));
                },
              ),
            );
          }
          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Error: ${snapshot.error}'),
            );
          }

          return Center(child: CircularProgressIndicator());
        });
  }
}
