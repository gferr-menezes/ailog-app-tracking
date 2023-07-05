import 'package:ailog_app_tracking/app/modules/travel/pages/occurrence_photo_page.dart';
import 'package:get/get.dart';

import '../modules/document/document_binds.dart';
import '../modules/document/pages/documents_page.dart';
import '../modules/home/home_bindings.dart';
import '../modules/home/pages/home_page.dart';
import '../modules/travel/pages/map_page.dart';
import '../modules/travel/pages/occurrence_page.dart';
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
      binding: DocumentBinds(),
      transitionDuration: const Duration(milliseconds: 5),
      arguments: null,
    ),
    GetPage(
      name: '/travel/occurrences',
      page: () => const OccurrencePage(),
      binding: TravelBinding(),
      transitionDuration: const Duration(milliseconds: 5),
      arguments: null,
    ),
    GetPage(
      name: '/travel/occurrences/photo',
      page: () => const OccurrencePhotoPage(),
      binding: TravelBinding(),
      transitionDuration: const Duration(milliseconds: 5),
      arguments: null,
    ),
  ];
}
