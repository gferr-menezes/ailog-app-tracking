import 'package:ailog_app_tracking/app/modules/travel/repositories/travel_repository_database.dart';

import '../models/geolocation_model.dart';
import '../models/travel_model.dart';
import '../repositories/travel_repository.dart';

class GeolocationService {
  final TravelRepository _travelRepository;
  final TravelRepositoryDatabase _travelRepositoryDatabase;

  GeolocationService(
      {required TravelRepository travelRepository, required TravelRepositoryDatabase travelRepositoryDatabase})
      : _travelRepository = travelRepository,
        _travelRepositoryDatabase = travelRepositoryDatabase;

  Future<void> sendPositions({required List<GeolocationModel> geolocations, required TravelModel travel}) async {
    await _travelRepository.sendPositions(geolocations: geolocations, travel: travel);
  }

  Future<void> saveGeolocations({required List<GeolocationModel> geolocations}) async {
    await _travelRepositoryDatabase.insertGeolocations(geolocations: geolocations);
  }

  Future<List<GeolocationModel>?> getGeolocations({required int travelId}) async {
    return await _travelRepositoryDatabase.getGeolocations(travelId: travelId);
  }

  Future<List<GeolocationModel>?> getGeolocationsPendingsSendAPI() async {
    return await _travelRepositoryDatabase.getGeolocations(statusSendApi: StatusSendApi.pending.name);
  }

  Future<void> updateGeolocations({required List<GeolocationModel> geolocations}) async {
    await _travelRepositoryDatabase.updateGeolocations(geolocations: geolocations);
  }
}
