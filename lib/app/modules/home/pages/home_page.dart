import 'package:app_minimizer/app_minimizer.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../common/ui/widgets/custom_app_bar.dart';
import '../../travel/controllers/travel_controller.dart';
import '../home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TravelController travelController = Get.find<TravelController>();
    final HomeController controller = Get.find<HomeController>();

    return WillPopScope(
      onWillPop: () async {
        if (travelController.popMenuTollIsVisible.isTrue) {
          travelController.closeTollListPopMenu();
          return false;
        } else {
          FlutterAppMinimizer.minimize();
          return Future.value(false);
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(),
        floatingActionButton: Obx(
          () {
            return !travelController.existTravelInitialized
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: SizedBox(
                      height: 40,
                      child: FloatingActionButton.extended(
                        label: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                var travel = travelController.travel;
                                controller.floatExtended = false;

                                Get.toNamed('/supply', arguments: {
                                  'travelId': travel.id,
                                  'travelIdApi': travel.travelIdApi,
                                });
                              },
                              icon: const Icon(Icons.local_gas_station),
                              tooltip: 'Abastecimento',
                            ),
                            IconButton(
                              onPressed: () {
                                var travel = travelController.travel;
                                controller.floatExtended = false;
                                Get.toNamed(
                                  '/travel/occurrences',
                                  arguments: {'travel': travel},
                                );
                              },
                              icon: const Icon(Icons.new_releases_sharp),
                              tooltip: 'Registrar ocorrência',
                            ),
                            IconButton(
                              onPressed: () {
                                var travel = travelController.travel;
                                controller.floatExtended = false;
                                Get.toNamed(
                                  '/travel/vehicle-occurrences',
                                  arguments: {'travel': travel},
                                );
                              },
                              icon: const Icon(Icons.build),
                              tooltip: 'Registrar ocorrência',
                            ),
                          ],
                        ),
                        isExtended: controller.floatExtended,
                        icon: Icon(
                          controller.floatExtended == true ? Icons.close : Icons.menu,
                          color: controller.floatExtended == true ? Colors.red : Colors.white,
                        ),
                        onPressed: () {
                          controller.floatExtended = !controller.floatExtended;
                        },
                        backgroundColor: controller.floatExtended == true
                            ? Theme.of(context).primaryColor.withOpacity(.7)
                            : context.theme.primaryColor,
                      ),
                    ),
                  );
          },
        ),
        bottomNavigationBar: Obx(
          () {
            var travelIsInitialized = travelController.existTravelInitialized;
            return BottomAppBar(
              color: Colors.grey[200],
              // shape: travelIsInitialized ? const CircularNotchedRectangle() : null,
              //notchMargin: 4,
              //clipBehavior: Clip.antiAlias,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      if (!travelIsInitialized) {
                        return;
                      }
                      controller.tabIndex = 0;
                    },
                    icon: Icon(
                      Icons.home,
                      color: controller.tabIndex == 0 ? context.theme.primaryColor : Colors.grey,
                    ),
                  ),
                  IconButton(
                    color: controller.tabIndex == 1 ? context.theme.primaryColor : Colors.grey,
                    onPressed: () {
                      if (!travelIsInitialized) {
                        return;
                      }
                      controller.tabIndex = 1;
                    },
                    icon: Icon(
                      Icons.map,
                      color: controller.tabIndex == 1 ? context.theme.primaryColor : Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
        body: Navigator(
          initialRoute: '/travel',
          key: Get.nestedKey(HomeController.NAVIGATOR_KEY),
          onGenerateRoute: controller.onGenerateRouter,
        ),
      ),
    );
  }
}
