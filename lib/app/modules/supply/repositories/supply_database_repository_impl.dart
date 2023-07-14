import '../../../database/database_sqlite.dart';
import '../models/supply_model.dart';
import './supply_database_repository.dart';

class SupplyDatabaseRepositoryImpl implements SupplyDatabaseRepository {
  @override
  Future<List<SupplyModel>?> getAll(int? supplyIdApi, int? travelId, String? travelIdApi) async {
    final db = await DatabaseSQLite().openConnection();

    var where = '';

    if (supplyIdApi != null) {
      where = 'supply_id_api = $supplyIdApi';
    }

    if (travelId != null) {
      where = 'travel_id = $travelId';
    }

    if (travelIdApi != null) {
      where = 'travel_id_api = "$travelIdApi"';
    }

    final result = await db.query(
      'supplies',
      where: where,
    );

    if (result.isEmpty) {
      return null;
    }

    return result.map((e) => SupplyModel.fromJson(e)).toList();
  }

  @override
  Future<SupplyModel> insert(SupplyModel supply) async {
    final db = await DatabaseSQLite().openConnection();

    final result = await db.insert(
      'supplies',
      supply.toJson(),
    );

    supply.id = result;

    return supply;
  }
}
