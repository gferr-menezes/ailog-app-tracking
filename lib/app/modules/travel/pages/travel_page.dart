import 'dart:async';
import 'dart:developer';

import 'package:ailog_app_tracking/app/common/ui/widgets/error_location_permission.dart';
import 'package:ailog_app_tracking/app/modules/travel/pages/rotogram_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../common/geolocation.dart';

import '../../../common/permission_controller.dart';
import '../../../common/ui/widgets/custom_loading.dart';
import '../controllers/geolocation_controller.dart';
import '../controllers/travel_controller.dart';
import '../widgets/address_list.dart';
import '../widgets/form_travel.dart';
import '../widgets/occurrence_list.dart';
import '../widgets/toll_list.dart';
import '../widgets/travel_data.dart';

class TravelPage extends StatefulWidget {
  const TravelPage({super.key});

  @override
  State<TravelPage> createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> with WidgetsBindingObserver {
  bool floatExtended = false;
  final TravelController travelController = Get.find<TravelController>();
  final GeolocationController geolocationController = Get.find<GeolocationController>();
  StreamSubscription<Position>? _positionStreamSubscription;

  late Future<PermissionStatus> permissionApp;
  bool _appPermissionLocation = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      PermissionController.checkGeolocationPermission().then((value) {
        if (value == PermissionStatus.granted) {
          setState(() {
            _appPermissionLocation = true;
          });
        } else {
          PermissionController.getGeolocationPermission().then((value) {
            if (value) {
              setState(() {
                _appPermissionLocation = true;
              });
            }
          });
        }
      });

      travelController.checkTravelInitialized();
    });

    Timer.periodic(const Duration(minutes: 2), (timer) async {
      var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      Position? lastPosition = await Geolocator.getLastKnownPosition();
      if (lastPosition != null) {}
      geolocationController.collectLatitudeLongitude(position);
    });

    Timer.periodic(const Duration(minutes: 2), (timer) {
      geolocationController.sendGeolocationsPending();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _positionStreamSubscription?.cancel();
    } else if (state == AppLifecycleState.paused) {
      log('message');
      Geolocation.callPositionStream().then((value) => _positionStreamSubscription = value);
    }
  }

  validadePermission(bool check) {
    if (check) {
      setState(() {
        _appPermissionLocation = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !_appPermissionLocation
          ? ErrorLocationPermission(callback: validadePermission)
          : SafeArea(
              child: Obx(
                () => travelController.loadingCheckTravelInitialized
                    ? const Center(
                        child: CustomLoading(),
                      )
                    : !travelController.existTravelInitialized
                        ? const Padding(
                            padding: EdgeInsets.only(left: 5, top: 30, right: 5, bottom: 20),
                            child: FormTravel(),
                          )
                        : Column(
                            children: [
                              const SizedBox(
                                height: 253,
                                child: TravelData(),
                              ),
                              Expanded(
                                child: DefaultTabController(
                                  length: 4,
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
                                                isScrollable: true,
                                                tabs: const [
                                                  SizedBox(
                                                    height: 30,
                                                    child: Tab(
                                                      text: 'ROTOGRAMA',
                                                    ),
                                                  ),
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
                                                  SizedBox(
                                                    height: 30,
                                                    child: Tab(
                                                      text: 'OCORRÊNCIAS',
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        )),
                                    body: TabBarView(
                                      children: [
                                        const RotogramPage(),
                                        const AddressList(),
                                        const TollList(),
                                        OccurrenceList(
                                          travelApiId: travelController.travel.travelIdApi!,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
              ),
            ),
    );
  }
}
