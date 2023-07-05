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

class OccurrencePhotoPage extends StatefulWidget {
  const OccurrencePhotoPage({Key? key}) : super(key: key);

  @override
  State<OccurrencePhotoPage> createState() => _OccurrencePhotoPage();
}

class _OccurrencePhotoPage extends State<OccurrencePhotoPage> {
  Map<String, dynamic>? arguments;
  //final DocumentService documentService = Get.find();
  List<CameraDescription> cameras = [];
  CameraController? controller;
  XFile? imagem;
  Size? size;
  bool loading = false;
  final List<XFile> imageContainers = [];

  @override
  void initState() {
    super.initState();

    arguments = Get.arguments as Map<String, dynamic>?;

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
      child: _cameraPreviewWidget(),
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
          CameraPreview(controller!),
          _captureWidget(),
        ],
      );
    }
  }

  _captureWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 1),
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
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Center(
              child: Column(
                children: [
                  CustomButtom(
                    width: size!.width * 0.95,
                    color: Colors.grey[400],
                    label: "Cancelar",
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomButtom(
                    width: size!.width * 0.95,
                    color: context.theme.primaryColor,
                    label: "Salvar imagens",
                    onPressed: imageContainers.isEmpty ? null : () => Navigator.pop(context, imageContainers),
                  )
                ],
              ),
            ),
          ),
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
            imageContainers.add(file);
          });
        }
      } on CameraException catch (e) {
        print(e.description);
      }
    }
  }
}
