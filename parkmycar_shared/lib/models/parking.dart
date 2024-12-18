import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';
import 'package:parkmycar_shared/models/parking_space.dart';
import '../util/validators.dart';
import 'identifiable.dart';
import 'serializer.dart';

@Entity()
class Parking extends Identifiable {
  @override
  @Id()
  // ignore: overridden_fields
  int id; // Gör en override för att det ska funka med ObjectBox

  int personId;
  int vehicleId;
  int parkingSpaceId;
  int pricePerHour;

  @Property(type: PropertyType.date)
  DateTime startTime;

  @Property(type: PropertyType.date)
  DateTime endTime;

  // Can be set when loading parking spaces from the side.
  // Otherwise use the parkingSpaceId.
ParkingSpace? parkingSpace;

  /// Get price per minute
  double get pricePerMinute => pricePerHour / 60;

  /// Get price per second
  double get pricePerSecond => pricePerHour / 3600;

  Duration get totalTime {
    return endTime.difference(startTime);
  }

  /// Get total cost of this parking
  double get totalCost {
    double result = pricePerSecond * totalTime.inSeconds;
    return double.parse(result.toStringAsFixed(2));
  }

  String totalTimeToString([bool short = false]) {
    return timeToString(startTime, endTime, short);
  }

  String elapsedTimeToString([bool short = false]) {
    return timeToString(startTime, DateTime.now(), short);
  }

  static timeToString(DateTime startTime, DateTime endTime,
      [bool short = false]) {
    Duration elapsedTime = endTime.difference(startTime);

    int days = elapsedTime.inDays;
    int hours = elapsedTime.inHours % 24;
    int minutes = elapsedTime.inMinutes % 60;
    int seconds = elapsedTime.inSeconds % 60;

    String elapsedString = '';

    if (days > 0) {
      if (days == 1) {
        elapsedString = (short) ? '${days}d ' : '$days dag ';
      } else {
        elapsedString = (short) ? '${days}d ' : '$days dagar ';
      }
    }
    if (hours > 0) {
      elapsedString += (short) ? '${hours}t ' : '$hours tim ';
    }
    if (minutes > 0) {
      elapsedString += (short) ? '${minutes}m ' : '$minutes min ';
    }
    elapsedString += (short) ? '${seconds}s' : '$seconds sek';

    return elapsedString;
  }

  /// Get elapsed cost of this parking
  String elapsedCostToString() {
    var now = DateTime.now();
    Duration elapsedTime = now.difference(startTime);
    double result = pricePerSecond * elapsedTime.inSeconds;
    return '${result.toStringAsFixed(2)} kr';
  }

  bool get isOngoing {
    var now = DateTime.now();
    return (now.isAfter(startTime) && now.isBefore(endTime));
  }

  bool get isOverdue {
    var now = DateTime.now();
    return (now.isAfter(endTime));
  }

  Parking(this.personId, this.vehicleId, this.parkingSpaceId, this.startTime,
      this.endTime, this.pricePerHour,
      [this.id = -1]);

  @override
  bool isValid() {
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
    return Validators.isValidId(personId.toString()) &&
        Validators.isValidId(vehicleId.toString()) &&
        Validators.isValidId(parkingSpaceId.toString()) &&
        Validators.isValidDateTime(formatter.format(startTime)) &&
        Validators.isValidDateTime(formatter.format(endTime));
  }

  @override
  String toString() {
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
    return 'Id: $id, Starttid: ${formatter.format(startTime)}, Sluttid: ${formatter.format(endTime)}, '
        'Pris per timme: $pricePerHour, FordonsId: $vehicleId, ParkeringsplatsId: $parkingSpaceId, '
        'PersonId: $personId';
  }
}

class ParkingSerializer extends Serializer<Parking> {
  @override
  Map<String, dynamic> toJson(Parking item) {
    return {
      'id': item.id,
      'personId': item.personId,
      'vehicleId': item.vehicleId,
      'parkingSpaceId': item.parkingSpaceId,
      'startTime': item.startTime.toIso8601String(),
      'endTime': item.endTime.toIso8601String(),
      'pricePerHour': item.pricePerHour,
    };
  }

  @override
  Parking fromJson(Map<String, dynamic> json) {
    return Parking(
      json['personId'] as int,
      json['vehicleId'] as int,
      json['parkingSpaceId'] as int,
      DateTime.parse(json['startTime']),
      DateTime.parse(json['endTime']),
      json['pricePerHour'] as int,
      json['id'] as int,
    );
  }
}
