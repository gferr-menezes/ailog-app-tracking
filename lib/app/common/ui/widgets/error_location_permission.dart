import 'package:ailog_app_tracking/app/common/permission_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'custom_button.dart';

class ErrorLocationPermission extends StatefulWidget {
  final Function callback;

  const ErrorLocationPermission({required this.callback, Key? key}) : super(key: key);

  @override
  State<ErrorLocationPermission> createState() => _ErrorLocationPermissionState();
}

class _ErrorLocationPermissionState extends State<ErrorLocationPermission> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset('assets/images/19_Error.png', fit: BoxFit.cover, height: context.height),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              'Permissão necessária',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black54,
              ),
            ),
            const Text(
              'Precisamos da sua permissão para acessar a localização do seu dispositivo o tempo todo.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black45,
              ),
              textAlign: TextAlign.center,
            ).paddingSymmetric(vertical: 8, horizontal: 40),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: CustomButtom(
                label: 'Tentar novamente',
                height: 50,
                width: context.width * 0.95,
                onPressed: () {
                  PermissionController.checkGeolocationPermission().then((value) {
                    if (value == PermissionStatus.denied) {
                      PermissionController.getGeolocationPermission().then((value) {
                        if (value) {
                          widget.callback(true);
                        }
                      });
                    }
                    if (value == PermissionStatus.granted) {
                      PermissionController.getGeolocationPermission().then((value) {
                        if (value) {
                          widget.callback(true);
                        }
                      });
                    }
                  });
                },
              ),
            )
          ],
        ),
      ],
    );
  }
}
