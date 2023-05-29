import 'dart:developer';

import 'package:ailog_app_tracking/app/common/geolocation.dart';
import 'package:ailog_app_tracking/app/common/ui/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/geolocation_controller.dart';
import '../controllers/travel_controller.dart';
import '../models/travel_model.dart';

class SelectTravel {
  show(List<TravelModel> travels) {
    var travelController = Get.find<TravelController>();
    var geolocationController = Get.find<GeolocationController>();
    String selectedTravel = '';

    showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      context: Get.context!,
      builder: (builder) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Container(
              height: context.height * 0.4,
              color: Colors.white,
              child: Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Selecione uma viagem para iniciar',
                    style: context.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold, color: context.theme.primaryColorDark, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: travels.length,
                      itemBuilder: (context, index) {
                        var travel = travels[index];
                        var dateInitTravel = travel.estimatedDeparture;
                        String cityOrigin = travels[index].addresses?[0].city ?? '';
                        String cityDestiny = travels[index].addresses?[travels[index].addresses!.length - 1].city ?? '';

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20, top: 10),
                          child: RadioListTile(
                            value: travels[index].travelIdApi,
                            groupValue: selectedTravel,
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Data: ${DateFormat('dd/MM/yyyy HH:mm').format(dateInitTravel!)}',
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 5),
                                ),
                                Text(
                                  'Origem: ${cityOrigin.toUpperCase()}',
                                ),
                              ],
                            ),
                            subtitle: Text('Destino: ${cityDestiny.toUpperCase()}'),
                            onChanged: (val) {
                              setState(() {
                                selectedTravel = val!;
                              });
                            },
                            activeColor: Colors.green,
                            selected: false,
                          ),
                        );
                      },
                    ),
                  ),
                  CustomButtom(
                    label: 'Iniciar viagem selecionada',
                    onPressed: selectedTravel == ""
                        ? null
                        : () {
                            final travelSelected =
                                travels.firstWhere((element) => element.travelIdApi == selectedTravel);

                            travelController
                                .startTravel(plate: travelSelected.plate!, travelIdApi: travelSelected.travelIdApi)
                                .then((value) {
                              Navigator.pop(context);
                              Geolocation.getCurrentPosition().then((value) {
                                if (value != null) {
                                  travelController.checkTravelInitialized();
                                  geolocationController.collectLatitudeLongitude(value);
                                  travelController.loadingStartingTravel = false;
                                }
                              });
                            });
                          },
                    width: context.width,
                    height: 50,
                  ),
                ],
              ),
            ).paddingOnly(top: 32);
          },
        );
      },
    );
  }
}
