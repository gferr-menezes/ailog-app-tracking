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
                        travelController.startTravel(plateEC.text);
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
