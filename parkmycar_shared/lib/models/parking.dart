import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';
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

  /// Get price per minute
  double get pricePerMinute => pricePerHour / 60;

  Duration get totalTime {
    return endTime.difference(startTime);
  }

  String elapsedTimeToString() {
    var now = DateTime.now();
    Duration elapsedTime = now.difference(startTime);

    int days = elapsedTime.inDays;
    int hours = elapsedTime.inHours % 24;
    int minutes = elapsedTime.inMinutes % 60;
    int seconds = elapsedTime.inSeconds % 60;

    String elapsedString = '';

    if (days > 0) {
      elapsedString = '$days dagar ';
    }
    if (hours > 0) {
      elapsedString += '$hours tim ';
    }
    if (minutes > 0) {
      elapsedString += '$minutes min ';
    }
    elapsedString += '$seconds sek';

    return elapsedString;
  }

  /// Get elapsed cost of this parking
  String elapsedCostToString() {
    var now = DateTime.now();
    Duration elapsedTime = now.difference(startTime);
    double result = pricePerMinute * elapsedTime.inMinutes;
    return '${result.toStringAsFixed(2)} kr';
  }

  /// Get total cost of this parking
  double get totalCost {
    double result = pricePerMinute * totalTime.inMinutes;
    return double.parse(result.toStringAsFixed(2));
  }

  bool get isOngoing {
    var now = DateTime.now();
    return (now.isAfter(startTime) && now.isBefore(endTime));
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
