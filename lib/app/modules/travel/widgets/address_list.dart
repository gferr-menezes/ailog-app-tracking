import 'dart:developer';

import 'package:ailog_app_tracking/app/common/ui/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../common/ui/widgets/custom_loading.dart';
import '../controllers/travel_controller.dart';

class AddressList extends StatefulWidget {
  const AddressList({Key? key}) : super(key: key);

  @override
  State<AddressList> createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {
  var travelController = Get.find<TravelController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var travel = travelController.travel;
      var checkTravelInitialized = travelController.existTravelInitialized;

      if (checkTravelInitialized) {
        travelController.getAddresses(travelId: travel.id!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Obx(
        () {
          var addresses = travelController.addresses;

          return travelController.loadingGetAddresses
              ? const CustomLoading()
              : addresses.isEmpty
                  ? const SizedBox.shrink()
                  : ListView.builder(
                      itemBuilder: (context, index) {
                        final address = addresses[index];
                        return Card(
                          child: Column(
                            children: [
                              ListTile(
                                leading: GestureDetector(
                                  child: CircleAvatar(
                                    child: Text(address.passOrder.toString()),
                                  ),
                                  onTap: () {
                                    if (address.latitude != null && address.longitude != null) {
                                      Get.toNamed(
                                        '/travel/map',
                                        arguments: {
                                          'latitude': address.latitude,
                                          'longitude': address.longitude,
                                          'origin': 'address',
                                        },
                                      );
                                    }
                                  },
                                ),
                                title: Text(
                                  address.address == null ? 'Sem endereço' : address.address!.toUpperCase(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text('${address.city.toUpperCase()} - ${address.state.toUpperCase()}'),
                                trailing: IconButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                      ),
                                      context: Get.context!,
                                      builder: (builder) {
                                        return StatefulBuilder(
                                          builder: (BuildContext context, void Function(void Function()) setState) {
                                            return SizedBox(
                                              height: 200,
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(left: 10, top: 20, right: 5, bottom: 0),
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(bottom: 0),
                                                          child: Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              SizedBox(
                                                                width: context.width * 0.25,
                                                                child: const Text('ENDEREÇO: '),
                                                              ),
                                                              SizedBox(
                                                                width: context.width * 0.7,
                                                                child: Text(
                                                                  address.address == null
                                                                      ? ' - '
                                                                      : (address.neighborhood != null
                                                                          ? '${address.address!.toUpperCase()} - ${address.neighborhood!.toUpperCase()}'
                                                                          : ' - '),
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: const TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const Divider(),
                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 10),
                                                          child: Row(
                                                            children: [
                                                              SizedBox(
                                                                width: context.width * 0.25,
                                                                child: const Text('CIDADE: '),
                                                              ),
                                                              SizedBox(
                                                                width: context.width * 0.7,
                                                                child: Text(
                                                                  '${address.city.toUpperCase()} - ${address.state.toUpperCase()}',
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: const TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const Divider(),
                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 10),
                                                          child: Row(
                                                            children: [
                                                              SizedBox(
                                                                width: context.width * 0.25,
                                                                child: const Text('CLIENTE: '),
                                                              ),
                                                              SizedBox(
                                                                width: context.width * 0.7,
                                                                child: Text(
                                                                  address.client == null
                                                                      ? ' - '
                                                                      : address.client!.name.toUpperCase(),
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: const TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Padding(
                                                    padding: const EdgeInsets.only(bottom: 10),
                                                    child: CustomButtom(
                                                      width: context.width * 0.95,
                                                      label: 'Ver no mapa',
                                                      onPressed: () {
                                                        /** close showModalBottomSheet */
                                                        Navigator.of(context).pop();

                                                        Get.toNamed(
                                                          '/travel/map',
                                                          arguments: {
                                                            'latitude': address.latitude,
                                                            'longitude': address.longitude,
                                                            'origin': 'address',
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                            ///////////
                                          },
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.more_vert),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20, bottom: 10),
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 55,
                                      child: Text('Partida:'),
                                    ),
                                    SizedBox(
                                      width: context.width * 0.3,
                                      child: address.realDeparture != null
                                          ? Text(
                                              DateFormat('dd/MM/yyyy HH:mm').format(address.realDeparture as DateTime))
                                          : const Text(' - '),
                                    ),
                                    const SizedBox(
                                      width: 65,
                                      child: Text('Chegada:'),
                                    ),
                                    SizedBox(
                                      width: context.width * 0.25,
                                      child: address.realDeparture != null
                                          ? Text(
                                              DateFormat('dd/MM/yyyy HH:mm').format(address.realDeparture as DateTime))
                                          : const Text(' - '),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                      itemCount: addresses.length,
                    );
        },
      ),
    );
  }
}
