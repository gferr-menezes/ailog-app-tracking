import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../common/rest_client.dart';
import '../models/geolocation_model.dart';
import '../models/travel_model.dart';
import './travel_repository.dart';

class TravelRepositoryImpl implements TravelRepository {
  final RestClient _restClient;

  TravelRepositoryImpl({required RestClient restClient}) : _restClient = restClient;

  @override
  Future<Map<String, dynamic>>? checkTravelExistsInAPI(String plate) async {
    final response = await _restClient.post('/viagem/find', {
      'placa': plate,
    });

    return response.body;
  }

  @override
  Future<void> sendPositions({required List<GeolocationModel> geolocations, required TravelModel travel}) async {
    try {
      var dataSend = jsonEncode({
        'idViagem': travel.travelIdApi,
        'placa': travel.plate,
      });

      var pontos = <dynamic>[];

      for (var geolocation in geolocations) {
        String date = geolocation.collectionDate.toString();
        DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
        String collectionDate = dateFormat.format(DateTime.parse(date));

        pontos.add(
          {
            'dataHoraPosicao': collectionDate,
            'latLng': {
              'latitude': geolocation.latitude,
              'longitude': geolocation.longitude,
            }
          },
        );

        dataSend = jsonEncode({
          'idViagem': travel.travelIdApi,
          'placa': travel.plate,
          'pontos': pontos,
        });
      }

      final Response response = await _restClient.post('/enviarPontos', dataSend);

      log(response.body.toString());

      var result = response.body;
      if (result == null || result['status'] != 'SUCESSO') {
        throw Exception(result == null ? 'error_communication_backend' : result['status']);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
