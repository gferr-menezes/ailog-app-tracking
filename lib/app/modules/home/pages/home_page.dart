import 'package:app_minimizer/app_minimizer.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../common/ui/widgets/custom_app_bar.dart';
import '../../travel/controllers/travel_controller.dart';
import '../home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TravelController travelController = Get.find<TravelController>();

    return WillPopScope(
        onWillPop: () {
          FlutterAppMinimizer.minimize();
          return Future.value(false);
        },
        child: Scaffold(
          appBar: CustomAppBar(),
          bottomNavigationBar: Obx(
            () {
              var travelIsInitialized = travelController.existTravelInitialized;

              return BottomNavigationBar(
                selectedItemColor: context.theme.primaryColor,
                backgroundColor: Colors.grey[200],
                currentIndex: controller.tabIndex,
                onTap: (value) {
                  if (!travelIsInitialized && value == 1) {
                    return;
                  }
                  controller.tabIndex = value;
                },
                items: [
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.home),
                    label: 'Viagens',
                    activeIcon: Icon(
                      Icons.home,
                      color: context.theme.primaryColor,
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.map),
                    activeIcon: Icon(
                      Icons.map,
                      color: context.theme.primaryColor,
                    ),
                    label: 'Pontos coletados',
                  ),
                ],
              );
            },
          ),
          body: Navigator(
            initialRoute: '/travel',
            key: Get.nestedKey(HomeController.NAVIGATOR_KEY),
            onGenerateRoute: controller.onGenerateRouter,
          ),
        ));
  }
}
