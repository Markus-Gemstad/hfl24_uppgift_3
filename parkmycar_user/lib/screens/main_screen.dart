import 'package:flutter/material.dart';
import 'package:parkmycar_client_repo/parkmycar_client_stuff.dart';

import 'history_screen.dart';
import 'parking_screen.dart';
import 'vehicle_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen> {
  int _currentScreenIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      ParkingScreen(),
      VehicleScreen(),
      HistoryScreen(),
      AccountScreen(),
      LogoutScreen(),
    ];

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _currentScreenIndex = index;
          });
        },
        selectedIndex: _currentScreenIndex,
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
      body: SafeArea(
        // child: screens[_currentScreenIndex],
        child: IndexedStack(
          key: const GlobalObjectKey('IndexedStack'),
          index: _currentScreenIndex,
          children: screens,
        ),
      ),
    );
  }
}
