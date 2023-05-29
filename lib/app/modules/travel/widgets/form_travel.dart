import 'dart:developer';

//import 'package:ailog_app_tracking/app/common/geolocation.dart';
import 'package:ailog_app_tracking/app/modules/travel/controllers/geolocation_controller.dart';
import 'package:ailog_app_tracking/app/modules/travel/widgets/select_travel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:validatorless/validatorless.dart';

import '../../../common/ui/widgets/custom_button.dart';
import '../../../common/ui/widgets/custom_text_form_field.dart';
import '../controllers/travel_controller.dart';

class FormTravel extends StatelessWidget {
  const FormTravel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final plateEC = TextEditingController();
    final TravelController travelController = Get.find<TravelController>();
    final GeolocationController geolocationController = Get.find<GeolocationController>();

    //plateEC.text = 'DOO-8946';
    plateEC.text = 'XYZ2044';

    return Form(
      key: formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          CustomTextFormField(
            label: 'Informe a placa',
            controller: plateEC,
            validator: Validatorless.multiple([
              Validatorless.required('Informe a placa'),
              Validatorless.min(7, 'Placa inválida'),
            ]),
          ),
          const SizedBox(
            height: 10,
          ),
          Obx(
            () => CustomButtom(
              label: travelController.existTravelInitialized ? 'Viagem em andamento' : 'Iniciar viagem',
              loading: travelController.loadingStartingTravel,
              onPressed: travelController.loadingStartingTravel
                  ? null
                  : () {
                      if (formKey.currentState!.validate()) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        travelController.startTravel(plate: plateEC.text).then((value) {
                          if (value == null) {
                            travelController.checkTravelInitialized().then((value) {}).whenComplete(() {
                              travelController.loadingStartingTravel = false;
                              // Geolocation.getCurrentPosition().then((value) {
                              //   if (value != null) {
                              //     geolocationController.collectLatitudeLongitude(value);
                              //     geolocationController.sendGeolocationsPending();
                              //   }
                              // });
                            });
                          } else {
                            if (value.length > 1) {
                              travelController.loadingStartingTravel = false;
                              SelectTravel().show(value);
                            }
                          }
                        });
                      }
                    },
              width: context.width,
              height: 50,
            ),
          ),
        ],
      ),
    );
  }
}
