import '../models/address_model.dart';
import '../models/geolocation_model.dart';
import '../models/toll_model.dart';
import '../models/travel_model.dart';

abstract class TravelRepositoryDatabase {
  Future<int> insertTravel(TravelModel travel);
  Future<List<TravelModel>?> getTravels({String? plate, String? status, int? id});
  Future<List<AddressModel>?> getAddresses({required int travelId});
  Future<List<TollModel>?> getTolls({required int travelId});
  Future<void> insertGeolocations({required List<GeolocationModel> geolocations});
  Future<List<GeolocationModel>?> getGeolocations({int? travelId, String? statusSendApi});
  Future<void> updateGeolocations({required List<GeolocationModel> geolocations});
  Future<void> updateTravel({required TravelModel travel});
  Future<void> updateToll({required TollModel toll});
  Future<void> registerArrivalClient({required AddressModel address});
  Future<void> registerDepartureClient({required AddressModel address});
}
