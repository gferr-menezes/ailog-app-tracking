import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  bool loadingMap = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        loadingMap = false;
      });
    });
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

    log(argumentsPage.toString());

    String? originPage;
    if (argumentsPage != null) {
      originPage = argumentsPage?['origin'];
    }

    final geolocationController = Get.find<GeolocationController>();
    final geolocations = geolocationController.geolocations;

    late List<LatLng> latLongList = [];

    if (originPage == null || originPage != 'address' && originPage != 'toll_list') {
      for (var geolocation in geolocations) {
        latLongList.add(LatLng(geolocation.latitude, geolocation.longitude));
      }
    } else {
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
                  initialCameraPosition: CameraPosition(
                    target: latLongList.last,
                    zoom: 16,
                  ),
                  mapType: _currentMapType,
                  markers: {
                    Marker(
                      markerId: const MarkerId("source"),
                      position: latLongList.first,
                      infoWindow: InfoWindow(
                        title: 'Origem',
                        snippet: 'Lat: ${latLongList.first.latitude} - Long: ${latLongList.first.longitude}',
                      ),
                    ),
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
                    //  mapController.showMarkerInfoWindow(const MarkerId("source"));

                    //_controller.complete(mapController);
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
              ],
            ),
    );
  }
}
