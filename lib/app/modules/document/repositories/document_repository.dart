import 'dart:typed_data';

import '../../travel/models/toll_model.dart';

abstract class DocumentRepository {
  Future<String> uploadPhotoToll({
    required TollModel toll,
    required Uint8List image,
  });
}
