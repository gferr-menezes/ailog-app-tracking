import 'package:ailog_app_tracking/app/common/ui/widgets/custom_loading.dart';
import 'package:ailog_app_tracking/app/modules/travel/controllers/travel_controller.dart';
import 'package:ailog_app_tracking/app/modules/travel/models/rotogram_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RotogramPage extends StatelessWidget {
  const RotogramPage({super.key});

  @override
  Widget build(BuildContext context) {
    TravelController travelController = Get.find<TravelController>();
    final travel = travelController.travel;

    final List<RotogramModel> rotograms = [];

    travelController.getRotograms(travelId: travel.id!).then((value) {
      if (value != null) {
        rotograms.addAll(value);
      }
    });

    return SizedBox.expand(
      child: Obx(
        () => travelController.loadingGetRotograms == true
            ? const Center(child: CustomLoading())
            : ListView.builder(
                itemBuilder: (context, index) {
                  final rotogram = rotograms[index];

                  return Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: index == 0
                              ? const Icon(Icons.location_on, color: Colors.green, size: 30)
                              : Image.network(rotogram.urlIcon ?? '', fit: BoxFit.cover),
                          title: Text(
                            rotogram.description?.toUpperCase() ?? ' - ',
                            style: const TextStyle(fontSize: 13),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 2),
                                Text('Distância: ${rotogram.distanceTraveledKm?.toString()} km'),
                                const SizedBox(height: 5),
                                Text('Tempo: ${rotogram.distanceTraveledFormatted?.toString()} hrs'),
                              ],
                            ),
                          ),
                          trailing: PopupMenuButton(
                            icon: const Icon(Icons.more_vert),
                            onOpened: () {
                              travelController.popMenuTollIsVisible.value = true;
                            },
                            onCanceled: () {
                              travelController.popMenuTollIsVisible.value = false;
                            },
                            itemBuilder: (context) {
                              travelController.contextPopMenu = context;

                              return [
                                PopupMenuItem(
                                  value: {
                                    'action': 'show_map',
                                    'rotogram': rotogram,
                                  },
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.map,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text('Exibir no mapa'),
                                    ],
                                  ),
                                ),
                              ];
                            },
                            onSelected: (value) {
                              if (value['action'] == 'show_map') {
                                Get.toNamed(
                                  '/travel/map',
                                  arguments: {
                                    'rotogram_data': rotogram,
                                    'origin': 'rotogram',
                                    'latitude': rotogram.latLng!.latitude,
                                    'longitude': rotogram.latLng!.longitude,
                                  },
                                );
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  );
                },
                itemCount: rotograms.length,
              ),
      ),
    );
  }
}
