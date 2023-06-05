import 'package:ailog_app_tracking/app/modules/travel/repositories/travel_repository_database.dart';
import 'package:ailog_app_tracking/app/modules/travel/repositories/travel_repository_database_impl.dart';
import 'package:get/get.dart';

import '../../common/rest_client.dart';
import 'repositories/document_repository.dart';
import 'repositories/document_repository_impl.dart';
import 'services/document_service.dart';

class DocumentBinds implements Bindings {
  @override
  void dependencies() {
    /**
     * repositories
     */
    Get.lazyPut<DocumentRepository>(() => DocumentRepositoryImpl(restClient: Get.find<RestClient>()));
    Get.lazyPut<TravelRepositoryDatabase>(() => TravelRepositoryDatabaseImpl());

    /**
     * services
     */
    Get.lazyPut<DocumentService>(
      () => DocumentService(
        documentRepository: Get.find<DocumentRepository>(),
        travelRepositoryDatabase: Get.find<TravelRepositoryDatabase>(),
      ),
    );
  }
}
