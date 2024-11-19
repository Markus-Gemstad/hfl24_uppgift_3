import 'package:parkmycar_shared/parkmycar_shared.dart';
import 'http_repository.dart';

class VehicleHttpRepository extends HttpRepository<Vehicle> {
  // Singleton
  static final VehicleHttpRepository _instance =
      VehicleHttpRepository._internal();
  static VehicleHttpRepository get instance => _instance;
  VehicleHttpRepository._internal()
      : super(serializer: VehicleSerializer(), resource: "vehicles");
}
