import 'dart:developer';

import 'package:ailog_app_tracking/app/common/ui/widgets/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/travel_controller.dart';

class TollList extends StatelessWidget {
  const TollList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final travelController = Get.find<TravelController>();
    final travel = travelController.travel;
    travelController.getTolls(travelId: travel.id!);
    final tolls = travelController.tolls;

    return Obx(
      () => travelController.loadingGetTolls
          ? const CustomLoading()
          : tolls.isEmpty
              ? const SizedBox()
              : ListView.builder(
                  itemCount: tolls.length,
                  itemBuilder: (context, index) {
                    final toll = tolls[index];

                    return Card(
                      elevation: 2,
                      child: SizedBox(
                        height: 90,
                        child: Column(
                          children: [
                            const Padding(padding: EdgeInsets.symmetric(vertical: 3)),
                            Text(
                              toll.tollName.toString().toUpperCase(),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Divider(),
                            ListTile(
                              trailing: PopupMenuButton(
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem(
                                      value: 'show_map',
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
                                onSelected: (String value) {
                                  if (value == 'show_map') {
                                    if (toll.latitude != null && toll.longitude != null) {
                                      Get.toNamed(
                                        '/travel/map',
                                        arguments: {
                                          'latitude': toll.latitude,
                                          'longitude': toll.longitude,
                                          'origin': 'toll_list',
                                        },
                                      );
                                    }
                                  }
                                },
                              ),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        const Text('Data passagem: '),
                                        Text(toll.datePassage != null
                                            ? DateFormat('dd/MM/yyyy HH:mm').format(toll.datePassage as DateTime)
                                            : ' - '),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        const Text('Valor TAG: '),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 5,
                                          ),
                                          child: Text(
                                            NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(toll.valueTag),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              dense: true,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
