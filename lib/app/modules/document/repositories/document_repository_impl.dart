import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../common/rest_client.dart';
import '../../travel/models/toll_model.dart';
import './document_repository.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  final RestClient _restClient;

  DocumentRepositoryImpl({required RestClient restClient}) : _restClient = restClient;

  @override
  Future<String> uploadPhotoToll({
    required TollModel toll,
    required Uint8List image,
  }) async {
    final dio = Dio();
    try {
      final Response response =
          await dio.post("https://way-dev.webrouter.com.br/appTracking/imagem/uploadComprovantePedagio",
              data: Stream.fromIterable(image.map((e) => [e])), // Creates a Stream<List<int>>.
              options: Options(
                headers: {
                  Headers.contentLengthHeader: image.length, // Set the content-length.
                },
                contentType: "image/jpeg",
              ),
              queryParameters: {
            "idViagem": toll.travelIdApi,
            "idPedagio": toll.ailogId.toString(),
            "ordemPassagem": toll.passOrder.toString(),
          });

      final body = response.data;
      if (body['status'] == 'SUCESSO') {
        return body['url'];
      } else {
        throw Exception('Erro ao enviar imagem');
      }
    } on DioError catch (e) {
      log(e.message.toString());
      throw Exception('Erro ao enviar imagem');
    }
  }
}
