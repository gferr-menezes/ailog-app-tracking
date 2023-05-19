import 'package:ailog_app_tracking/app/modules/travel/models/toll_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/ui/widgets/custom_snackbar.dart';
import '../models/address_model.dart';
import '../models/travel_model.dart';
import '../services/travel_service.dart';

class TravelController extends GetxController {
  final TravelService _travelService;

  TravelController({required TravelService travelService}) : _travelService = travelService;

  final _loadingCheckTravelInitialized = false.obs;
  final _existTravelInitialized = false.obs;
  final _loadingStartingTravel = false.obs;
  final _loadingGetAddresses = false.obs;
  final _loadingGetTolls = false.obs;

  final _travel = TravelModel().obs;
  final _addresses = <AddressModel>[].obs;
  final _tolls = <TollModel>[].obs;

  void checkTravelInitialized() async {
    try {
      loadingCheckTravelInitialized = true;
      final travels = await _travelService.getTravels(status: StatusTravel.inProgress.name);
      if (travels != null && travels.isNotEmpty) {
        existTravelInitialized = true;
        travel = travels.first;
      }
    } finally {
      hideLoading();
    }
  }

  // process to start travel
  Future<void> startTravel(String plate) async {
    try {
      loadingStartingTravel = true;

      final travels = await _travelService.startTravel(plate);

      if (travels != null && travels.isNotEmpty) {
        for (var travel in travels) {
          await _travelService.saveTravel(travel);
        }
      }

      CustomSnackbar.show(
        Get.context!,
        message: 'Viagem iniciada com sucesso',
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      Future.delayed(const Duration(milliseconds: 200)).then((value) {
        existTravelInitialized = true;
      });

      hideLoading();
    } catch (e) {
      String message = e.toString().substring(11).replaceAll(')', '');
      if (message == 'Viagem não localizada') {
        message = 'Viagem não localizada para a placa informada';
      } else {
        message = 'Erro ao iniciar viagem';
      }
      CustomSnackbar.show(
        Get.context!,
        message: message,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );

      hideLoading();
    }
  }

  Future<void> getAddresses({required int travelId}) async {
    try {
      loadingGetAddresses = true;
      final addressesData = await _travelService.getAddresses(travelId: travelId);
      if (addressesData != null && addressesData.isNotEmpty) {
        addresses = addressesData;
      }
    } catch (e) {
      CustomSnackbar.show(
        Get.context!,
        message: 'Erro ao buscar endereços da viagem',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      hideLoading();
    }
  }

  // tolls
  Future<void> getTolls({required int travelId}) async {
    try {
      loadingGetTolls = true;
      final tollsData = await _travelService.getTolls(travelId: travelId);
      if (tollsData != null && tollsData.isNotEmpty) {
        tolls = tollsData;
      }
    } catch (e) {
      CustomSnackbar.show(
        Get.context!,
        message: 'Erro ao buscar pedágios da viagem',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      hideLoading();
    }
  }

  void hideLoading() {
    Future.delayed(const Duration(milliseconds: 200)).then((value) {
      loadingStartingTravel = false;
      loadingCheckTravelInitialized = false;
      loadingGetAddresses = false;
      loadingGetTolls = false;
    });
  }

  // Getters and Setters
  bool get loadingCheckTravelInitialized => _loadingCheckTravelInitialized.value;
  set loadingCheckTravelInitialized(bool value) {
    _loadingCheckTravelInitialized.value = value;
  }

  bool get existTravelInitialized => _existTravelInitialized.value;
  set existTravelInitialized(bool value) {
    _existTravelInitialized.value = value;
  }

  bool get loadingStartingTravel => _loadingStartingTravel.value;
  set loadingStartingTravel(bool value) {
    _loadingStartingTravel.value = value;
  }

  bool get loadingGetAddresses => _loadingGetAddresses.value;
  set loadingGetAddresses(bool value) {
    _loadingGetAddresses.value = value;
  }

  bool get loadingGetTolls => _loadingGetTolls.value;
  set loadingGetTolls(bool value) {
    _loadingGetTolls.value = value;
  }

  TravelModel get travel => _travel.value;
  set travel(TravelModel value) {
    _travel.value = value;
  }

  List<AddressModel> get addresses => _addresses;
  set addresses(List<AddressModel> value) {
    _addresses.value = value;
  }

  List<TollModel> get tolls => _tolls;
  set tolls(List<TollModel> value) {
    _tolls.value = value;
  }
}
