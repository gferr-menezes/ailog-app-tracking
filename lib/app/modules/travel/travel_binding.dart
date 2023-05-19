import 'package:get/get.dart';

import '../../common/rest_client.dart';
import 'controllers/geolocation_controller.dart';
import 'controllers/travel_controller.dart';
import 'repositories/travel_repository.dart';
import 'repositories/travel_repository_database.dart';
import 'repositories/travel_repository_database_impl.dart';
import 'repositories/travel_repository_impl.dart';
import 'services/geolocation_service.dart';
import 'services/travel_service.dart';

class TravelBinding implements Bindings {
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

    Get.lazyPut<GeolocationService>(
      () => GeolocationService(
        travelRepository: Get.find<TravelRepository>(),
        travelRepositoryDatabase: Get.find<TravelRepositoryDatabase>(),
      ),
    );

    /**
     * controllers
     */
    Get.lazyPut<TravelController>(() => TravelController(travelService: Get.find<TravelService>()));
    Get.lazyPut<GeolocationController>(
      () => GeolocationController(
          travelService: Get.find<TravelService>(), geolocationService: Get.find<GeolocationService>()),
    );
  }
}
