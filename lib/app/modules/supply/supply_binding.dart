import 'package:get/get.dart';

import 'repositories/supply_database_repository.dart';
import 'repositories/supply_database_repository_impl.dart';
import 'repositories/supply_repository.dart';
import 'repositories/supply_repository_impl.dart';
import 'supply_controller.dart';
import 'supply_service.dart';

class SupplyBinding implements Bindings {
  @override
  void dependencies() {
    /** repositories */
    Get.lazyPut<SupplyDatabaseRepository>(() => SupplyDatabaseRepositoryImpl());

    Get.lazyPut<SupplyRepository>(() => SupplyRepositoryImpl());

    /** services */
    Get.lazyPut<SupplyService>(() => SupplyService(supplyRepository: Get.find(), supplyApiRepository: Get.find()));

    /** controllers */
    Get.lazyPut<SupplyController>(() => SupplyController(supplyService: Get.find()));
  }
}
