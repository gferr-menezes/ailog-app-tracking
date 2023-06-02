import 'package:ailog_app_tracking/app/modules/travel/models/geolocation_model.dart';
import 'package:ailog_app_tracking/app/modules/travel/models/travel_model.dart';
import 'package:ailog_app_tracking/app/modules/travel/services/geolocation_service.dart';
import 'package:ailog_app_tracking/app/modules/travel/services/travel_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../common/permission_controller.dart';
import '../../../common/ui/widgets/custom_snackbar.dart';

class GeolocationController extends GetxController {
  final TravelService _travelService;
  final GeolocationService _geolocationService;

  final _loadingGeolocations = false.obs;
  final _geolocations = <GeolocationModel>[].obs;

  GeolocationController({required TravelService travelService, required GeolocationService geolocationService})
      : _travelService = travelService,
        _geolocationService = geolocationService;

  Future<void> collectLatitudeLongitude(Position position) async {
    final List<TravelModel>? travels;
    final List<GeolocationModel> geolocations = [];

    final permission = await PermissionController.checkGeolocationPermission();

    print('#################permission: $permission');
    if (permission.isDenied) {
      return;
    }
    travels = await _travelService.getTravels(status: StatusTravel.inProgress.name);
    if (travels == null || travels.isEmpty) {
      return;
    }

    //final position = await Geolocation.getCurrentPosition();
    print(position.toString());
    if (position == null) {
      return;
    }

    final collectionDate = DateTime.now();

    geolocations.add(
      GeolocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
        collectionDate: collectionDate,
        statusSendApi: StatusSendApi.pending.name,
        travelId: travels.first.id,
      ),
    );

    try {
      await _geolocationService.sendPositions(geolocations: geolocations, travel: travels.first);
      // success send api
      for (var geolocation in geolocations) {
        geolocation.statusSendApi = StatusSendApi.sended.name;
        geolocation.dateSendApi = collectionDate;
      }
      await _geolocationService.saveGeolocations(geolocations: geolocations);
      print('################# success send api');
    } catch (e) {
      print('################# error: $e');
      // error send api
      await _geolocationService.saveGeolocations(geolocations: geolocations);
    }
  }

  Future<void> getGelocations({required int travelId, bool showLoading = true}) async {
    try {
      loadingGeolocations = showLoading;
      final geolocationsData = await _geolocationService.getGeolocations(travelId: travelId);
      if (geolocationsData != null) {
        geolocations = geolocationsData;
      }
    } catch (e) {
      CustomSnackbar.show(
        Get.context!,
        message: 'Erro ao buscar latitudes e longitudes',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      hideLoading();
    }
  }

  Future<void> sendGeolocationsPending() async {
    final gelocationsPending = await _geolocationService.getGeolocationsPendingsSendAPI();

    if (gelocationsPending != null && gelocationsPending.isNotEmpty) {
      /** filter unique travelId */
      final travelIds = gelocationsPending.map((e) => e.travelId).toSet().toList();
      final List<TravelModel> travels = [];

      for (var travelId in travelIds) {
        final travel = await _travelService.getTravels(id: travelId);
        if (travel != null) {
          travels.add(travel.first);
        }
      }

      for (var travel in travels) {
        await _geolocationService.sendPositions(geolocations: gelocationsPending, travel: travel);
        // success send api
        for (var geolocation in gelocationsPending) {
          geolocation.statusSendApi = StatusSendApi.sended.name;
          geolocation.dateSendApi = DateTime.now();
        }
        await _geolocationService.updateGeolocations(geolocations: gelocationsPending);
      }
    }
  }

  void hideLoading() {
    Future.delayed(const Duration(milliseconds: 200)).then((value) {
      loadingGeolocations = false;
    });
  }

  // getters and setters
  bool get loadingGeolocations => _loadingGeolocations.value;
  set loadingGeolocations(bool value) => _loadingGeolocations.value = value;

  List<GeolocationModel> get geolocations => _geolocations;
  set geolocations(List<GeolocationModel> value) => _geolocations.value = value;
}
