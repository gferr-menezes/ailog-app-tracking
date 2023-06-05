import 'package:ailog_app_tracking/app/common/ui/widgets/custom_button.dart';
import 'package:ailog_app_tracking/app/common/ui/widgets/custom_loading.dart';
import 'package:ailog_app_tracking/app/common/ui/widgets/custom_text_form_field.dart';
import 'package:ailog_app_tracking/app/modules/travel/models/toll_model.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:validatorless/validatorless.dart';

import '../controllers/travel_controller.dart';

class TollList extends StatelessWidget {
  const TollList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final travelController = Get.find<TravelController>();
    final travel = travelController.travel;
    travelController.getTolls(travelId: travel.id!);
    final tolls = travelController.tolls;

    /**
     * create mask money
     */
    final moneyMask = CurrencyTextInputFormatter(
      locale: 'pt_BR',
      decimalDigits: 2,
      symbol: 'R\$',
    );

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
                                      value: {
                                        'action': 'show_map',
                                        'toll': toll,
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
                                    PopupMenuItem(
                                      value: {
                                        'action': 'change_value',
                                        'toll': toll,
                                      },
                                      child: Row(
                                        children: const [
                                          Icon(
                                            Icons.money,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text('Informar valor manualmente'),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: {
                                        'action': 'send_photo',
                                        'toll': toll,
                                      },
                                      child: Row(
                                        children: const [
                                          Icon(
                                            Icons.camera_alt_rounded,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text('Enviar foto do comprovante'),
                                        ],
                                      ),
                                    ),
                                    if (toll.urlVoucherImage != null)
                                      PopupMenuItem(
                                        value: {
                                          'action': 'show_ticket',
                                          'toll': toll,
                                        },
                                        child: Row(
                                          children: const [
                                            Icon(
                                              Icons.receipt_long,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text('Exibir comprovante'),
                                          ],
                                        ),
                                      ),
                                  ];
                                },
                                onSelected: (value) async {
                                  final action = value['action'] as String;
                                  final toll = value['toll'] as TollModel;

                                  if (action == 'show_map') {
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

                                  if (action == 'change_value') {
                                    TextEditingController valueTC = TextEditingController();
                                    final formKey = GlobalKey<FormState>();

                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          backgroundColor: Colors.transparent,
                                          insetPadding: const EdgeInsets.all(10),
                                          child: Container(
                                            width: double.infinity,
                                            color: Colors.white,
                                            height: 210,
                                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                                            child: Form(
                                              key: formKey,
                                              child: Column(
                                                children: [
                                                  CustomTextFormField(
                                                    validator: Validatorless.required('Informe o valor'),
                                                    keyboardType: TextInputType.number,
                                                    label: 'Informe o valor',
                                                    controller: valueTC,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter.digitsOnly,
                                                      moneyMask,
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  Obx(
                                                    () {
                                                      return Column(
                                                        children: [
                                                          CustomButtom(
                                                            label: 'Salvar',
                                                            loading: travelController.loadingInformValuePay,
                                                            onPressed: travelController.loadingInformValuePay == true
                                                                ? null
                                                                : () {
                                                                    if (formKey.currentState!.validate()) {
                                                                      FocusManager.instance.primaryFocus?.unfocus();
                                                                      travelController
                                                                          .informValuePay(toll, valueTC.text)
                                                                          .then((value) {
                                                                        /** close dialog with flutter */
                                                                        Future.delayed(
                                                                            const Duration(milliseconds: 800), () {
                                                                          Navigator.of(context).pop();
                                                                        });
                                                                      });
                                                                    }
                                                                  },
                                                            width: context.width,
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          CustomButtom(
                                                            width: context.width,
                                                            label: 'Cancelar',
                                                            color: Colors.grey,
                                                            onPressed: travelController.loadingInformValuePay
                                                                ? null
                                                                : () {
                                                                    Navigator.of(context).pop();
                                                                  },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }

                                  if (action == 'send_photo') {
                                    /** esperar usuario fechar e exceutar funcão */
                                    Get.toNamed(
                                      '/documents',
                                      arguments: {
                                        'toll': toll,
                                      },
                                    )!
                                        .then((value) {
                                      if (value != null) {
                                        travelController.getTolls(travelId: travel.id!);
                                      }
                                    });
                                  }

                                  if (action == 'show_ticket') {
                                    showDialog(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          backgroundColor: Colors.transparent,
                                          insetPadding: const EdgeInsets.all(10),
                                          child: Container(
                                            width: double.infinity,
                                            color: Colors.white,
                                            height: context.height * 0.8,
                                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                                            child: Image.network(
                                              toll.urlVoucherImage!,
                                              fit: BoxFit.contain,
                                              loadingBuilder: (context, child, loadingProgress) {
                                                if (loadingProgress == null) return child;
                                                return const Center(
                                                  child: CustomLoading(),
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                              title: Column(
                                children: [
                                  Row(
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
                                            const Text('Valor: '),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 5,
                                              ),
                                              child: Text(
                                                NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
                                                    .format(toll.valueTag),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: const [
                                            SizedBox.shrink(),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            const Text('Informado: '),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 5,
                                              ),
                                              child: Text(
                                                toll.valueInformed == null
                                                    ? ' - '
                                                    : NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
                                                        .format(toll.valueInformed),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
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
