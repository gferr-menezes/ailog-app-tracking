import 'dart:developer';
import 'dart:typed_data';

import 'package:ailog_app_tracking/app/modules/supply/models/supply_model.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../../../common/rest_client.dart';
import './supply_repository.dart';

class SupplyRepositoryImpl extends SupplyRepository {
  final RestClient _restClient;

  SupplyRepositoryImpl({required RestClient restClient}) : _restClient = restClient;

  @override
  Future<String> uploadImage({required Uint8List image, required String travelIdApi, required String typeImage}) async {
    try {
      final dio = Dio();

      final String typeImageInformed;

      if (typeImage == TypeImage.bomba.name) {
        typeImageInformed = "BOMBA";
      } else if (typeImage == TypeImage.hodometro.name) {
        typeImageInformed = "HODOMETRO";
      } else if (typeImage == TypeImage.cupomFical.name) {
        typeImageInformed = "CUPOM_FISCAL";
      } else {
        throw Exception('Tipo de imagem não informado');
      }

      final Response response = await dio.post(
        "https://way-dev.webrouter.com.br/appTracking/imagem/uploadComprovanteAbastecimento",
        data: Stream.fromIterable(image.map((e) => [e])),
        options: Options(
          headers: {
            Headers.contentLengthHeader: image.length, // Set the content-length.
          },
          contentType: "image/jpeg",
        ),
        queryParameters: {
          "tipoImagem": typeImageInformed,
          "idViagem": travelIdApi,
        },
      );

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

  @override
  Future<void> sendSupply({required SupplyModel supply}) async {
    var date = supply.dateSupply;
    var dateSupply = DateFormat('dd/MM/yyyy HH:mm').format(date!);

    final dataSend = {
      'idViagem': supply.travelIdApi,
      'dataHora': dateSupply,
      'valorUnitario': supply.valueLiter,
      'valorTotal': supply.valueLiter * supply.liters,
      'quantidadeLitros': supply.liters,
      'kmOdometro': supply.odometer,
      'posicao': {
        'latitude': supply.latitude,
        'longitude': supply.longitude,
      },
      'urlFotoBomba': supply.urlImagePump,
      'urlFotoComprovante': supply.urlImageInvoice,
      'urlFotoHodometro': supply.urlImageOdometer,
      'ocrRecibo': supply.ocrRecibo,
    };

    final response = await _restClient.post('/abastecimento/save', dataSend);

    print(response.body);
  }
}

enum TypeImage {
  bomba,
  hodometro,
  cupomFical,
}
