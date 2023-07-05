import 'dart:typed_data';

import 'package:ailog_app_tracking/app/modules/travel/models/address_model.dart';
import 'package:ailog_app_tracking/app/modules/travel/models/occurrence_model.dart';

import '../models/geolocation_model.dart';
import '../models/travel_model.dart';
import '../models/type_occurence_model.dart';

abstract class TravelRepository {
  Future<Map<String, dynamic>>? checkTravelExistsInAPI(String plate);
  Future<void> sendPositions({required List<GeolocationModel> geolocations, required TravelModel travel});
  Future<void> informValuePay({
    required String travelApiId,
    required int passOrder,
    required int ailogId,
    required double valuePay,
  });
  Future<List<TypeOccurenceModel>> getTypesOcurrencies({required String travelApiId, AddressModel? address});
  Future<void> saveOccurrence({required TravelModel travel, required OccurrenceModel ocurrence, AddressModel? address});
  Future<String> uploadImagesOccurrence({
    required Uint8List image,
    required String travelIdApi,
    int? idOccurrence,
  });
  Future<List<OccurrenceModel>> getOccurrences({required String travelApiId});
  Future<void> sendRegisterArrivalClient({required TravelModel travel, required AddressModel address});
  Future<void> sendRegisterDepartureClient({required TravelModel travel, required AddressModel address});
}
