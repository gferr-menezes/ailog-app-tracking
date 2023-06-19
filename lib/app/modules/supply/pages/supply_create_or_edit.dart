import 'dart:io';

import 'package:ailog_app_tracking/app/modules/supply/repositories/supply_repository_impl.dart';
import 'package:camera/camera.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:validatorless/validatorless.dart';

import '../../../common/contracts.dart';
import '../../../common/geolocation.dart';
import '../../../common/storage_file.dart';
import '../../../common/ui/widgets/custom_app_bar.dart';
import '../../../common/ui/widgets/custom_button.dart';
import '../../../common/ui/widgets/custom_snackbar.dart';
import '../../../common/ui/widgets/custom_text_form_field.dart';
import '../models/supply_model.dart';
import '../supply_controller.dart';

class SupplyCreateOrEdit extends StatefulWidget {
  const SupplyCreateOrEdit({Key? key}) : super(key: key);

  @override
  State<SupplyCreateOrEdit> createState() => _SupplyCreateOrEditState();
}

class _SupplyCreateOrEditState extends State<SupplyCreateOrEdit> {
  final argumentsPage = Get.arguments;
  int? travelId;
  String? travelIdApi;
  final supplyController = Get.find<SupplyController>();
  final formKey = GlobalKey<FormState>();
  final TextEditingController valueLiterEC = TextEditingController();
  final TextEditingController quantityLiterEC = TextEditingController();
  final TextEditingController odometerEC = TextEditingController();
  String? _typePhoto;
  XFile? _imagePump;
  XFile? _imageReceipt;
  XFile? _imageOdometer;
  final _textRecognizer = TextRecognizer();

  final moneyMask = CurrencyTextInputFormatter(
    locale: 'pt_BR',
    decimalDigits: 2,
    symbol: 'R\$',
  );

  @override
  void initState() {
    super.initState();
    travelId = argumentsPage['travelId'];
    travelIdApi = argumentsPage['travelIdApi'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextFormField(
                      label: 'Valor do litro',
                      controller: valueLiterEC,
                      keyboardType: TextInputType.number,
                      validator: Validatorless.multiple(
                        [
                          Validatorless.required('o campo é obrigatório'),
                        ],
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        moneyMask,
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextFormField(
                      label: 'Quantidade de litros',
                      controller: quantityLiterEC,
                      keyboardType: TextInputType.number,
                      validator: Validatorless.multiple([
                        Validatorless.required('o campo é obrigatório'),
                      ]),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextFormField(
                      label: 'Hodômetro',
                      controller: odometerEC,
                      keyboardType: TextInputType.number,
                      validator: Validatorless.multiple([
                        Validatorless.required('o campo é obrigatório'),
                      ]),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: context.width,
                height: 20,
                child: const Padding(
                  padding: EdgeInsets.only(left: 2),
                  child: Text('Toque nos icones para adicionar as fotos'),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        _goToPageCamera(typePhoto: 'pump');
                      },
                      child: Container(
                        height: context.height * 0.1,
                        width: context.width * 0.25,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _imagePump != null
                                ? Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: Container(
                                          height: 70,
                                          width: context.width,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey),
                                            borderRadius: BorderRadius.circular(3),
                                          ),
                                          child: Image.file(
                                            File(_imagePump!.path),
                                            height: 70,
                                            width: context.width,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        width: context.width,
                                        color: Colors.black.withOpacity(0.5),
                                        padding: const EdgeInsets.symmetric(vertical: 5),
                                        child: const Text(
                                          'Bomba',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    ],
                                  )
                                : Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      const Icon(
                                        Icons.camera_alt_outlined,
                                        size: 70,
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        width: context.width,
                                        color: Colors.black.withOpacity(0.5),
                                        padding: const EdgeInsets.symmetric(vertical: 5),
                                        child: const Text(
                                          'Bomba',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _goToPageCamera(typePhoto: 'receipt');
                      },
                      child: Container(
                        height: context.height * 0.1,
                        width: context.width * 0.25,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _imageReceipt != null
                                ? Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: Container(
                                          height: 70,
                                          width: context.width,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey),
                                            borderRadius: BorderRadius.circular(3),
                                          ),
                                          child: Image.file(
                                            File(_imageReceipt!.path),
                                            height: 70,
                                            width: context.width,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        width: context.width,
                                        color: Colors.black.withOpacity(0.5),
                                        padding: const EdgeInsets.symmetric(vertical: 5),
                                        child: const Text(
                                          'Recibo',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    ],
                                  )
                                : Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      const Icon(
                                        Icons.camera_alt_outlined,
                                        size: 70,
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        width: context.width,
                                        color: Colors.black.withOpacity(0.5),
                                        padding: const EdgeInsets.symmetric(vertical: 5),
                                        child: const Text(
                                          'Recibo',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _goToPageCamera(typePhoto: 'odometer');
                      },
                      child: Container(
                        height: context.height * 0.1,
                        width: context.width * 0.25,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _imageOdometer != null
                                ? Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: Container(
                                          height: 70,
                                          width: context.width,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey),
                                            borderRadius: BorderRadius.circular(3),
                                          ),
                                          child: Image.file(
                                            File(_imageOdometer!.path),
                                            height: 70,
                                            width: context.width,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        width: context.width,
                                        color: Colors.black.withOpacity(0.5),
                                        padding: const EdgeInsets.symmetric(vertical: 5),
                                        child: const Text(
                                          'Hodomêtro',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    ],
                                  )
                                : Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      const Icon(
                                        Icons.camera_alt_outlined,
                                        size: 70,
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        width: context.width,
                                        color: Colors.black.withOpacity(0.5),
                                        padding: const EdgeInsets.symmetric(vertical: 5),
                                        child: const Text(
                                          'Hodomêtro',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: context.width,
                child: Obx(
                  () => CustomButtom(
                    loading: supplyController.loadingSaving,
                    label: 'Salvar',
                    onPressed: supplyController.loadingSaving == true
                        ? null
                        : () async {
                            if (_imagePump == null) {
                              CustomSnackbar.show(
                                Get.context!,
                                message: 'Informe a foto da bomba',
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                              );
                              return;
                            }

                            if (formKey.currentState!.validate()) {
                              supplyController.loadingSaving = true;

                              FocusManager.instance.primaryFocus?.unfocus();
                              final currentPosition = await Geolocation.getCurrentPosition();

                              var txtValue = valueLiterEC.text.replaceAll('R\$', '');
                              txtValue = txtValue.replaceAll('.', '');
                              txtValue = txtValue.replaceAll(',', '.');
                              final valueLiter = double.parse(txtValue);

                              var txtQuantity = quantityLiterEC.text;
                              txtQuantity = txtQuantity.replaceAll(',', '.');
                              final quantityLiter = double.parse(txtQuantity);

                              var txtOdometer = odometerEC.text;
                              txtOdometer = txtOdometer.replaceAll(',', '');
                              txtOdometer = txtOdometer.replaceAll('.', '');
                              final odometer = int.parse(txtOdometer);

                              var supply = SupplyModel(
                                travelId: travelId!,
                                travelIdApi: travelIdApi!,
                                valueLiter: valueLiter,
                                liters: quantityLiter,
                                odometer: odometer,
                                dateSupply: DateTime.now(),
                                statusSendApi: StatusSendAPI.pending.name,
                                latitude: currentPosition!.latitude,
                                longitude: currentPosition.longitude,
                              );

                              final storageFile = StorageFile();

                              if (_imagePump != null) {
                                final resultPump = await storageFile.saveFile(
                                  fileData: File(_imagePump!.path),
                                );

                                supply.pathImagePump = resultPump;
                              }

                              if (_imageReceipt != null) {
                                final resultReceipt = await storageFile.saveFile(
                                  fileData: File(_imageReceipt!.path),
                                );

                                supply.pathImageInvoice = resultReceipt;
                              }

                              if (_imageOdometer != null) {
                                final resultOdometer = await storageFile.saveFile(
                                  fileData: File(_imageOdometer!.path),
                                );

                                supply.pathImageOdometer = resultOdometer;
                              }

                              late File file;

                              if (_imagePump != null) {
                                file = File(_imagePump!.path);
                                Uint8List fileBytes = file.readAsBytesSync();

                                final imageUpload = await supplyController.uploadImage(
                                  supply: supply,
                                  image: fileBytes,
                                  typeImage: TypeImage.bomba.name,
                                );
                                supply.urlImagePump = imageUpload;
                              }

                              if (_imageReceipt != null) {
                                file = File(_imageReceipt!.path);
                                Uint8List fileBytes = file.readAsBytesSync();

                                final imageUpload = await supplyController.uploadImage(
                                  supply: supply,
                                  image: fileBytes,
                                  typeImage: TypeImage.cupomFical.name,
                                );
                                supply.urlImageInvoice = imageUpload;
                              }

                              if (_imageOdometer != null) {
                                file = File(_imageOdometer!.path);
                                Uint8List fileBytes = file.readAsBytesSync();

                                final imageUpload = await supplyController.uploadImage(
                                  supply: supply,
                                  image: fileBytes,
                                  typeImage: TypeImage.cupomFical.name,
                                );
                                supply.urlImageOdometer = imageUpload;
                              }

                              if (supply.urlImagePump != null) {
                                await storageFile.removeFile(path: supply.pathImagePump!);
                                supply.pathImagePump = null;
                              }

                              if (supply.urlImageInvoice != null) {
                                await storageFile.removeFile(path: supply.pathImageInvoice!);
                                supply.pathImageInvoice = null;
                              }

                              if (supply.urlImageOdometer != null) {
                                await storageFile.removeFile(path: supply.pathImageOdometer!);
                                supply.pathImageOdometer = null;
                              }

                              /** generate ocr */
                              if (_imageReceipt != null) {
                                final file = File(_imageReceipt!.path);
                                final inputImage = InputImage.fromFile(file);
                                final recognizedText = await _textRecognizer.processImage(inputImage);
                                supply.ocrRecibo = recognizedText.text;
                              }

                              supplyController.insert(supply: supply);
                              supplyController.sendSupply(supply: supply);
                              supplyController.getAll(travelId: travelId!);

                              /** reset form */
                              formKey.currentState!.reset();
                              valueLiterEC.clear();
                              quantityLiterEC.clear();
                              odometerEC.clear();
                              setState(() {
                                _imagePump = null;
                                _imageReceipt = null;
                                _imageOdometer = null;
                              });
                            }
                          },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _goToPageCamera({
    required String typePhoto,
  }) async {
    _typePhoto = typePhoto;
    XFile result = await Get.toNamed('/documents', arguments: {
      'returnImage': true,
      'typePhoto': typePhoto,
    });

    if (_typePhoto == 'pump') {
      setState(() {
        _imagePump = result;
      });
      return;
    }
    if (_typePhoto == 'receipt') {
      setState(() {
        _imageReceipt = result;
      });
      return;
    }

    if (_typePhoto == 'odometer') {
      setState(() {
        _imageOdometer = result;
      });
      return;
    }
  }
}
