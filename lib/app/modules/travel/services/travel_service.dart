import 'package:intl/intl.dart';

import '../../../common/response_status_api.dart';
import '../models/address_model.dart';
import '../models/client_model.dart';
import '../models/toll_model.dart';
import '../models/travel_model.dart';
import '../repositories/travel_repository.dart';
import '../repositories/travel_repository_database.dart';

class TravelService {
  final TravelRepository _travelRepository;
  final TravelRepositoryDatabase _travelRepositoryDatabase;

  TravelService({
    required TravelRepository travelRepository,
    required TravelRepositoryDatabase travelRepositoryDatabase,
  })  : _travelRepository = travelRepository,
        _travelRepositoryDatabase = travelRepositoryDatabase;

  Future<List<TravelModel>?> startTravel(String plate) async {
    final result = await _travelRepository.checkTravelExistsInAPI(plate);
    String? status = result?['status'];

    if (result == null || status == null) {
      throw Exception('Erro ao iniciar viagem');
    }

    if (status == ResponseStatusApi.VIAGEM_NAO_LOCALIZADA.name) {
      throw Exception('Viagem não localizada');
    }

    if (status == ResponseStatusApi.SUCESSO.name) {
      final travelData = result['viagens'] as List;
      List<TravelModel> travels = [];
      List<AddressModel> addresses = [];
      List<TollModel> tolls = [];
      ClientModel? client;

      for (var travel in travelData) {
        DateTime? dateInitTravel;
        DateTime? dateEndTravel;
        var inputFormat = DateFormat('dd/MM/yyyy HH:mm');

        if (travel['dataHoraPrevisaoInicio'] != null) {
          dateInitTravel = inputFormat.parse(travel['dataHoraPrevisaoInicio']);
        }

        if (travel['dataHoraPrevisaoFim'] != null) {
          dateEndTravel = inputFormat.parse(travel['dataHoraPrevisaoFim']);
        }

        /** tolls */
        final tollsData = travel['pedagios'] as List;
        for (var toll in tollsData) {
          DateTime? datePassage;

          if (toll['dataHoraPassagem'] != null) {
            datePassage = inputFormat.parse(travel['dataHoraPassagem']);
          }

          tolls.add(TollModel(
            ailogId: toll['idAilog'],
            concessionaire: toll['concessionaria'].toString().toLowerCase(),
            highway: toll['rodovia'].toString().toLowerCase(),
            passOrder: toll['ordemPassagem'],
            quantityAxes: toll['quantidadeEixos'],
            tollName: toll['pedagio'].toString().toLowerCase(),
            valueManual: toll['valorManual'] as double,
            valueTag: toll['valorTag'] as double,
            acceptAutomaticBilling: toll['aceitaCobrancaAutomatica'],
            acceptPaymentProximity: toll['aceitaPagamentoAproximacao'],
            valueInformed: toll['valorInformadoMotorista'] != null ? toll['valorInformadoMotorista'] as double : null,
            datePassage: datePassage,
            travelIdApi: travel['idViagem'],
            latitude: toll['latLng'] != null ? toll['latLng']['latitude'] as double : null,
            longitude: toll['latLng'] != null ? toll['latLng']['longitude'] as double : null,
            urlVoucherImage: toll['urlComprovante'],
          ));
        }

        final clientData = travel['cliente'];
        final addressData = travel['enderecos'] as List;

        if (clientData != null) {
          client = ClientModel(
            name: clientData['nome'].toString().toLowerCase(),
            cellPhone: clientData['celular'],
            documentNumber: clientData['documento']['numero'],
            documentNumberWithoutMask: clientData['documento']['numeroSemMascara'],
            phone: clientData['fone'],
            typeDocument: clientData['documento']['tipo']?.toString().toLowerCase(),
            travelIdApi: travel['idViagem'],
          );
        }

        for (var address in addressData) {
          var cityData = address['endereco']['cidade'];
          var latLongData = address['endereco']['latLng'];

          DateTime? estimatedDeparture;
          DateTime? estimatedArrival;
          DateTime? realDeparture;
          DateTime? realArrival;

          if (address['dataHoraPrevisaoSaida'] != null) {
            estimatedDeparture = inputFormat.parse(travel['dataHoraPrevisaoSaida']);
          }

          if (address['dataHoraPrevisaoChegada'] != null) {
            estimatedArrival = inputFormat.parse(travel['dataHoraPrevisaoChegada']);
          }

          if (address['dataHoraSaidaReal'] != null) {
            realDeparture = inputFormat.parse(travel['dataHoraSaidaReal']);
          }

          if (address['dataHoraChegadaReal'] != null) {
            realArrival = inputFormat.parse(travel['dataHoraChegadaReal']);
          }

          addresses.add(
            AddressModel(
              city: cityData['cidade'].toString().toLowerCase(),
              state: cityData['uf'].toString().toLowerCase(),
              passOrder: address['ordemPassagem'],
              address: address['endereco']['logradouro']?.toString().toLowerCase(),
              complement: address['endereco']['complemento']?.toString().toLowerCase(),
              number: address['endereco']['numero']?.toString().toLowerCase(),
              neighborhood: address['endereco']['bairro']?.toString().toLowerCase(),
              zipCode: address['endereco']['cep']?.toString().toLowerCase(),
              latitude: latLongData['latitude'] as double,
              longitude: latLongData['longitude'] as double,
              country: cityData['pais']?.toString().toLowerCase(),
              estimatedDeparture: estimatedDeparture,
              estimatedArrival: estimatedArrival,
              realDeparture: realDeparture,
              realArrival: realArrival,
              travelIdApi: travel['idViagem'],
              typeOperation: address['tipoOperacao']?.toString().toLowerCase(),
              client: client,
            ),
          );
        }

        travels.add(
          TravelModel(
            plate: plate.toLowerCase(),
            code: travel['codigo'],
            travelIdApi: travel['idViagem'],
            estimatedDeparture: dateInitTravel,
            estimatedArrival: dateEndTravel,
            vpoEmitName: travel['emissor']?.toString().toLowerCase(),
            valueTotal: travel['valorTotal'] as double,
            status: StatusTravel.inProgress.name,
            addresses: addresses,
            tolls: tolls,
          ),
        );
      }

      return travels;
    }

    throw Exception('Erro ao iniciar viagem');
  }

  Future<void> saveTravel(TravelModel travel) async {
    /**
     * filter addresses travelIdApi
     */
    var addressesFiltered = travel.addresses?.where((element) => element.travelIdApi == travel.travelIdApi).toList();
    travel.addresses = addressesFiltered;

    /** filter tolls travelIdApi */
    var tollsFiltered = travel.tolls?.where((element) => element.travelIdApi == travel.travelIdApi).toList();
    travel.tolls = tollsFiltered;

    await _travelRepositoryDatabase.insertTravel(travel);
  }

  Future<List<TravelModel>?> getTravels({String? plate, String? status, int? id}) async {
    var travels = await _travelRepositoryDatabase.getTravels(plate: plate, status: status, id: id);
    return travels;
  }

  Future<List<AddressModel>?> getAddresses({required int travelId}) async {
    var addresses = await _travelRepositoryDatabase.getAddresses(travelId: travelId);
    return addresses;
  }

  Future<List<TollModel>?> getTolls({required int travelId}) async {
    var tolls = await _travelRepositoryDatabase.getTolls(travelId: travelId);
    return tolls;
  }

  Future<void> updateTravel(TravelModel travel) async {
    await _travelRepositoryDatabase.updateTravel(travel: travel);
  }

  Future<void> informValuePay({
    required TollModel toll,
    required double valuePay,
  }) async {
    try {
      await _travelRepository.informValuePay(
        travelApiId: toll.travelIdApi!,
        passOrder: toll.passOrder,
        ailogId: toll.ailogId,
        valuePay: valuePay,
      );

      toll.valueInformed = valuePay;

      await _travelRepositoryDatabase.updateToll(toll: toll);
    } catch (e) {
      throw Exception(e);
    }
  }
}
