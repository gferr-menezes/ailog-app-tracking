import 'package:ailog_app_tracking/app/modules/travel/widgets/address_list.dart';
import 'package:ailog_app_tracking/app/modules/travel/widgets/travel_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/ui/widgets/custom_loading.dart';
import '../controllers/travel_controller.dart';
import '../widgets/form_travel.dart';

class TravelPage extends StatefulWidget {
  const TravelPage({super.key});

  @override
  State<TravelPage> createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> {
  final TravelController travelController = Get.find<TravelController>();

  @override
  void initState() {
    super.initState();
    travelController.checkTravelInitialized();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
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
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
                              child: AddressList(),
                            ),
                          ),
                        ],
                      );
          },
        );
      },
    );
  }
}
