import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/ui/widgets/custom_loading.dart';
import '../controllers/travel_controller.dart';
import '../widgets/form_travel.dart';
import '../widgets/travel_data.dart';

class TravelMainPage extends StatelessWidget {
  const TravelMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final travelController = Get.find<TravelController>();

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Obx(
            () {
              return travelController.loadingCheckTravelInitialized
                  ? const CustomLoading()
                  : !travelController.existTravelInitialized
                      ? const Padding(
                          padding: EdgeInsets.only(left: 5, top: 30, right: 5, bottom: 20),
                          child: FormTravel(),
                        )
                      : Column(
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(top: 5, left: 5, right: 5),
                              child: TravelData(),
                            ),
                          ],
                        );
            },
          );
        },
      ),
    );
  }
}
