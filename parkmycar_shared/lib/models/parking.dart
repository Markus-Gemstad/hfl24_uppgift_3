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

  int vehicleId;
  int parkingSpaceId;

  @Property(type: PropertyType.date)
  DateTime startTime;

  @Property(type: PropertyType.date)
  DateTime endTime;

  Parking(this.vehicleId, this.parkingSpaceId, this.startTime, this.endTime,
      [this.id = -1]);

  @override
  bool isValid() {
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
    return Validators.isValidId(vehicleId.toString()) &&
        Validators.isValidId(parkingSpaceId.toString()) &&
        Validators.isValidDateTime(formatter.format(startTime)) &&
        Validators.isValidDateTime(formatter.format(endTime));
  }

  @override
  String toString() {
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
    return 'Id: $id, Starttid: ${formatter.format(startTime)}, Sluttid: ${formatter.format(endTime)}, '
        'FordonsId: $vehicleId, ParkeringsplatsId: $parkingSpaceId';
  }
}

class ParkingSerializer extends Serializer<Parking> {
  @override
  Map<String, dynamic> toJson(Parking item) {
    return {
      'id': item.id,
      'vehicleId': item.vehicleId,
      'parkingSpaceId': item.parkingSpaceId,
      'startTime': item.startTime.toIso8601String(),
      'endTime': item.endTime.toIso8601String(),
    };
  }

  @override
  Parking fromJson(Map<String, dynamic> json) {
    return Parking(
      json['vehicleId'] as int,
      json['parkingSpaceId'] as int,
      DateTime.parse(json['startTime']),
      DateTime.parse(json['endTime']),
      json['id'] as int,
    );
  }
}
