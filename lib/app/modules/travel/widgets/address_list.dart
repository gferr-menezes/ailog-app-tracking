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
                  : SizedBox.expand(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          final address = addresses[index];
                          return Card(
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: GestureDetector(
                                      child: CircleAvatar(
                                        backgroundColor: Colors.indigo,
                                        child: Text(
                                          address.passOrder.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        if (address.latitude != null && address.longitude != null) {
                                          Get.toNamed(
                                            '/travel/map',
                                            arguments: {
                                              'latitude': address.latitude,
                                              'longitude': address.longitude,
                                              'origin': 'address',
                                              'address_data': address,
                                            },
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        address.typeOperation?.toUpperCase() ?? ' - ',
                                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                      ),
                                      address.client == null
                                          ? const SizedBox.shrink()
                                          : Text(
                                              address.client?.name.toUpperCase() ?? '',
                                              style: const TextStyle(fontSize: 13),
                                            ),
                                      Text(
                                        '${address.city.toUpperCase()} - ${address.state.toUpperCase()}',
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                      address.address == null
                                          ? const SizedBox.shrink()
                                          : Text(
                                              address.address == null ? '' : address.address!.toUpperCase(),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                    ],
                                  ),
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
                                                height: 300,
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
                                                    Obx(
                                                      () {
                                                        return Padding(
                                                          padding: const EdgeInsets.only(bottom: 10),
                                                          child: CustomButtom(
                                                            loading: travelController.loadingRegisterActionClient,
                                                            color: Colors.indigo,
                                                            width: context.width * 0.95,
                                                            label: address.realArrival == null
                                                                ? 'Registrar chegada no cliente'
                                                                : 'Registrar saída do cliente',
                                                            onPressed: address.realArrival != null &&
                                                                    address.realDeparture != null
                                                                ? null
                                                                : travelController.loadingRegisterActionClient
                                                                    ? null
                                                                    : () async {
                                                                        final travel = travelController.travel;
                                                                        if (address.realArrival == null) {
                                                                          await travelController.registerArrivalClient(
                                                                            travel,
                                                                            address,
                                                                          );
                                                                        } else {
                                                                          await travelController
                                                                              .registerDepartureClient(
                                                                            travel,
                                                                            address,
                                                                          );
                                                                        }
                                                                        await travelController.getAddresses(
                                                                            travelId: travel.id!);
                                                                        Get.back();
                                                                      },
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(bottom: 10),
                                                      child: CustomButtom(
                                                        color: Colors.grey,
                                                        width: context.width * 0.95,
                                                        label: 'Registrar ocorrência',
                                                        onPressed: () {
                                                          final travel = travelController.travel;
                                                          /** close showModalBottomSheet */
                                                          Navigator.of(context).pop();

                                                          Get.toNamed(
                                                            '/travel/occurrences',
                                                            arguments: {
                                                              'travel': travel,
                                                              'address': address,
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    ),
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
                                                              'address_data': address,
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
                                    padding: const EdgeInsets.only(left: 1, bottom: 10, right: 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                SizedBox(
                                                  width: context.width * 0.30,
                                                  child: const Text(
                                                    'PREV. CHEGADA',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 105,
                                                  child: address.estimatedArrival != null
                                                      ? Padding(
                                                          padding: const EdgeInsets.only(left: 5),
                                                          child: Text(
                                                            DateFormat('dd/MM/yy HH:mm')
                                                                .format(address.estimatedArrival as DateTime),
                                                          ),
                                                        )
                                                      : const Center(
                                                          child: Text(' - '),
                                                        ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                const SizedBox(
                                                  width: 100,
                                                  child: Text(
                                                    'PREV. SAIDA',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  child: address.estimatedDeparture != null
                                                      ? Text(DateFormat('dd/MM/yy HH:mm')
                                                          .format(address.estimatedDeparture as DateTime))
                                                      : const Center(
                                                          child: Text(' - '),
                                                        ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                const SizedBox(
                                                  width: 65,
                                                  child: Text(
                                                    'CHEGADA',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 105,
                                                  child: address.realArrival != null
                                                      ? Padding(
                                                          padding: const EdgeInsets.only(left: 5),
                                                          child: Text(
                                                            DateFormat('dd/MM/yy HH:mm')
                                                                .format(address.realArrival as DateTime),
                                                          ),
                                                        )
                                                      : const Center(
                                                          child: Text(' - '),
                                                        ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                const SizedBox(
                                                  width: 100,
                                                  child: Text(
                                                    'SAIDA',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  child: address.realDeparture != null
                                                      ? Text(DateFormat('dd/MM/yy HH:mm')
                                                          .format(address.realDeparture as DateTime))
                                                      : const Center(
                                                          child: Text(' - '),
                                                        ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                          );
                        },
                        itemCount: addresses.length,
                      ),
                    );
        },
      ),
    );
  }
}
