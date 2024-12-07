import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:parkmycar_client_repo/parkmycar_client_stuff.dart';
import 'package:parkmycar_client_repo/parkmycar_http_repo.dart';
import 'package:parkmycar_shared/parkmycar_shared.dart';

import '../globals.dart';
import 'parking_ongoing_screen.dart';
import 'parking_start_dialog.dart';

class ParkingScreen extends StatefulWidget {
  const ParkingScreen({super.key});

  @override
  State<ParkingScreen> createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  late TextEditingController _searchController;
  late Future<List<ParkingSpace>> allItems;

  @override
  void initState() {
    super.initState();

    allItems = getParkingSpaces();

    _searchController = TextEditingController();
    _searchController.addListener(_queryListener);
  }

  void _queryListener() {
    _search(_searchController.text);
  }

  Future<List<ParkingSpace>> getParkingSpaces([String? query]) async {
    var items = await ParkingSpaceHttpRepository.instance
        .getAll((a, b) => a.streetAddress.compareTo(b.streetAddress));
    if (query != null) {
      items = items
          .where((e) =>
              e.streetAddress.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    // Added delay to demonstrate loading animation
    return Future.delayed(
        Duration(milliseconds: delayLoadInMilliseconds), () => items);
  }

  void _search(String query) {
    setState(() {
      allItems = getParkingSpaces(query);
    });
  }

  Future<void> startParking(Parking parking) async {
    try {
      ongoingParking = await ParkingHttpRepository.instance.create(parking);

      // Make sure the ongoingParking has the parkingSpace loaded
      // (since it is not loaded on the db but recieved on the parking param,
      // see ParkingStartDialog start parking button onPressed method)
      ongoingParking!.parkingSpace = parking.parkingSpace;
      // ongoingParking!.parkingSpace = await ParkingSpaceHttpRepository.instance
      //     .getById(ongoingParking!.parkingSpaceId);
      debugPrint('Parking created: $parking');

      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('En parkering har startats!')));
    } catch (e) {
      debugPrint('Error when creating Parking: $parking, Error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Det gick inte att starta en parkering!')));
    }

    setState(() {
      isOngoingParking = true;
    });
  }

  void onEndParking() async {
    try {
      ongoingParking!.endTime = DateTime.now();
      await ParkingHttpRepository.instance.update(ongoingParking!);

      debugPrint('Parking stopped: $ongoingParking');

      // Use to avoid use_build_context_synchronously warning
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('En parkering har avslutats!')));

      ongoingParking = null;
    } catch (e) {
      debugPrint('Error when creating Parking: $ongoingParking, Error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Det gick inte att avsluta en parkering!')));
    }

    setState(() {
      isOngoingParking = false;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_queryListener);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 2.0; // Make the animations go slower
    debugPrint(
        'ParkingScreen build() parkingIsOngoing: $isOngoingParking, ongoingParking: $ongoingParking');
    return (isOngoingParking && ongoingParking != null)
        ? ParkingOngoingScreen(
            onEndParking: onEndParking,
          )
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SearchBar(
                  leading: const Icon(Icons.search),
                  // trailing: <Widget>[ // Use for clearing search
                  //   const Icon(Icons.close),
                  //   SizedBox(
                  //     width: 6.0,
                  //   ),
                  // ],
                  hintText: 'Sök gata...',
                  controller: _searchController,
                ),
              ),
              Expanded(
                child: FutureBuilder<List<ParkingSpace>>(
                    future: allItems,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.isEmpty) {
                          return SizedBox.expand(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text('Finns inga parkeringsplatser.'),
                            ),
                          );
                        }

                        return RefreshIndicator(
                          onRefresh: () async {
                            setState(() {
                              allItems = getParkingSpaces();
                            });
                          },
                          child: ListView.builder(
                              padding: const EdgeInsets.all(12.0),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                var parkingSpace = snapshot.data![index];
                                return ListTile(
                                  onTap: () async {
                                    // Use push instead of showDialog to only to
                                    // make hero animation work.
                                    Parking? parking =
                                        await Navigator.of(context)
                                            .push<Parking>(MaterialPageRoute(
                                                builder: (context) =>
                                                    ParkingStartDialog(
                                                        parkingSpace)));

                                    // Parking? parking =
                                    //     await showDialog<Parking>(
                                    //   context: context,
                                    //   builder: (context) =>
                                    //       ParkingStartDialog(item),
                                    // );

                                    debugPrint(parking.toString());
                                    if (parking != null &&
                                        parking.isValid() &&
                                        context.mounted) {
                                      await startParking(parking);
                                    }
                                  },
                                  leading: Hero(
                                      tag: 'parkingicon${parkingSpace.id}',
                                      transitionOnUserGestures: true,
                                      child: Image.asset(
                                        'assets/parking_icon.png',
                                        width: 30.0,
                                      )),
                                  title: Text(parkingSpace.streetAddress),
                                  subtitle: Text(
                                      '${parkingSpace.postalCode} ${parkingSpace.city}\n'
                                      'Pris per timme: ${parkingSpace.pricePerHour} kr'),
                                );
                              }),
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
              ),
            ],
          );
  }
}
