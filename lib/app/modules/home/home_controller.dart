import 'package:ailog_app_tracking/app/modules/travel/pages/lat_long_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../travel/pages/travel_page.dart';
import '../travel/travel_binding.dart';

class HomeController extends GetxController {
  HomeController();

  // ignore: constant_identifier_names
  static const NAVIGATOR_KEY = 1;

  final _tabIndex = 0.obs;
  final _floatExtended = false.obs;

  int get tabIndex => _tabIndex.value;
  final _tabs = [
    '/travel',
    '/lat-long',
  ];

  set tabIndex(int index) {
    _tabIndex(index);
    Get.toNamed(_tabs[index], id: NAVIGATOR_KEY);
  }

  bool get floatExtended => _floatExtended.value;
  set floatExtended(bool value) => _floatExtended(value);

  Route? onGenerateRouter(RouteSettings settings) {
    if (settings.name == '/travel') {
      return GetPageRoute(
        settings: settings,
        page: () => const TravelPage(),
        binding: TravelBinding(),
        transition: Transition.fadeIn,
      );
    }
    if (settings.name == '/lat-long') {
      return GetPageRoute(
        settings: settings,
        page: () => const LatLongPage(),
        binding: TravelBinding(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 5),
      );
    }

    return null;
  }
}
