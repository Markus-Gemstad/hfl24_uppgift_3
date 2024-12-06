import 'package:flutter/material.dart';
import 'package:parkmycar_client_repo/parkmycar_client_stuff.dart';
import 'parking_space_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentScreenIndex = 0;

  final destinations = const <NavigationDestination>[
    NavigationDestination(
      icon: Icon(Icons.directions_car),
      label: 'Platser',
    ),
    NavigationDestination(
      icon: Icon(Icons.local_parking),
      label: 'Parkeringar',
    ),
    NavigationDestination(
      icon: Icon(Icons.query_stats),
      label: 'Statistik',
    ),
    NavigationDestination(
      icon: Icon(Icons.logout),
      label: 'Logga ut',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      ParkingSpaceScreen(),
      Placeholder(),
      Placeholder(),
      LogoutScreen(),
    ];

    return LayoutBuilder(builder: (context, constraints) {
      // Show bottom menu if width less than 600
      if (constraints.maxWidth < 600) {
        return Scaffold(
          bottomNavigationBar: NavigationBar(
              onDestinationSelected: (int index) {
                setState(() {
                  _currentScreenIndex = index;
                });
              },
              selectedIndex: _currentScreenIndex,
              destinations: destinations),
          body: SafeArea(
            child: IndexedStack(
              key: const GlobalObjectKey('IndexedStack'),
              index: _currentScreenIndex,
              children: screens,
            ),
          ),
        );
      } else {
        // Show left menu if width is 600 or more
        return Scaffold(
          body: Row(
            children: [
              NavigationRail(
                  extended: constraints.maxWidth >= 800,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _currentScreenIndex = index;
                    });
                  },
                  destinations: destinations
                      .map(NavigationRailDestinationFactory
                          .fromNavigationDestination)
                      .toList(),
                  selectedIndex: _currentScreenIndex),
              Expanded(
                child: IndexedStack(
                  key: const GlobalObjectKey('IndexedStack'),
                  index: _currentScreenIndex,
                  children: screens,
                ),
              )
            ],
          ),
        );
      }
    });
  }
}

class NavigationRailDestinationFactory {
  static NavigationRailDestination fromNavigationDestination(
    NavigationDestination destination,
  ) {
    return NavigationRailDestination(
      icon: destination.icon,
      selectedIcon: destination.selectedIcon,
      label: Text(destination.label),
    );
  }
}
