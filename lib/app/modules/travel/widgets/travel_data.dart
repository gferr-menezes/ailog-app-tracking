import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../common/ui/widgets/dialog_confirm.dart';
import '../controllers/travel_controller.dart';

class TravelData extends StatelessWidget {
  const TravelData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var travelController = Get.find<TravelController>();
    var travel = travelController.travel;

    return Card(
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(
      //     10.0,
      //   ),
      // ),
      color: Colors.white,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('CODIGO DA VIAGEM'),
                  Text(
                    travel.code == null ? ' # ' : ' - ${travel.code}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: context.width * 0.45,
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 44,
                          child: Text('Placa:', style: TextStyle(fontSize: 15)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Text(
                            travel.plate.toString().toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        const Text('TAG:', style: TextStyle(fontSize: 15)),
                        Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: SizedBox(
                            width: 90,
                            child: Text(
                              travel.vpoEmitName == null ? ' - ' : travel.vpoEmitName.toString().toUpperCase(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15, overflow: TextOverflow.ellipsis),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: context.width * 0.45,
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 40,
                          child: Text('Inicio:', style: TextStyle(fontSize: 15)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: travel.estimatedDeparture != null
                              ? Text(
                                  DateFormat('dd/MM/yy HH:mm').format(travel.estimatedDeparture!),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                )
                              : const Text(' - '),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        const Text('Fim:', style: TextStyle(fontSize: 15)),
                        Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: SizedBox(
                            width: 120,
                            child: travel.estimatedArrival == null
                                ? const Text(' - ')
                                : Text(
                                    DateFormat('dd/MM/yy HH:mm').format(travel.estimatedArrival!),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: context.width * 0.45,
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 73,
                          child: Text('Pedágios:', style: TextStyle(fontSize: 15)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Text(
                            '${travel.tolls?.length ?? 0}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        const Text('Total:', style: TextStyle(fontSize: 15)),
                        Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: SizedBox(
                            width: 90,
                            child: Text(
                              NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(travel.valueTotal),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15, overflow: TextOverflow.ellipsis),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: context.width * 0.18,
                    child: const Text('Origem:', style: TextStyle(fontSize: 15)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: SizedBox(
                      width: context.width * 0.6,
                      child: Text(
                        travel.addresses?.first.city == null
                            ? ' - '
                            : travel.addresses!.first.city.toString().toUpperCase(),
                        style:
                            const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: context.width * 0.18,
                    child: const Text('Destino:', style: TextStyle(fontSize: 15)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: SizedBox(
                      width: context.width * 0.6,
                      child: Text(
                        travel.addresses?.last.city == null
                            ? ' - '
                            : travel.addresses!.last.city.toString().toUpperCase(),
                        style:
                            const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: context.theme.primaryColor,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Get.dialog(
                      barrierDismissible: false,
                      DialogConfirm(
                        title: 'FINALIZAR VIAGEM',
                        content: 'Deseja finalizar a viagem?',
                        textButton: 'Finalizar',
                        onPressed: () {
                          travelController.finishTravel();
                          Get.back();
                        },
                      ),
                    );
                  },
                  child: SizedBox(
                    width: context.width,
                    height: 45,
                    child: const Center(
                      child: Text(
                        'Finalizar viagem',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
