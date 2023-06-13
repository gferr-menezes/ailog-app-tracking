import '../models/supply_model.dart';

abstract class SupplyDatabaseRepository {
  Future<List<SupplyModel>?> getAll(int? supplyIdApi, int? travelId, String? travelIdApi);
  Future<SupplyModel> insert(SupplyModel supply);
}
