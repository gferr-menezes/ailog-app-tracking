import '../../../common/rest_client.dart';
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
}
