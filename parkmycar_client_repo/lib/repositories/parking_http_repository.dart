import 'http_repository.dart';
import 'package:parkmycar_shared/parkmycar_shared.dart';

class ParkingHttpRepository extends HttpRepository<Parking> {
  // Singleton
  static final ParkingHttpRepository _instance =
      ParkingHttpRepository._internal();
  static ParkingHttpRepository get instance => _instance;
  ParkingHttpRepository._internal()
      : super(serializer: ParkingSerializer(), resource: "parkings");
}
