import 'dart:io';

import 'package:ailog_app_tracking/app/common/permission_controller.dart';
import 'package:ailog_app_tracking/app/common/ui/widgets/custom_app_bar.dart';
import 'package:ailog_app_tracking/app/common/ui/widgets/custom_loading.dart';
import 'package:ailog_app_tracking/app/common/ui/widgets/error_permission.dart';
import 'package:ailog_app_tracking/app/common/ui/widgets/not_found.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';

import '../supply_controller.dart';

class SupplyPage extends StatefulWidget {
  const SupplyPage({Key? key}) : super(key: key);

  @override
  State<SupplyPage> createState() => _SupplyPageState();
}

class _SupplyPageState extends State<SupplyPage> {
  bool checkPermission = false;
  final argumentsRoute = Get.arguments;
  List<bool> loadingImages = [];

  @override
  void initState() {
    super.initState();

    // check permission storage
    PermissionController.getStoragePermission().then((value) {
      if (value) {
        setState(() {
          checkPermission = true;
        });
      } else {
        PermissionController.getStoragePermission().then((value) {
          if (value) {
            setState(() {
              checkPermission = true;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final supplyController = Get.find<SupplyController>();
    final travelId = argumentsRoute['travelId'];
    final travelIdApi = argumentsRoute['travelIdApi'];

    supplyController.getAll(travelId: travelId);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: checkPermission == false
          ? ErrorPermission(
              callback: () {
                // check permission here
                PermissionController.getStoragePermission().then((value) {
                  if (value) {
                    setState(() {
                      checkPermission = true;
                    });
                  }
                });
              },
              message: 'Precisamos de sua permissão para acessar o armazenamento do seu dispositivo')
          : Obx(() {
              final supplies = supplyController.supplies;

              return supplyController.loadingGetData
                  ? const Center(
                      child: CustomLoading(
                        message: 'Carregando dados',
                      ),
                    )
                  : supplies.isEmpty
                      ? const Center(
                          child: NotFound(message: 'Nada encontrado por aqui!'),
                        )
                      : ListView.builder(
                          itemCount: supplies.length,
                          itemBuilder: (context, index) {
                            final supply = supplies[index];
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: ListTile(
                                  dense: true,
                                  title: Column(
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: context.width * 0.43,
                                            child: Row(
                                              children: [
                                                const Text('Litros: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                Text(supply.liters.toString()),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: context.width * 0.43,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                const Text('Valor: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                Text(
                                                  'R\$ ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(supply.valueLiter)}',
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: context.width * 0.54,
                                                child: Row(
                                                  children: [
                                                    const Text('Total: ',
                                                        style: TextStyle(fontWeight: FontWeight.bold)),
                                                    Text(
                                                      'R\$ ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(supply.valueLiter * supply.liters)}',
                                                    )
                                                  ],
                                                ),
                                              ),
                                              const Text('Data: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                              Text(DateFormat('dd/MM/yy HH:mm').format(supply.dateSupply!)),
                                            ],
                                          ),

                                          /** show container images */
                                          Container(
                                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                Container(
                                                  height: context.height * 0.12,
                                                  width: context.width * 0.25,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.grey),
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      supply.pathImagePump != null || supply.urlImagePump != null
                                                          ? InkWell(
                                                              onTap: () {
                                                                if (supply.urlImagePump != null) {
                                                                  _openFileFromUrl(url: supply.urlImagePump!);
                                                                } else {
                                                                  _openFile(path: supply.pathImagePump!);
                                                                }
                                                              },
                                                              child: Stack(
                                                                alignment: Alignment.bottomCenter,
                                                                children: [
                                                                  supply.urlImagePump != null
                                                                      ? Image.network(
                                                                          supply.urlImagePump!,
                                                                          height: 70,
                                                                          width: 70,
                                                                          fit: BoxFit.cover,
                                                                        )
                                                                      : Image.file(
                                                                          File(supply.pathImagePump!),
                                                                          height: 70,
                                                                          width: 70,
                                                                          fit: BoxFit.cover,
                                                                        ),
                                                                  Container(
                                                                    alignment: Alignment.center,
                                                                    width: context.width,
                                                                    color: Colors.black.withOpacity(0.5),
                                                                    padding: const EdgeInsets.all(5),
                                                                    child: const Text(
                                                                      'Bomba',
                                                                      style: TextStyle(color: Colors.white),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
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
                                                                  padding: const EdgeInsets.all(5),
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
                                                Container(
                                                  height: context.height * 0.12,
                                                  width: context.width * 0.25,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.grey),
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      supply.pathImageInvoice != null || supply.urlImageInvoice != null
                                                          ? InkWell(
                                                              onTap: () {
                                                                if (supply.urlImageInvoice != null) {
                                                                  _openFileFromUrl(url: supply.urlImageInvoice!);
                                                                } else {
                                                                  _openFile(path: supply.pathImageInvoice!);
                                                                }
                                                              },
                                                              child: Stack(
                                                                alignment: Alignment.bottomCenter,
                                                                children: [
                                                                  supply.urlImageInvoice != null
                                                                      ? Image.network(
                                                                          supply.urlImageInvoice!,
                                                                          height: 70,
                                                                          width: 70,
                                                                          fit: BoxFit.cover,
                                                                        )
                                                                      : Image.file(
                                                                          File(supply.pathImageInvoice!),
                                                                          height: 70,
                                                                          width: 70,
                                                                          fit: BoxFit.cover,
                                                                        ),
                                                                  Container(
                                                                    alignment: Alignment.center,
                                                                    width: context.width,
                                                                    color: Colors.black.withOpacity(0.5),
                                                                    padding: const EdgeInsets.all(5),
                                                                    child: const Text(
                                                                      'Recibo',
                                                                      style: TextStyle(color: Colors.white),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
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
                                                                  padding: const EdgeInsets.all(5),
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
                                                Container(
                                                  height: context.height * 0.12,
                                                  width: context.width * 0.25,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.grey),
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      supply.pathImageOdometer != null ||
                                                              supply.urlImageOdometer != null
                                                          ? InkWell(
                                                              onTap: () {
                                                                if (supply.urlImageOdometer != null) {
                                                                  _openFileFromUrl(url: supply.urlImageOdometer!);
                                                                } else {
                                                                  _openFile(path: supply.pathImageOdometer!);
                                                                }
                                                              },
                                                              child: Stack(
                                                                alignment: Alignment.bottomCenter,
                                                                children: [
                                                                  supply.urlImageOdometer != null
                                                                      ? Image.network(
                                                                          supply.urlImageOdometer!,
                                                                          height: 70,
                                                                          width: 70,
                                                                          fit: BoxFit.cover,
                                                                        )
                                                                      : Image.file(
                                                                          File(supply.pathImageOdometer!),
                                                                          height: 70,
                                                                          width: 70,
                                                                          fit: BoxFit.cover,
                                                                        ),
                                                                  Container(
                                                                    alignment: Alignment.center,
                                                                    width: context.width,
                                                                    color: Colors.black.withOpacity(0.5),
                                                                    padding: const EdgeInsets.all(5),
                                                                    child: const Text(
                                                                      'Hodômetro',
                                                                      style: TextStyle(color: Colors.white),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
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
                                                                  padding: const EdgeInsets.all(5),
                                                                  child: const Text(
                                                                    'Hodômetro',
                                                                    style: TextStyle(color: Colors.white),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
            }),
      floatingActionButton: checkPermission == false
          ? null
          : FloatingActionButton(
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                Get.toNamed('/supply/create', arguments: {
                  'travelId': travelId,
                  'travelIdApi': travelIdApi,
                });
              },
              backgroundColor: context.theme.primaryColor,
              child: const Icon(Icons.add),
            ),
    );
  }

  _openFile({required String path}) {
    OpenFile.open(path);
  }

  _openFileFromUrl({required String url}) {
    final controller = Get.find<SupplyController>();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return Dialog(
          child: Container(
            height: context.height * 0.2,
            width: context.width * 0.2,
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: context.theme.primaryColor,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('Carregando arquivo...'),
              ],
            ),
          ),
        );
      },
    );

    try {
      final file = controller.downloadFile(url: url);
      file.then((value) {
        Navigator.pop(context);
        OpenFile.open(value!.path);
      });
    } catch (e) {
      Navigator.pop(context);
    }
  }
}
