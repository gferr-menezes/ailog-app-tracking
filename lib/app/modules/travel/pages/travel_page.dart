import 'dart:async';
import 'dart:developer';

import 'package:ailog_app_tracking/app/common/ui/widgets/error_location_permission.dart';
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
      print("#################### collectLatitudeLongitude");
      Position? lastPosition = await Geolocator.getLastKnownPosition();
      if (lastPosition != null) {
        print("#################### lastPosition $lastPosition");
      }
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
      // _getPositionEveryTime();
      _positionStreamSubscription?.cancel();
    } else if (state == AppLifecycleState.paused) {
      log('message');
      Geolocation.callPositionStream().then((value) => _positionStreamSubscription = value);
    }
  }

  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permissions are denied");
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      print("Location permissions are permanently denied, we cannot request permissions.");
      return false;
    }
    return true;
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
    return Obx(() {
      return Scaffold(
        body: !_appPermissionLocation
            ? ErrorLocationPermission(callback: validadePermission)
            : SingleChildScrollView(
                child: travelController.loadingCheckTravelInitialized
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
                              SizedBox(
                                height: context.height * 0.5,
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
                          ),
              ),
        floatingActionButton: travelController.existTravelInitialized == false
            ? null
            : FloatingActionButton.extended(
                label: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        var travel = travelController.travel;

                        setState(() {
                          floatExtended = false;
                        });

                        Get.toNamed('/supply', arguments: {
                          'travelId': travel.id,
                          'travelIdApi': travel.travelIdApi,
                        });
                      },
                      icon: const Icon(Icons.local_gas_station),
                      tooltip: 'Abastecimento',
                    ),
                  ],
                ),
                isExtended: floatExtended,
                icon: Icon(
                  floatExtended == true ? Icons.close : Icons.menu,
                  color: floatExtended == true ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    floatExtended = !floatExtended;
                  });
                },
                backgroundColor:
                    floatExtended == true ? Theme.of(context).primaryColor.withOpacity(.7) : context.theme.primaryColor,
              ),
      );
    });
  }
}
