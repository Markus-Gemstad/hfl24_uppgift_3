import 'package:intl/intl.dart';
import 'package:parkmycar_shared/parkmycar_shared.dart';

bool isLoggedIn = false;
Person? currentPerson;

/// Use for formating date and time
final DateFormat dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm');

/// Whether a parking is ongoing.
bool parkingIsOngoing = false;

/// The current ongoing parking (if any)
Parking? ongoingParking;
ParkingSpace? currentParkingSpace;

int delayLoadInMilliseconds = 500;
