import 'package:get/get.dart';

import 'common/rest_client.dart';

class ApplicationBind implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RestClient(), fenix: true);
  }
}
