import 'package:intl/intl.dart';
import 'package:parkmycar_shared/parkmycar_shared.dart';

// bool isLoggedIn = false;
Person? currentPerson;

/// Use for formating date and time
final DateFormat timeOnlyFormat = DateFormat('HH:mm');
final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
final DateFormat dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm');
final DateFormat dateTimeFormatShort = DateFormat('yyMMdd HH:mm');

/// Whether a parking is ongoing.
bool parkingIsOngoing = false;

/// The current ongoing parking (if any)
Parking? ongoingParking;
ParkingSpace? currentParkingSpace;

int delayLoadInMilliseconds = 500;
