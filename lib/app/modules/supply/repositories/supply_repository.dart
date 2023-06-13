import 'dart:typed_data';

abstract class SupplyRepository {
  Future<String> uploadImage({
    required Uint8List image,
    required String travelIdApi,
    required String typeImage,
  });
}
