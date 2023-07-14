import 'dart:typed_data';

import 'package:ailog_app_tracking/app/modules/travel/models/address_model.dart';
import 'package:ailog_app_tracking/app/modules/travel/services/occurence_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/ui/widgets/custom_snackbar.dart';
import '../models/occurence_vehicle_model.dart';
import '../models/occurrence_model.dart';
import '../models/travel_model.dart';
import '../models/type_occurence_model.dart';

class OcurrenceController extends GetxController {
  final OccurenceService _occurenceService;

  OcurrenceController({required OccurenceService occurenceService}) : _occurenceService = occurenceService;

  final _loadingSavingOccurrence = false.obs;
  final _loadingOccurrences = false.obs;
  final _occurrences = <OccurrenceModel>[].obs;
  final _loadingOccurrencesVehicle = false.obs;
  final _occurrencesVehicle = <OccurenceVehicleModel>[].obs;

  Future<List<TypeOccurenceModel>> getTypesOcurrencies({required String travelApiId, AddressModel? address}) async {
    final result = await _occurenceService.getTypesOcurrencies(travelApiId: travelApiId, address: address);
    return result;
  }

  Future<void> saveOccurrence(
      {required TravelModel travel, required OccurrenceModel ocurrence, AddressModel? address}) async {
    try {
      await _occurenceService.saveOccurence(travel: travel, ocurrence: ocurrence, address: address);
      CustomSnackbar.show(
        Get.context!,
        message: 'Ocorrência salva com sucesso.',
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      CustomSnackbar.show(
        Get.context!,
        message: 'Erro ao salvar ocorrência.',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      throw Exception(e);
    } finally {
      loadingSavingOccurrence = false;
    }
  }

  Future<String> uploadImagesOccurrence({
    required Uint8List image,
    required String travelIdApi,
    int? idOccurrence,
  }) async {
    final result = await _occurenceService.uploadImagesOccurrence(
      image: image,
      travelIdApi: travelIdApi,
      idOccurrence: idOccurrence,
    );
    return result;
  }

  Future<List<OccurrenceModel>> getOccurrences({required String travelApiId}) async {
    try {
      loadingOccurrences = true;
      occurrences = await _occurenceService.getOccurrences(travelApiId: travelApiId);
      return occurrences;
    } catch (e) {
      CustomSnackbar.show(
        Get.context!,
        message: 'Erro ao buscar ocorrências.',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      throw Exception(e);
    } finally {
      loadingOccurrences = false;
    }
  }

  Future<void> saveOccurrenceVehicle({required TravelModel travel, required OccurenceVehicleModel ocurrence}) async {
    try {
      await _occurenceService.saveOccurrenceVehicle(travel: travel, occurrence: ocurrence);
      CustomSnackbar.show(
        Get.context!,
        message: 'Ocorrência salva com sucesso.',
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      CustomSnackbar.show(
        Get.context!,
        message: 'Erro ao salvar ocorrência.',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      throw Exception(e);
    } finally {
      loadingSavingOccurrence = false;
    }
  }

  Future<List<OccurenceVehicleModel>> getVehicleOccurrences({required String travelApiId}) async {
    try {
      loadingOccurrencesVehicle = true;
      final result = await _occurenceService.getVehicleOccurrences(travelApiId: travelApiId);
      occurrencesVehicle = result;
      return result;
    } catch (e) {
      CustomSnackbar.show(
        Get.context!,
        message: 'Erro ao buscar ocorrências.',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      throw Exception(e);
    } finally {
      loadingOccurrencesVehicle = false;
    }
  }

  // getters and setters
  bool get loadingSavingOccurrence => _loadingSavingOccurrence.value;
  set loadingSavingOccurrence(bool value) => _loadingSavingOccurrence.value = value;

  bool get loadingOccurrences => _loadingOccurrences.value;
  set loadingOccurrences(bool value) => _loadingOccurrences.value = value;

  bool get loadingOccurrencesVehicle => _loadingOccurrencesVehicle.value;
  set loadingOccurrencesVehicle(bool value) => _loadingOccurrencesVehicle.value = value;

  List<OccurrenceModel> get occurrences => _occurrences;
  set occurrences(List<OccurrenceModel> value) => _occurrences.value = value;

  List<OccurenceVehicleModel> get occurrencesVehicle => _occurrencesVehicle;
  set occurrencesVehicle(List<OccurenceVehicleModel> value) => _occurrencesVehicle.value = value;
}
