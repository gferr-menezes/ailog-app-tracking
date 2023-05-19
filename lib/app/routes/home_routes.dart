import 'package:get/get.dart';

import '../modules/home/home_bindings.dart';
import '../modules/home/pages/home_page.dart';

class HomeRoutes {
  HomeRoutes._();

  static final routes = <GetPage>[
    GetPage(
      name: '/home',
      page: () => const HomePage(),
      binding: HomeBindings(),
    ),
  ];
}
