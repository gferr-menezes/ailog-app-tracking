import 'package:ailog_app_tracking/app/modules/travel/models/address_model.dart';
import 'package:ailog_app_tracking/app/modules/travel/models/occurence_vehicle_model.dart';
import 'package:ailog_app_tracking/app/modules/travel/models/occurrence_model.dart';
import 'package:ailog_app_tracking/app/modules/travel/models/rotogram_model.dart';
import 'package:ailog_app_tracking/app/modules/travel/models/toll_model.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../../common/ui/widgets/custom_app_bar.dart';
import '../../../common/ui/widgets/custom_loading.dart';
import '../controllers/geolocation_controller.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  MapType _currentMapType = MapType.normal;
  final CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();

  bool loadingMap = true;
  bool _infoWindowShown = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        loadingMap = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }

  @override
  Widget build(BuildContext context) {
    /**
   * get params from Get.toNamed('/travel/map', arguments: geoLocationData);
   */

    var argumentsPage = Get.arguments;

    AddressModel? address;
    TollModel? toll;
    OccurrenceModel? occurrence;
    RotogramModel? rotogram;
    double heightWindow = 120;
    OccurenceVehicleModel? occurenceVehicle;

    String? originPage;
    if (argumentsPage != null) {
      originPage = argumentsPage?['origin'];
    }

    final geolocationController = Get.find<GeolocationController>();
    final geolocations = geolocationController.geolocations;

    late List<LatLng> latLongList = [];

    print('argumentsPage: $argumentsPage');

    if (originPage == null ||
        originPage != 'address' &&
            originPage != 'toll_list' &&
            originPage != 'occurrence_list' &&
            originPage != 'rotogram' &&
            originPage != 'occurrence_vehicle_list') {
      for (var geolocation in geolocations) {
        latLongList.add(LatLng(geolocation.latitude, geolocation.longitude));
      }
    } else {
      if (originPage == 'address') {
        address = argumentsPage?['address_data'];
      }

      if (originPage == 'toll_list') {
        toll = argumentsPage?['toll_data'];
      }

      if (originPage == 'occurrence_list') {
        occurrence = argumentsPage?['occurrence_data'];
      }

      if (originPage == 'occurrence_vehicle_list') {
        occurenceVehicle = argumentsPage?['occurrence_vehicle_list'];
      }

      if (originPage == 'rotogram') {
        rotogram = argumentsPage?['rotogram_data'];
      }

      if (originPage == 'rotogram') {
        setState(() {
          if (rotogram?.informationPoint?.value != null && rotogram?.informationPoint?.value != 0) {
            heightWindow = 90;
          } else {
            heightWindow = 60;
          }
        });
      }

      latLongList.add(LatLng(argumentsPage?['latitude'], argumentsPage?['longitude']));
    }

    Widget button(final VoidCallback? function, IconData icon) {
      return FloatingActionButton(
        onPressed: function,
        materialTapTargetSize: MaterialTapTargetSize.padded,
        backgroundColor: context.theme.primaryColor,
        child: Icon(
          icon,
          size: 36.0,
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(),
      body: loadingMap == true
          ? const Center(
              child: CustomLoading(message: 'carregando mapa...'),
            )
          : Stack(
              children: [
                GoogleMap(
                  onTap: (argument) {
                    setState(() {
                      _infoWindowShown = false;
                    });
                    _customInfoWindowController.hideInfoWindow!();
                  },
                  initialCameraPosition: CameraPosition(
                    target: latLongList.last,
                    zoom: 16,
                  ),
                  mapType: _currentMapType,
                  markers: {
                    if (originPage == 'toll_list')
                      Marker(
                        markerId: const MarkerId("source"),
                        position: latLongList.first,
                        onTap: () {
                          setState(() {
                            _infoWindowShown = !_infoWindowShown;
                          });

                          if (_infoWindowShown == true) {
                            _customInfoWindowController.addInfoWindow!(
                                Container(
                                  padding: const EdgeInsets.only(top: 10),
                                  height: 300,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: 300,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 20,
                                              child: Text(
                                                '${toll?.tollName.toUpperCase()}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                              child: Text(
                                                NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
                                                    .format(toll?.valueTag ?? 0),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                latLongList.first);
                          } else {
                            _customInfoWindowController.hideInfoWindow!();
                            setState(() {
                              _infoWindowShown = !_infoWindowShown;
                            });
                          }
                        },
                      ),
                    if (originPage == 'address')
                      Marker(
                        markerId: const MarkerId("source"),
                        position: latLongList.first,
                        onTap: () {
                          setState(() {
                            _infoWindowShown = !_infoWindowShown;
                          });

                          if (_infoWindowShown == true) {
                            _customInfoWindowController.addInfoWindow!(
                                Container(
                                  padding: const EdgeInsets.only(top: 10),
                                  height: 100,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: 300,
                                        child: Column(
                                          children: [
                                            address?.typeOperation != null
                                                ? SizedBox(
                                                    height: 20,
                                                    child: Text(
                                                      '${address!.typeOperation?.toUpperCase()}',
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox.shrink(),
                                            SizedBox(
                                              height: 20,
                                              child: Text(
                                                getTextAddress(address),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            address?.client?.name != null
                                                ? SizedBox(
                                                    height: 20,
                                                    child: Text(
                                                      'CLIENTE: ${address?.client?.name.toUpperCase()}',
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox.shrink(),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                latLongList.first);
                          } else {
                            _customInfoWindowController.hideInfoWindow!();
                            setState(() {
                              _infoWindowShown = !_infoWindowShown;
                            });
                          }
                        },
                      ),
                    if (originPage == 'occurrence_list')
                      Marker(
                        markerId: const MarkerId("source"),
                        position: latLongList.first,
                        onTap: () {
                          setState(() {
                            _infoWindowShown = !_infoWindowShown;
                          });

                          if (_infoWindowShown == true) {
                            _customInfoWindowController.addInfoWindow!(
                                Container(
                                  padding: const EdgeInsets.only(top: 10),
                                  height: 300,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: 300,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 20,
                                              child: Text(
                                                '${occurrence!.typeOccurrence.description?.toUpperCase()}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            occurrence.client != null
                                                ? SizedBox(
                                                    height: 20,
                                                    child: Text(
                                                      'CLIENTE: ${occurrence?.client?.name.toUpperCase()}',
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox.shrink(),
                                            SizedBox(
                                              height: 20,
                                              child: Text(getTextAddress(occurrence.address)),
                                            ),
                                            SizedBox(
                                              height: 20,
                                              child: Text(
                                                DateFormat('dd/MM/yyyy HH:mm').format(occurrence.dateHour),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                latLongList.first);
                          } else {
                            setState(() {
                              _infoWindowShown = false;
                            });
                            _customInfoWindowController.hideInfoWindow!();
                          }
                        },
                      ),
                    if (originPage == 'occurrence_vehicle_list')
                      Marker(
                        markerId: const MarkerId("source"),
                        position: latLongList.first,
                        onTap: () {
                          setState(() {
                            _infoWindowShown = !_infoWindowShown;
                          });

                          if (_infoWindowShown == true) {
                            _customInfoWindowController.addInfoWindow!(
                                Container(
                                  padding: const EdgeInsets.only(top: 10),
                                  height: 300,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: 300,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 20,
                                              child: Text(
                                                '${occurenceVehicle!.description?.toUpperCase()}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                              child: Text(
                                                DateFormat('dd/MM/yyyy HH:mm').format(occurenceVehicle.dateOccurrence!),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                latLongList.first);
                          } else {
                            setState(() {
                              _infoWindowShown = false;
                            });
                            _customInfoWindowController.hideInfoWindow!();
                          }
                        },
                      ),
                    if (originPage == 'rotogram')
                      Marker(
                        markerId: const MarkerId("source"),
                        position: latLongList.first,
                        onTap: () {
                          setState(() {
                            _infoWindowShown = !_infoWindowShown;
                          });

                          if (_infoWindowShown == true) {
                            _customInfoWindowController.addInfoWindow!(
                                Container(
                                  height: 100,
                                  width: 250,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '${rotogram!.description?.toUpperCase()}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      rotogram.informationPoint?.value == null || rotogram.informationPoint?.value == 0
                                          ? const SizedBox.shrink()
                                          : Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text('Valor: R\$ ${rotogram.informationPoint?.value ?? 0}')),
                                    ],
                                  ),
                                ),
                                latLongList.first);
                          } else {
                            setState(() {
                              _infoWindowShown = false;
                            });
                            _customInfoWindowController.hideInfoWindow!();
                          }
                        },
                      ),
                    if (originPage != 'address' &&
                        originPage != 'toll_list' &&
                        originPage != 'occurrence_list' &&
                        originPage != 'rotogram' &&
                        originPage != 'occurrence_vehicle_list')
                      Marker(
                        markerId: const MarkerId("source"),
                        position: latLongList.first,
                        infoWindow: InfoWindow(
                          title: 'Origem',
                          snippet: 'Lat: ${latLongList.first.latitude} - Long: ${latLongList.first.longitude}',
                        ),
                      ),
                    if (originPage != 'address' &&
                        originPage != 'toll_list' &&
                        originPage != 'occurrence_list' &&
                        originPage != 'rotogram' &&
                        originPage != 'occurrence_vehicle_list')
                      Marker(
                        markerId: const MarkerId("destination"),
                        position: latLongList.last,
                        infoWindow: InfoWindow(
                          title: 'Destino',
                          snippet: 'Lat: ${latLongList.last.latitude} - Long: ${latLongList.last.longitude}',
                        ),
                      ),
                  },
                  polylines: {
                    Polyline(
                      polylineId: const PolylineId("route"),
                      points: latLongList,
                      color: const Color(0xFF7B61FF),
                      width: 6,
                    ),
                  },
                  onMapCreated: (mapController) {
                    _customInfoWindowController.googleMapController = mapController;
                  },
                  onCameraMove: (position) {
                    _customInfoWindowController.onCameraMove!();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Column(
                      children: <Widget>[
                        button(_onMapTypeButtonPressed, Icons.map),
                        const SizedBox(
                          height: 16.0,
                        ),
                      ],
                    ),
                  ),
                ),
                CustomInfoWindow(controller: _customInfoWindowController, height: heightWindow, width: 250, offset: 20)
              ],
            ),
    );
  }

  String getTextAddress(AddressModel? address) {
    String textAddress = '';

    if (address != null) {
      if (address.address != null) {
        if (address.address != null && address.address != '') {
          textAddress =
              '${address.address?.toUpperCase()}, ${address.number} - ${address.city}, ${address.city.toUpperCase()} - ${address.state.toUpperCase()}';
        } else {
          textAddress = '${address.city.toUpperCase()} - ${address.state.toUpperCase()}';
        }
      } else {
        textAddress = '${address.city.toUpperCase()} - ${address.state.toUpperCase()}';
      }
    }

    return textAddress;
  }
}
