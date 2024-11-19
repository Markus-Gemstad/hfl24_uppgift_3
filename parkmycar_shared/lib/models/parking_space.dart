import 'package:objectbox/objectbox.dart';
import '../util/validators.dart';
import 'identifiable.dart';
import 'serializer.dart';

@Entity()
class ParkingSpace extends Identifiable {
  @override
  @Id()
  // ignore: overridden_fields
  int id; // Gör en override för att det ska funka med ObjectBox

  String address;
  int pricePerHour;

  // Getter for price per minute
  double get pricePerMinute => pricePerHour / 60;

  ParkingSpace(this.address, this.pricePerHour, [this.id = -1]);

  @override
  bool isValid() {
    return (Validators.isValidAddress(address) &&
        Validators.isValidPricePerHour(pricePerHour.toString()));
  }

  @override
  String toString() {
    return "Id: $id, Address: $address, Pris per timme: $pricePerHour";
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'pricePerHour': pricePerHour,
    };
  }

  factory ParkingSpace.fromJson(Map<String, dynamic> json) {
    return ParkingSpace(
      json['address'] as String,
      json['pricePerHour'] as int,
      json['id'] as int,
    );
  }
}

class ParkingSpaceSerializer extends Serializer<ParkingSpace> {
  @override
  Map<String, dynamic> toJson(ParkingSpace item) {
    return {
      'id': item.id,
      'address': item.address,
      'pricePerHour': item.pricePerHour,
    };
  }

  @override
  ParkingSpace fromJson(Map<String, dynamic> json) {
    return ParkingSpace(
      json['address'] as String,
      json['pricePerHour'] as int,
      json['id'] as int,
    );
  }
}
