import 'dart:io';

import 'package:ailog_app_tracking/app/common/ui/widgets/custom_loading.dart';
import 'package:ailog_app_tracking/app/modules/travel/models/occurrence_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';

import '../../../common/ui/widgets/custom_snackbar.dart';
import '../controllers/ocurrence_controller.dart';

class OccurrenceList extends StatelessWidget {
  final String travelApiId;

  OccurrenceList({super.key, required this.travelApiId});

  final occurrenceController = Get.find<OcurrenceController>();

  @override
  Widget build(BuildContext context) {
    occurrenceController.getOccurrences(travelApiId: travelApiId);

    Future<File?> downloadFile({required String url}) async {
      try {
        final file = await FileDownloader.downloadFile(url: url);
        return file;
      } catch (e) {
        CustomSnackbar.show(
          Get.context!,
          message: 'Erro ao baixar arquivo',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        throw Exception('Erro ao baixar arquivo');
      }
    }

    openFileFromUrl({required String url}) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
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
        final file = downloadFile(url: url);
        file.then((value) {
          Navigator.of(context, rootNavigator: true).pop();
          OpenFile.open(value!.path);
        });
      } catch (e) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }

    return Obx(
      () => occurrenceController.loadingOccurrences
          ? const Center(
              child: CustomLoading(message: 'Carregando ocorrências...'),
            )
          : occurrenceController.occurrences.isEmpty
              ? const Center(
                  child: Text('Nenhuma ocorrência cadastrada'),
                )
              : SizedBox.expand(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      final occurrence = occurrenceController.occurrences[index];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(1, 2, 1, 1),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: ListTile(
                              title: Row(
                                children: [
                                  const Text(
                                    'Operação: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(occurrence.typeOccurrence.description ?? ' - '),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Text(
                                        'Data: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        DateFormat('dd/MM/yy HH:mm').format(occurrence.dateHour),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  const Text('Descrição', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(occurrence.description),
                                ],
                              ),
                              trailing: occurrence.latLong == null && occurrence.urlPhotos!.isEmpty
                                  ? const SizedBox.shrink()
                                  : PopupMenuButton(
                                      icon: const Icon(Icons.more_vert),
                                      onOpened: () {
                                        // travelController.popMenuTollIsVisible.value = true;
                                      },
                                      onCanceled: () {
                                        // travelController.popMenuTollIsVisible.value = false;
                                      },
                                      itemBuilder: (context) {
                                        //travelController.contextPopMenu = context;

                                        return occurrence.urlPhotos!.isEmpty
                                            ? [
                                                PopupMenuItem(
                                                  value: {
                                                    'action': 'show_map',
                                                    'occurrence': occurrence,
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
                                                )
                                              ]
                                            : [
                                                PopupMenuItem(
                                                  value: {
                                                    'action': 'show_map',
                                                    'occurrence': occurrence,
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
                                                    'action': 'show_images',
                                                    'occurrence': occurrence,
                                                  },
                                                  child: Row(
                                                    children: const [
                                                      Icon(
                                                        Icons.camera_alt_outlined,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text('Ver fotos'),
                                                    ],
                                                  ),
                                                ),
                                              ];
                                      },
                                      onSelected: (value) async {
                                        final action = value['action'] as String;
                                        final occurrence = value['occurrence'] as OccurrenceModel;
                                        if (action == 'show_map') {
                                          if (occurrence.latLong != null) {
                                            Get.toNamed(
                                              '/travel/map',
                                              arguments: {
                                                'latitude': occurrence.latLong?.latitude,
                                                'longitude': occurrence.latLong?.longitude,
                                                'origin': 'occurrence_list',
                                                'occurrence_data': occurrence,
                                              },
                                            );
                                          }
                                        }

                                        if (action == 'show_images') {
                                          showGeneralDialog(
                                            context: context,
                                            barrierColor: Colors.white, // Background color
                                            barrierDismissible: false,
                                            transitionDuration: const Duration(milliseconds: 400),
                                            pageBuilder: (_, __, ___) {
                                              return GridView.builder(
                                                itemCount: occurrence.urlPhotos!.length,
                                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount:
                                                      MediaQuery.of(context).orientation == Orientation.landscape
                                                          ? 3
                                                          : 2,
                                                  crossAxisSpacing: 2,
                                                  mainAxisSpacing: 2,
                                                  childAspectRatio: (2 / 1),
                                                ),
                                                itemBuilder: (context, index) => Container(
                                                  padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                                                  margin: const EdgeInsets.all(1.0),
                                                  width: 50.0,
                                                  height: 50.0,
                                                  child: Stack(children: [
                                                    SizedBox.expand(
                                                      child:
                                                          Image.network(occurrence.urlPhotos![index], fit: BoxFit.fill),
                                                    ),
                                                    Positioned(
                                                      top: 0,
                                                      right: 0,
                                                      child: SizedBox(
                                                        width: 20,
                                                        height: 20,
                                                        child: Material(
                                                          child: InkWell(
                                                            child: InkWell(
                                                              onTap: () {
                                                                openFileFromUrl(url: occurrence.urlPhotos![index]);
                                                              },
                                                              child: Icon(
                                                                Icons.download_sharp,
                                                                color: Colors.black.withOpacity(0.5),
                                                                size: 20,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ]),
                                                ),
                                              );
                                            },
                                          );
                                        }
                                      },
                                    ),
                              // trailing: occurrence.urlPhotos == null || occurrence.urlPhotos!.isEmpty
                              //     ? const SizedBox.shrink()
                              //     : IconButton(
                              //         icon: const Icon(Icons.image),
                              //         onPressed: () {
                              //           showGeneralDialog(
                              //             context: context,
                              //             barrierColor: Colors.white, // Background color
                              //             barrierDismissible: false,
                              //             transitionDuration: const Duration(milliseconds: 400),
                              //             pageBuilder: (_, __, ___) {
                              //               return GridView.builder(
                              //                 itemCount: occurrence.urlPhotos!.length,
                              //                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              //                   crossAxisCount:
                              //                       MediaQuery.of(context).orientation == Orientation.landscape ? 3 : 2,
                              //                   crossAxisSpacing: 2,
                              //                   mainAxisSpacing: 2,
                              //                   childAspectRatio: (2 / 1),
                              //                 ),
                              //                 itemBuilder: (context, index) => Container(
                              //                   padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                              //                   margin: const EdgeInsets.all(1.0),
                              //                   width: 50.0,
                              //                   height: 50.0,
                              //                   child: Stack(children: [
                              //                     SizedBox.expand(
                              //                       child:
                              //                           Image.network(occurrence.urlPhotos![index], fit: BoxFit.fill),
                              //                     ),
                              //                     Positioned(
                              //                       top: 0,
                              //                       right: 0,
                              //                       child: SizedBox(
                              //                         width: 20,
                              //                         height: 20,
                              //                         child: Material(
                              //                           child: InkWell(
                              //                             child: InkWell(
                              //                               onTap: () {
                              //                                 openFileFromUrl(url: occurrence.urlPhotos![index]);
                              //                               },
                              //                               child: Icon(
                              //                                 Icons.download_sharp,
                              //                                 color: Colors.black.withOpacity(0.5),
                              //                                 size: 20,
                              //                               ),
                              //                             ),
                              //                           ),
                              //                         ),
                              //                       ),
                              //                     )
                              //                   ]),
                              //                 ),
                              //               );
                              //             },
                              //           );
                              //         },
                              //       ),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: occurrenceController.occurrences.length,
                  ),
                ),
    );
  }
}
