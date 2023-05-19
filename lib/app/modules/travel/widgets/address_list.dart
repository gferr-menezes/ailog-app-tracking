import 'package:ailog_app_tracking/app/common/ui/widgets/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
              : ListView.builder(
                  itemBuilder: (context, index) {
                    final address = addresses[index];
                    return Card(
                      child: Column(children: [
                        ListTile(
                          leading: CircleAvatar(
                            child: Text(address.passOrder.toString()),
                          ),
                          title: Text(
                            address.address == null ? 'Sem endereço' : address.address!.toUpperCase(),
                          ),
                          subtitle: Text('${address.city.toUpperCase()} - ${address.state.toUpperCase()}'),
                          trailing: IconButton(
                            onPressed: () {},
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
                                    ? Text(DateFormat('dd/MM/yyyy HH:mm').format(address.realDeparture as DateTime))
                                    : const Text(' - '),
                              ),
                              const SizedBox(
                                width: 65,
                                child: Text('Chegada:'),
                              ),
                              SizedBox(
                                width: context.width * 0.3,
                                child: address.realDeparture != null
                                    ? Text(DateFormat('dd/MM/yyyy HH:mm').format(address.realDeparture as DateTime))
                                    : const Text(' - '),
                              )
                            ],
                          ),
                        )
                      ]),
                    );
                  },
                  itemCount: addresses.length,
                );
        },
      ),
    );
  }
}
