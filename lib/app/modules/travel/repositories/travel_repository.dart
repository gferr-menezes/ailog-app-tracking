import '../models/geolocation_model.dart';
import '../models/travel_model.dart';

abstract class TravelRepository {
  Future<Map<String, dynamic>>? checkTravelExistsInAPI(String plate);
  Future<void> sendPositions({required List<GeolocationModel> geolocations, required TravelModel travel});
}
