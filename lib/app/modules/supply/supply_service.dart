import 'dart:typed_data';

import 'package:ailog_app_tracking/app/modules/supply/models/supply_model.dart';
import 'package:ailog_app_tracking/app/modules/supply/repositories/supply_database_repository.dart';
import 'package:ailog_app_tracking/app/modules/supply/repositories/supply_repository.dart';

class SupplyService {
  final SupplyDatabaseRepository _supplyRepository;
  final SupplyRepository _supplyApiRepository;

  SupplyService({
    required SupplyDatabaseRepository supplyRepository,
    required SupplyRepository supplyApiRepository,
  })  : _supplyRepository = supplyRepository,
        _supplyApiRepository = supplyApiRepository;

  Future<void> insert({required SupplyModel supply}) async {
    await _supplyRepository.insert(supply);
  }

  Future<List<SupplyModel>?> getAll({int? supplyIdApi, int? travelId, String? travelIdApi}) async {
    return await _supplyRepository.getAll(supplyIdApi, travelId, travelIdApi);
  }

  Future<String> uploadImage({required Uint8List image, required String travelIdApi, required String typeImage}) async {
    return await _supplyApiRepository.uploadImage(image: image, travelIdApi: travelIdApi, typeImage: typeImage);
  }

  Future<void> sendSupply({required SupplyModel supply}) async {
    await _supplyApiRepository.sendSupply(supply: supply);
  }
}
