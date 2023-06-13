import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import './supply_repository.dart';

class SupplyRepositoryImpl extends SupplyRepository {
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
}

enum TypeImage {
  bomba,
  hodometro,
  cupomFical,
}
