import 'package:ailog_app_tracking/app/common/ui/widgets/documents_page.dart';
import 'package:get/get.dart';

import '../modules/home/home_bindings.dart';
import '../modules/home/pages/home_page.dart';
import '../modules/travel/pages/map_page.dart';
import '../modules/travel/travel_binding.dart';

class HomeRoutes {
  HomeRoutes._();

  static final routes = <GetPage>[
    GetPage(
      name: '/home',
      page: () => const HomePage(),
      binding: HomeBindings(),
    ),
    GetPage(
      name: '/travel/map',
      page: () => const MapPage(),
      binding: TravelBinding(),
      transitionDuration: const Duration(milliseconds: 5),
      arguments: null,
    ),
    GetPage(
      name: '/documents',
      page: () => const DocumentsPage(),
      transitionDuration: const Duration(milliseconds: 5),
      arguments: null,
    ),
  ];
}
