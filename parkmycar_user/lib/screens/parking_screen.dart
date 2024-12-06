import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
    var items = await ParkingSpaceHttpRepository.instance.getAll();
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

  void startParking(Parking parking) async {
    try {
      ongoingParking = await ParkingHttpRepository.instance.create(parking);
      debugPrint('Parking created: $parking');

      // Use to avoid use_build_context_synchronously warning
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
      parkingIsOngoing = true;
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
      parkingIsOngoing = false;
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
    timeDilation = 2.0;
    return (parkingIsOngoing && ongoingParking != null)
        ? ParkingOngoingScreen(
            onEndParking: onEndParking,
          )
        : Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                SearchBar(
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
                SizedBox(height: 20.0),
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

                          return ListView.builder(
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
                                      startParking(parking);
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
                              });
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
            ),
          );
  }
}
