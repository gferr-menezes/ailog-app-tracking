import 'package:ailog_app_tracking/app/common/ui/widgets/custom_loading.dart';
import 'package:ailog_app_tracking/app/modules/travel/models/geolocation_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../common/ui/widgets/not_found.dart';
import '../controllers/geolocation_controller.dart';
import '../controllers/travel_controller.dart';

class LatLongList extends StatefulWidget {
  const LatLongList({Key? key}) : super(key: key);

  @override
  State<LatLongList> createState() => _LatLongListState();
}

class _LatLongListState extends State<LatLongList> {
  final GeolocationController geolocationController = Get.find<GeolocationController>();
  final TravelController travelController = Get.find<TravelController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var travel = travelController.travel;
      var checkTravelInitialized = travelController.existTravelInitialized;

      if (checkTravelInitialized) {
        geolocationController.getGelocations(travelId: travel.id!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        var latLongList = geolocationController.geolocations;
        // log('latLongList: $latLongList');

        var latLongSorted = latLongList.toList();
        latLongSorted.sort((a, b) => b.id!.compareTo(a.id!));

        return latLongList.isEmpty
            ? const Center(
                child: NotFound(
                  message: 'Nada encontrado por aqui!',
                ),
              )
            : SizedBox(
                child: geolocationController.loadingGeolocations
                    ? const Center(
                        child: CustomLoading(),
                      )
                    : ListView.builder(
                        itemCount: latLongSorted.length,
                        itemBuilder: (context, index) {
                          final geoLocationData = latLongSorted[index];
                          return Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed('/travel/map', arguments: geoLocationData);
                                  },
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.location_on,
                                      size: 50,
                                      color: geoLocationData.statusSendApi == StatusSendApi.sended.name
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                    title: Text('Latitude: ${geoLocationData.latitude}'),
                                    subtitle: Text('Longitude: ${geoLocationData.longitude}'),
                                    trailing: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        const Text('Coletado em:'),
                                        Text(
                                          DateFormat('dd/MM/yyyy HH:mm').format(geoLocationData.collectionDate),
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
              );
      },
    );
  }
}
