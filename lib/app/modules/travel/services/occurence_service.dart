import 'dart:typed_data';

import 'package:ailog_app_tracking/app/modules/travel/models/address_model.dart';
import 'package:ailog_app_tracking/app/modules/travel/models/type_occurence_model.dart';
import 'package:ailog_app_tracking/app/modules/travel/repositories/travel_repository.dart';

import '../models/occurrence_model.dart';
import '../models/travel_model.dart';

class OccurenceService {
  final TravelRepository _travelRepository;

  OccurenceService({required TravelRepository travelRepository}) : _travelRepository = travelRepository;

  Future<List<TypeOccurenceModel>> getTypesOcurrencies({required String travelApiId, AddressModel? address}) async {
    final result = await _travelRepository.getTypesOcurrencies(travelApiId: travelApiId, address: address);
    return result;
  }

  Future<void> saveOccurence({
    required TravelModel travel,
    required OccurrenceModel ocurrence,
    AddressModel? address,
  }) async {
    await _travelRepository.saveOccurrence(travel: travel, ocurrence: ocurrence, address: address);
  }

  Future<String> uploadImagesOccurrence({
    required Uint8List image,
    required String travelIdApi,
    int? idOccurrence,
  }) async {
    final result = await _travelRepository.uploadImagesOccurrence(
      image: image,
      travelIdApi: travelIdApi,
      idOccurrence: idOccurrence,
    );
    return result;
  }

  Future<List<OccurrenceModel>> getOccurrences({required String travelApiId}) async {
    final result = await _travelRepository.getOccurrences(travelApiId: travelApiId);
    return result;
  }
}
