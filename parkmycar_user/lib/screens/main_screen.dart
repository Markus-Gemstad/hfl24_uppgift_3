import 'package:flutter/material.dart';
import 'package:parkmycar_user/screens/history_screen.dart';
import 'package:parkmycar_user/screens/parking_screen.dart';
import 'package:parkmycar_user/screens/vehicle_screen.dart';

import 'account_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        selectedIndex: _currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.local_parking, color: Colors.blue),
            label: 'Parkera',
          ),
          NavigationDestination(
            icon: Icon(Icons.directions_car_outlined),
            selectedIcon: Icon(Icons.directions_car_filled),
            label: 'Fordon',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'Historik',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Konto',
          ),
          NavigationDestination(
            icon: Icon(Icons.logout),
            label: 'Logga ut',
          ),
        ],
      ),
      body: <Widget>[
        ParkingScreen(),
        VehicleScreen(),
        HistoryScreen(),
        AccountScreen(),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Är du säker på att du vill logga ut?'),
              ),
              ElevatedButton(
                child: const Text('Logga ut'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ][_currentPageIndex],
    );
  }
}
