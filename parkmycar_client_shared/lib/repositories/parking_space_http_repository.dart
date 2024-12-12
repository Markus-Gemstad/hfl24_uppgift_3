import 'package:parkmycar_shared/parkmycar_shared.dart';
import 'http_repository.dart';

class ParkingSpaceHttpRepository extends HttpRepository<ParkingSpace> {
  // Singleton
  static final ParkingSpaceHttpRepository _instance =
      ParkingSpaceHttpRepository._internal();
  static ParkingSpaceHttpRepository get instance => _instance;
  ParkingSpaceHttpRepository._internal()
      : super(serializer: ParkingSpaceSerializer(), resource: "parkingspaces");
}
