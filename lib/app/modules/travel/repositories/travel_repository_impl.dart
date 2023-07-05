import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:ailog_app_tracking/app/modules/travel/models/address_model.dart';
import 'package:ailog_app_tracking/app/modules/travel/models/client_model.dart';
import 'package:ailog_app_tracking/app/modules/travel/models/occurrence_model.dart';
import 'package:ailog_app_tracking/app/modules/travel/models/type_occurence_model.dart';
import 'package:dio/dio.dart';
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
    final response = await _restClient.post('/tracking/viagem/find', {
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

      final response = await _restClient.post('/tracking/enviarPontos', dataSend);

      print("#################response.body: ${response.body}");

      //log(response.body.toString());

      var result = response.body;
      if (result == null || result['status'] != 'SUCESSO') {
        throw Exception(result == null ? 'error_communication_backend' : result['status']);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> informValuePay({
    required String travelApiId,
    required int passOrder,
    required int ailogId,
    required double valuePay,
  }) async {
    try {
      var dataSend = jsonEncode({
        'idViagem': travelApiId,
        'ordemPassagem': passOrder,
        'idPedagio': ailogId,
        'valorPago': valuePay,
      });

      final response = await _restClient.post('/tracking/viagem/pedagio/informarValorPago', dataSend);

      print("#################response.body: ${response.body}");

      var result = response.body;
      if (result == null || result['status'] != 'SUCESSO') {
        throw Exception(result == null ? 'error_communication_backend' : result['status']);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<TypeOccurenceModel>> getTypesOcurrencies({required String travelApiId, AddressModel? address}) async {
    // convert date to dd/MM/yyyy HH:mm
    final dateArrival = address?.estimatedArrival;
    final dateDeparture = address?.estimatedDeparture;
    final dateArrivalReal = address?.realArrival;
    final dateDepartureReal = address?.realDeparture;

    final DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
    final String? estimatedArrival = dateArrival != null ? dateFormat.format(dateArrival) : null;
    final String? estimatedDeparture = dateDeparture != null ? dateFormat.format(dateDeparture) : null;
    final String? realArrival = dateArrivalReal != null ? dateFormat.format(dateArrivalReal) : null;
    final String? realDeparture = dateDepartureReal != null ? dateFormat.format(dateDepartureReal) : null;

    final passagePoint = {
      'ordemPassagem': address?.passOrder,
      'tipoOperacao': address?.typeOperation,
      'cliente': {
        'nome': address?.client?.name,
        'celular': address?.client?.phone,
        'fone': address?.client?.phone,
        'documento': {
          'tipo': address?.client?.typeDocument,
          'numero': address?.client?.documentNumber,
          'numeroSemMascara': address?.client?.documentNumberWithoutMask,
          'nome': address?.client?.name,
        }
      },
      'endereco': {
        'cidade': {'pais': 'brasil', 'uf': address?.state, 'cidade': address?.city},
        'logradouro': address?.address,
        'numero': address?.number,
        'complemento': address?.complement,
        'bairro': address?.neighborhood,
        'estado': address?.state,
        'cep': address?.zipCode,
        'latLng': {
          'latitude': address?.latitude,
          'longitude': address?.longitude,
        },
      },
      'dataHoraPrevisaoChegada': estimatedArrival,
      'dataHoraPrevisaoSaida': estimatedDeparture,
      'dataHoraChegadaReal': realArrival,
      'dataHoraSaidaReal': realDeparture,
    };

    final response = await _restClient.post('/tracking/viagem/tipoOcorrencia/findAll', {
      'idViagem': travelApiId,
      'pontoPassagem': passagePoint,
    });

    final result = response.body;

    if (result != null && result['status'] == 'SUCESSO') {
      final List<TypeOccurenceModel> typesOccurences = [];

      for (var item in result['tiposOcorrencia']) {
        typesOccurences.add(TypeOccurenceModel.fromJson(item));
      }

      return typesOccurences;
    }

    return [];
  }

  @override
  Future<void> saveOccurrence({
    required TravelModel travel,
    required OccurrenceModel ocurrence,
    AddressModel? address,
  }) async {
    ClientModel? client = address?.client;

    /** convert dates to dd/MM/yyyy HH:mm */
    final dateArrival = address?.estimatedArrival;
    final dateDeparture = address?.estimatedDeparture;
    final dateArrivalReal = address?.realArrival;
    final dateDepartureReal = address?.realDeparture;
    final dateHourOccurrence = ocurrence.dateHour;

    final DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
    final String? estimatedArrival = dateArrival != null ? dateFormat.format(dateArrival) : null;
    final String? estimatedDeparture = dateDeparture != null ? dateFormat.format(dateDeparture) : null;
    final String? realArrival = dateArrivalReal != null ? dateFormat.format(dateArrivalReal) : null;
    final String? realDeparture = dateDepartureReal != null ? dateFormat.format(dateDepartureReal) : null;
    final String hourOccurrence = dateFormat.format(dateHourOccurrence);

    final pointPassage = {
      'ordemPassagem': address?.passOrder,
      'tipoOperacao': address?.typeOperation?.toUpperCase(),
      'cliente': {
        'nome': client?.name,
        'celular': client?.phone,
        'fone': client?.phone,
        'documento': {
          'tipo': client?.typeDocument,
          'numero': client?.documentNumber,
          'numeroSemMascara': client?.documentNumberWithoutMask,
          'nome': client?.name,
        }
      },
      'endereco': {
        'cidade': {'pais': 'brasil', 'uf': address?.state, 'cidade': address?.city},
        'logradouro': address?.address,
        'numero': address?.number,
        'complemento': address?.complement,
        'bairro': address?.neighborhood,
        'estado': address?.state,
        'cep': address?.zipCode,
        'latLng': {
          'latitude': address?.latitude,
          'longitude': address?.longitude,
        },
        'dataHoraPrevisaoChegada': estimatedArrival,
        'dataHoraPrevisaoSaida': estimatedDeparture,
        'dataHoraChegadaReal': realArrival,
        'dataHoraSaidaReal': realDeparture,
      },
    };

    final occurrenceData = {
      'tipoOcorrencia': ocurrence.typeOccurrence.toJson(),
      'descricao': ocurrence.description,
      'pontoPassagem': pointPassage,
      'dataHora': hourOccurrence,
      'urlFotos': ocurrence.urlPhotos,
      'latLng': {
        'latitude': address?.latitude,
        'longitude': address?.longitude,
      },
    };

    final dataSend = jsonEncode({
      'idViagem': travel.travelIdApi,
      'ocorrencia': occurrenceData,
      'pontoPassagem': pointPassage,
    });

    print("#################dataSend: $dataSend");

    final response = await _restClient.post('/tracking/viagem/addOcorrencia', dataSend);

    print("#################response.body: ${response.body}");

    final status = response.body['status'];

    if (status != 'SUCESSO') {
      throw Exception('error_save_occurrence');
    }
  }

  @override
  Future<String> uploadImagesOccurrence({
    required Uint8List image,
    required String travelIdApi,
    int? idOccurrence,
  }) async {
    try {
      final dio = Dio();

      var response = await dio.post(
        "https://way-dev.webrouter.com.br/appTracking/imagem/uploadFotoOcorrencia",
        data: Stream.fromIterable(image.map((e) => [e])),
        options: Options(
          headers: {
            Headers.contentLengthHeader: image.length, // Set the content-length.
          },
          contentType: "image/jpeg",
        ),
        queryParameters: {
          "idViagem": travelIdApi,
          "idOcorrencia": idOccurrence,
        },
      );

      final body = response.data;
      if (body['status'] == 'SUCESSO') {
        return body['url'];
      } else {
        throw Exception('Erro ao enviar imagem');
      }
    } on DioError catch (e) {
      print(e);
      throw Exception('Erro ao enviar imagem');
    }
  }

  @override
  Future<List<OccurrenceModel>> getOccurrences({required String travelApiId}) async {
    final response = await _restClient.get('/tracking/viagem/getOcorrencias/$travelApiId');

    final result = response.body;

    if (result != null) {
      final List<OccurrenceModel> occurrences = [];

      for (var item in result) {
        final typeOccurence = item['tipoOcorrencia'];
        ClientModel? client;
        AddressModel? address;

        if (typeOccurence != null) {
          final typeOccurrence = TypeOccurenceModel.fromJson(typeOccurence);

          if (item['pontoPassagem'] != null) {
            var clientData = item['pontoPassagem']['cliente'];
            var addressData = item['pontoPassagem']['endereco'];

            if (clientData != null && clientData['nome'] != null) {
              clientData = ClientModel(
                name: clientData['nome'],
                phone: clientData['celular'],
                typeDocument: clientData['documento']['tipo'],
                documentNumber: clientData['documento']['numero'],
                documentNumberWithoutMask: clientData['documento']['numeroSemMascara'],
              );
              client = clientData;
            }
            if (addressData != null) {
              addressData = AddressModel(
                address: addressData['logradouro'],
                number: addressData['numero'],
                complement: addressData['complemento'],
                neighborhood: addressData['bairro'],
                city: addressData['cidade']?['cidade'] ?? '',
                state: addressData['cidade']?['uf'] ?? '',
                zipCode: addressData['cep'] ?? '',
                latitude: addressData['latLng']['latitude'] ?? 0,
                longitude: addressData['latLng']['longitude'] ?? 0,
                passOrder: item['pontoPassagem']['ordemPassagem'] ?? 0,
              );
              address = addressData;
            }
          }

          final occurrence = OccurrenceModel.fromJson({
            'id': item['id'],
            'type_occurrence': typeOccurrence.toJson(),
            'description': item['descricao'],
            'date_hour': item['dataHora'],
            'url_photos': item['urlFotos'],
            'lat_long': item['latLng'],
            'client': client?.toJson(),
            'address': address?.toJson(),
          });

          occurrences.add(occurrence);
        }
      }

      return occurrences;
    }

    return [];
  }

  @override
  Future<void> sendRegisterArrivalClient({required TravelModel travel, required AddressModel address}) async {
    try {
      final dataSend = {
        'idViagem': travel.travelIdApi,
        'indiceEndereco': address.passOrder,
        'dataHora': DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now()),
        'position': {
          'latitude': address.latitude,
          'longitude': address.longitude,
        }
      };

      final response = await _restClient.post('/tracking/viagem/endereco/chegada', jsonEncode(dataSend));

      final result = response.body;
      if (result == null || result['status'] != 'SUCESSO') {
        throw Exception(result == null ? 'error_communication_backend' : result['status']);
      }
    } catch (e) {
      log('error_register_arrival_client: $e');
    }
  }

  @override
  Future<void> sendRegisterDepartureClient({required TravelModel travel, required AddressModel address}) async {
    try {
      final dataSend = {
        'idViagem': travel.travelIdApi,
        'indiceEndereco': address.passOrder,
        'dataHora': DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now()),
        'position': {
          'latitude': address.latitude,
          'longitude': address.longitude,
        }
      };

      final response = await _restClient.post('/tracking/viagem/endereco/saida', jsonEncode(dataSend));

      final result = response.body;

      if (result == null || result['status'] != 'SUCESSO') {
        throw Exception(result == null ? 'error_communication_backend' : result['status']);
      }
    } catch (e) {
      log('error_register_arrival_client: $e');
    }
  }
}
