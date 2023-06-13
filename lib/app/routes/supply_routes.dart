import 'package:ailog_app_tracking/app/modules/supply/pages/supply_create_or_edit.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../modules/supply/pages/supply_page.dart';
import '../modules/supply/supply_binding.dart';

class SupplyRoutes {
  SupplyRoutes._();

  static final routes = <GetPage>[
    GetPage(
      name: '/supply',
      page: () => const SupplyPage(),
      binding: SupplyBinding(),
    ),
    GetPage(
      name: '/supply/create',
      page: () => const SupplyCreateOrEdit(),
      binding: SupplyBinding(),
    ),
  ];
}
