import 'package:flutter/material.dart';

class ParkingScreen extends StatefulWidget {
  const ParkingScreen({super.key});

  @override
  State<ParkingScreen> createState() => _ParkingScreenState();
}

class ParkingPlace {
  int id;
  String streetAddress;
  String postalCode;
  String city;

  ParkingPlace(this.id, this.streetAddress, this.postalCode, this.city);
}

class _ParkingScreenState extends State<ParkingScreen> {
  late List<ParkingPlace> allItems;
  late List<ParkingPlace> items;

  late TextEditingController _searchController;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    allItems = createLotsOfAddresses();
    items = allItems.toList();

    _searchController = TextEditingController();
    _searchController.addListener(_queryListener);
    _controller = TextEditingController();
  }

  void _queryListener() {
    _search(_searchController.text);
  }

  @override
  void dispose() {
    _searchController.removeListener(_queryListener);
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _search(String query) {
    if (query.isEmpty) {
      setState(() {
        items = allItems;
      });
    } else {
      setState(() {
        items = allItems
            .where((e) =>
                e.streetAddress.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          SearchBar(
            leading: const Icon(Icons.search),
            // trailing: <Widget>[
            //   const Icon(Icons.close),
            //   SizedBox(
            //     width: 6.0,
            //   ),
            // ],
            hintText: 'Sök gata...',
            controller: _searchController,
            autoFocus: true,
          ),
          SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    onTap: onSelectedParkingPlace,
                    leading: Icon(Icons.local_parking),
                    iconColor: Colors.blue,
                    title: Text(item.streetAddress),
                    subtitle: Text('${item.postalCode} ${item.city}'),
                  );
                }),
          ),
        ],
      ),
    );
  }

  void onSelectedParkingPlace() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog.fullscreen(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Starta parkering'),
            centerTitle: false,
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Spara'),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.arrow_drop_down)),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<ParkingPlace> createLotsOfAddresses() {
    return [
      ParkingPlace(1, 'Nya Stadens Torg 1', '531 31', 'Lidköping'),
      ParkingPlace(2, 'Gamla Stadens Torg 4', '531 32', 'Lidköping'),
      ParkingPlace(3, 'Esplanaden 6', '531 33', 'Lidköping'),
      ParkingPlace(4, 'Rådagatan 10', '531 35', 'Lidköping'),
      ParkingPlace(5, 'Östbygatan 18', '531 37', 'Lidköping'),
      ParkingPlace(6, 'Stenportsgatan 9', '531 40', 'Lidköping'),
      ParkingPlace(7, 'Kållandsgatan 22', '531 44', 'Lidköping'),
      ParkingPlace(8, 'Skaragatan 5', '531 30', 'Lidköping'),
      ParkingPlace(9, 'Sockerbruksgatan 15', '531 40', 'Lidköping'),
      ParkingPlace(10, 'Mariestadsvägen 2', '531 60', 'Lidköping'),
      ParkingPlace(11, 'Torggatan 3', '531 31', 'Lidköping'),
      ParkingPlace(12, 'Hamngatan 12', '531 32', 'Lidköping'),
      ParkingPlace(13, 'Västra Hamngatan 5', '531 33', 'Lidköping'),
      ParkingPlace(14, 'Framnäsvägen 1', '531 36', 'Lidköping'),
      ParkingPlace(15, 'Götgatan 7', '531 31', 'Lidköping'),
      ParkingPlace(16, 'Östra Hamnen 10', '531 32', 'Lidköping'),
      ParkingPlace(17, 'Viktoriagatan 14', '531 30', 'Lidköping'),
      ParkingPlace(18, 'Majorsallén 3', '531 40', 'Lidköping'),
      ParkingPlace(19, 'Hovbygatan 20', '531 41', 'Lidköping'),
      ParkingPlace(20, 'Kvarngatan 9', '531 42', 'Lidköping'),
      ParkingPlace(21, 'Skogvaktaregatan 11', '531 43', 'Lidköping'),
      ParkingPlace(22, 'Överbyvägen 15', '531 44', 'Lidköping'),
      ParkingPlace(23, 'Industrigatan 8', '531 40', 'Lidköping'),
      ParkingPlace(24, 'Norrgatan 2', '531 34', 'Lidköping'),
      ParkingPlace(25, 'Smedjegatan 18', '531 30', 'Lidköping'),
      ParkingPlace(26, 'Skaraborgsvägen 19', '531 34', 'Lidköping'),
      ParkingPlace(27, 'Fabriksgatan 5', '531 35', 'Lidköping'),
      ParkingPlace(28, 'Långgatan 3', '531 31', 'Lidköping'),
      ParkingPlace(29, 'Mellbygatan 14', '531 37', 'Lidköping'),
      ParkingPlace(30, 'Trädgårdsgatan 9', '531 33', 'Lidköping'),
      ParkingPlace(31, 'Vassgatan 6', '531 36', 'Lidköping'),
      ParkingPlace(32, 'Vänersborgsvägen 11', '531 39', 'Lidköping'),
      ParkingPlace(33, 'Bryggaregatan 22', '531 40', 'Lidköping'),
      ParkingPlace(34, 'Dalängsvägen 7', '531 31', 'Lidköping'),
      ParkingPlace(35, 'Djurgårdsgatan 13', '531 34', 'Lidköping'),
      ParkingPlace(36, 'Gustav Adolfs gata 16', '531 32', 'Lidköping'),
      ParkingPlace(37, 'Tegelbruksgatan 4', '531 37', 'Lidköping'),
      ParkingPlace(38, 'Torsgatan 12', '531 35', 'Lidköping'),
      ParkingPlace(39, 'Kungsgatan 5', '531 30', 'Lidköping'),
      ParkingPlace(40, 'Västra Torget 8', '531 31', 'Lidköping'),
      ParkingPlace(41, 'Lilla Torget 7', '531 30', 'Lidköping'),
      ParkingPlace(42, 'Östra Hamngatan 18', '531 32', 'Lidköping'),
      ParkingPlace(43, 'Havsbadsvägen 21', '531 36', 'Lidköping'),
      ParkingPlace(44, 'Sandgatan 11', '531 33', 'Lidköping'),
      ParkingPlace(45, 'Korsgatan 5', '531 40', 'Lidköping'),
      ParkingPlace(46, 'Norra Hamnen 4', '531 38', 'Lidköping'),
      ParkingPlace(47, 'Lassagatan 2', '531 32', 'Lidköping'),
      ParkingPlace(48, 'Ågårdsvägen 9', '531 41', 'Lidköping'),
      ParkingPlace(49, 'Ulricehamnsvägen 11', '531 42', 'Lidköping'),
      ParkingPlace(50, 'Rådhusgatan 3', '531 31', 'Lidköping'),
    ];
  }
}
