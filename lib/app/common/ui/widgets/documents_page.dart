import 'dart:io';

import 'package:ailog_app_tracking/app/common/ui/widgets/custom_button.dart';
import 'package:ailog_app_tracking/app/common/ui/widgets/custom_loading.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({Key? key}) : super(key: key);

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  List<CameraDescription> cameras = [];
  CameraController? controller;
  XFile? imagem;
  Size? size;

  @override
  void initState() {
    super.initState();
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
      body: Container(
        color: Colors.white,
        child: Center(
          child: _fileWidget(),
        ),
      ),
      // floatingActionButton: (imagem != null)
      //     ? FloatingActionButton.extended(
      //         onPressed: () => Navigator.pop(context),
      //         label: const Text("Enviar comprovante"),
      //       )
      //     : null,
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _fileWidget() {
    return SizedBox(
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
                        width: size!.width * 0.94,
                        label: "Enviar comprovante",
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomButtom(
                        width: size!.width * 0.94,
                        color: Colors.grey[400],
                        label: "Cancelar",
                        onPressed: () => Navigator.pop(context),
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
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          CameraPreview(controller!),
          _captureWidget(),
        ],
      );
    }
  }

  _captureWidget() {
    return SizedBox(
      height: size!.height,
      child: Padding(
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
            CustomButtom(
              width: size!.width * 0.95,
              color: Colors.grey[400],
              label: "Cancelar",
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  _takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController != null && cameraController.value.isInitialized) {
      try {
        cameraController.setFlashMode(FlashMode.off);

        XFile file = await cameraController.takePicture();

        var bytes = await file.readAsBytes();

        print(bytes);

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
