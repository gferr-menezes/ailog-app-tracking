import 'package:ailog_app_tracking/app/modules/travel/controllers/geolocation_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/ui/widgets/custom_loading.dart';
import '../controllers/travel_controller.dart';
import '../widgets/address_list.dart';
import '../widgets/form_travel.dart';
import '../widgets/toll_list.dart';
import '../widgets/travel_data.dart';

class TravelPage extends StatefulWidget {
  const TravelPage({super.key});

  @override
  State<TravelPage> createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> {
  final TravelController travelController = Get.find<TravelController>();
  final GeolocationController geolocationController = Get.find<GeolocationController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      travelController.checkTravelInitialized();
    });

    // geolocationController.collectLatitudeLongitude();
    geolocationController.sendGeolocationsPending();
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
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 5, left: 5, right: 5),
                            child: TravelData(),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
                              child: DefaultTabController(
                                length: 2,
                                child: Scaffold(
                                  appBar: PreferredSize(
                                      preferredSize: const Size.fromHeight(40),
                                      child: AppBar(
                                        backgroundColor: context.theme.primaryColorLight,
                                        automaticallyImplyLeading: false,
                                        flexibleSpace: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            TabBar(
                                              indicatorColor: context.theme.primaryColor,
                                              labelColor: Colors.black,
                                              tabs: const [
                                                SizedBox(
                                                  height: 30,
                                                  child: Tab(
                                                    text: 'ENDEREÇOS',
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 30,
                                                  child: Tab(
                                                    text: 'PEDÁGIOS',
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )),
                                  body: const TabBarView(
                                    children: [
                                      AddressList(),
                                      TollList(),
                                    ],
                                  ),
                                ),
                              ),
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
