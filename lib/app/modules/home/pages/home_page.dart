import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../common/ui/widgets/custom_app_bar.dart';
import '../home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      bottomNavigationBar: Obx(
        () {
          return BottomNavigationBar(
            selectedItemColor: context.theme.primaryColor,
            backgroundColor: Colors.grey[200],
            currentIndex: controller.tabIndex,
            onTap: (value) {
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
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings),
                activeIcon: Icon(
                  Icons.settings,
                  color: context.theme.primaryColor,
                ),
                label: 'Configurações',
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
    );
  }
}
