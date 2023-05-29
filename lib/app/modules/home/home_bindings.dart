import 'package:get/get.dart';

import '../../common/rest_client.dart';
import '../travel/controllers/travel_controller.dart';
import '../travel/repositories/travel_repository.dart';
import '../travel/repositories/travel_repository_database.dart';
import '../travel/repositories/travel_repository_database_impl.dart';
import '../travel/repositories/travel_repository_impl.dart';
import '../travel/services/travel_service.dart';
import './home_controller.dart';

class HomeBindings implements Bindings {
  @override
  void dependencies() {
    /**
     * repositories
     */
    Get.lazyPut<TravelRepository>(() => TravelRepositoryImpl(restClient: Get.find<RestClient>()));
    Get.lazyPut<TravelRepositoryDatabase>(() => TravelRepositoryDatabaseImpl());

    /**
     * services
     */
    Get.lazyPut<TravelService>(
      () => TravelService(
        travelRepository: Get.find<TravelRepository>(),
        travelRepositoryDatabase: Get.find<TravelRepositoryDatabase>(),
      ),
    );

    /**
     * controllers
     */
    Get.lazyPut(() => HomeController());
    Get.lazyPut<TravelController>(() => TravelController(travelService: Get.find<TravelService>()));
  }
}
