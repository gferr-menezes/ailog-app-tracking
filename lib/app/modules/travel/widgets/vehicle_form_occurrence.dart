import 'dart:io';

import 'package:ailog_app_tracking/app/common/ui/widgets/custom_button.dart';
import 'package:ailog_app_tracking/app/common/ui/widgets/custom_drop_down.dart';
import 'package:ailog_app_tracking/app/modules/travel/models/address_model.dart';
import 'package:ailog_app_tracking/app/modules/travel/models/occurrence_model.dart';
import 'package:ailog_app_tracking/app/modules/travel/models/travel_model.dart';
import 'package:ailog_app_tracking/app/modules/travel/models/type_occurence_model.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:validatorless/validatorless.dart';

import '../../../common/ui/widgets/custom_text_form_field.dart';
import '../controllers/ocurrence_controller.dart';
import '../models/occurence_vehicle_model.dart';

class VehicleFormOccurrence extends StatefulWidget {
  final TravelModel? travel;

  const VehicleFormOccurrence({super.key, required this.travel});

  @override
  State<VehicleFormOccurrence> createState() => _VehicleFormOccurrenceState();
}

class _VehicleFormOccurrenceState extends State<VehicleFormOccurrence> {
  final _occurrenceController = Get.find<OcurrenceController>();
  final _formKey = GlobalKey<FormState>();

  List<DropdownMenuItem<String>> dropdownItems = const [];
  List<TypeOccurenceModel> typeOccurences = [];

  final _descriptionEC = TextEditingController();
  String? travelApiId;
  TravelModel? travel;
  AddressModel? address;
  List<XFile> imageContainers = [];

  bool lateTravel = false;
  bool endTravel = false;
  bool endPassagePoint = false;

  @override
  void initState() {
    super.initState();
    travelApiId = widget.travel!.travelIdApi;
    travel = widget.travel;
    _occurrenceController.loadingSavingOccurrence = false;
    _getTypesOcurrencies();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 10,
          ),
          CustomTextFormField(
            label: 'Descrição',
            controller: _descriptionEC,
            validator: Validatorless.required('campo obrigatório'),
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            children: [
              imageContainers.isEmpty
                  ? const SizedBox.shrink()
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.105,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: imageContainers.length,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Card(
                                color: Colors.grey.withAlpha(1),
                                child: Stack(
                                  children: [
                                    Image.file(
                                      File(imageContainers[index].path),
                                      fit: BoxFit.fill,
                                      width: MediaQuery.of(context).size.width * 0.3,
                                    ),
                                    Positioned(
                                      top: -10,
                                      right: -10,
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            imageContainers.removeAt(index);
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          );
                        },
                      ),
                    ),
              IconButton(
                onPressed: () async {
                  //Get.toNamed('/travel/occurrences/photo');
                  var images = await Get.toNamed('/travel/occurrences/photo');
                  if (images != null) {
                    images = images as List<XFile>;
                  }
                  // imageContainers = images as List<XFile>;
                  setState(() {
                    images.forEach((element) {
                      imageContainers.add(element);
                    });
                  });
                },
                icon: const Icon(Icons.camera_alt),
              ),
              const Text('Adicionar foto(s)'),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Obx(
            () => CustomButtom(
              loading: _occurrenceController.loadingSavingOccurrence == true ? true : false,
              label: 'Salvar',
              onPressed: _occurrenceController.loadingSavingOccurrence == true
                  ? null
                  : () async {
                      if (_formKey.currentState!.validate()) {
                        _occurrenceController.loadingSavingOccurrence = true;
                        final List<String> urlPhotos = [];
                        final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

                        final OccurenceVehicleModel occurence = OccurenceVehicleModel(
                          description: _descriptionEC.text,
                          dateOccurrence: DateTime.now(),
                          urlPhotos: null,
                          latitude: position.latitude,
                          longitude: position.longitude,
                        );

                        for (var image in imageContainers) {
                          final result = await _occurrenceController.uploadImagesOccurrence(
                              image: File(image.path).readAsBytesSync(), travelIdApi: travelApiId!);
                          urlPhotos.add(result);
                        }
                        occurence.urlPhotos = urlPhotos;

                        await _occurrenceController.saveOccurrenceVehicle(
                          travel: travel!,
                          ocurrence: occurence,
                        );

                        // reset form
                        _descriptionEC.text = '';
                        setState(() {
                          imageContainers.clear();
                        });
                      }
                    },
              width: context.width,
            ),
          ),
        ],
      ),
    );
  }

  _getTypesOcurrencies() async {
    typeOccurences = await _occurrenceController.getTypesOcurrencies(travelApiId: travelApiId!, address: address);

    final List<DropdownMenuItem<String>> dropdownData = [];

    for (var element in typeOccurences) {
      dropdownData.add(
        DropdownMenuItem(
          value: element.id.toString(),
          child: Text(element.description!),
        ),
      );
    }

    setState(() {
      dropdownItems = dropdownData;
    });
  }
}
