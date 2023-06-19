import 'dart:typed_data';

import 'package:ailog_app_tracking/app/modules/supply/models/supply_model.dart';

abstract class SupplyRepository {
  Future<String> uploadImage({
    required Uint8List image,
    required String travelIdApi,
    required String typeImage,
  });

  Future<void> sendSupply({required SupplyModel supply});
}
