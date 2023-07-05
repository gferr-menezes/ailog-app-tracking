import 'dart:io';

import 'package:ailog_app_tracking/app/common/ui/widgets/custom_button.dart';
import 'package:ailog_app_tracking/app/common/ui/widgets/custom_loading.dart';
import 'package:ailog_app_tracking/app/modules/document/services/document_service.dart';
import 'package:ailog_app_tracking/app/modules/travel/models/toll_model.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../common/ui/widgets/custom_snackbar.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({Key? key}) : super(key: key);

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  Map<String, dynamic>? arguments;
  final DocumentService documentService = Get.find();
  List<CameraDescription> cameras = [];
  CameraController? controller;
  XFile? imagem;
  Size? size;
  bool loading = false;

  @override
  void initState() {
    super.initState();

    arguments = Get.arguments as Map<String, dynamic>?;

    print('arguments: $arguments');

    _loadCameras();
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  _loadCameras() async {
    try {
      cameras = cameras = await availableCameras();
      _startCamera();
    } on CameraException catch (e) {
      print(e.description);
    }
  }

  _startCamera() {
    if (cameras.isEmpty) {
      print("Camera não encontrada");
    } else {
      _previewCamera(cameras.first);
    }
  }

  _previewCamera(CameraDescription camera) async {
    CameraController cameraController = CameraController(
      camera,
      ResolutionPreset.max,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      print(e.description);
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      body: _fileWidget(),
    );
  }

  _fileWidget() {
    return Container(
      width: size!.width,
      height: size!.height,
      color: Colors.black.withOpacity(0.7),
      child: imagem == null
          ? _cameraPreviewWidget()
          : Stack(
              children: [
                Image.file(
                  File(imagem!.path),
                  fit: BoxFit.contain,
                ),
                Positioned(
                  bottom: 20,
                  left: 10,
                  child: Column(
                    children: [
                      CustomButtom(
                        loading: loading,
                        width: size!.width * 0.94,
                        label: "Enviar comprovante",
                        onPressed: loading
                            ? null
                            : () async {
                                try {
                                  setState(() {
                                    loading = true;
                                  });

                                  File file = File(imagem!.path);

                                  Uint8List bytes = file.readAsBytesSync();

                                  TollModel toll = arguments!['toll'];
                                  final imageUrl = await documentService.upload(toll: toll, image: bytes);
                                  setState(() {
                                    loading = false;
                                  });

                                  CustomSnackbar.show(
                                    Get.context!,
                                    message: 'Arquivo enviado com sucesso!',
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                  );

                                  Navigator.pop(Get.context!, imageUrl);
                                } catch (e) {
                                  CustomSnackbar.show(
                                    Get.context!,
                                    message: 'Erro ao enviar arquivo!',
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                  );

                                  setState(() {
                                    loading = false;
                                  });
                                }
                              },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomButtom(
                        width: size!.width * 0.94,
                        color: Colors.grey[400],
                        label: "Cancelar",
                        onPressed: () => loading ? null : Navigator.pop(context),
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  _cameraPreviewWidget() {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return const Center(
        child: CustomLoading(),
      );
    } else {
      return Stack(
        children: [
          CameraPreview(cameraController),
          // arguments != null && arguments!['typePhoto'] == 'receipt' ||
          //         arguments != null && arguments!['typePhoto'] == 'odometer'
          //     ? GestureDetector(
          //         onPanStart: (details) {
          //           setState(() {
          //             xPosition = details.localPosition.dx.toInt();
          //             yPosition = details.localPosition.dy.toInt();
          //           });

          //           _takePicture();
          //         },
          //         child: Container(
          //           width: size!.width,
          //           height: size!.height,
          //           decoration: BoxDecoration(
          //             border: Border(
          //               top: BorderSide(
          //                 color: Colors.black.withOpacity(0.7),
          //                 width: (size!.height - size!.width) / 1,
          //               ),
          //               bottom: BorderSide(
          //                 color: Colors.black.withOpacity(0.7),
          //                 width: (size!.height - size!.width) / 2,
          //               ),
          //             ),
          //           ),
          //         ),
          //       )
          //     : const SizedBox.shrink(),
          _captureWidget(),
        ],
      );
    }
  }

  _captureWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.black.withOpacity(0.5),
            child: IconButton(
              onPressed: _takePicture,
              icon: const Icon(Icons.camera_alt, color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: CustomButtom(
              width: size!.width * 0.95,
              color: Colors.grey[400],
              label: "Cancelar",
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  _takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController != null && cameraController.value.isInitialized) {
      try {
        cameraController.setFlashMode(FlashMode.off);
        XFile file = await cameraController.takePicture();

        if (arguments != null && arguments!['returnImage']) {
          Navigator.of(Get.context!).pop(file);
          return;
        }

        if (mounted) {
          setState(() {
            imagem = file;
          });
        }
      } on CameraException catch (e) {
        print(e.description);
      }
    }
  }
}
