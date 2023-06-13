import 'package:permission_handler/permission_handler.dart';

class PermissionController {
  static Future<bool> getGeolocationPermission() async {
    var check = await Permission.locationWhenInUse.status;

    if (check == PermissionStatus.denied) {
      var result = await Permission.locationWhenInUse.request();
      if (result == PermissionStatus.granted) {
        result = await Permission.locationAlways.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      }
      return false;
    }

    check = await Permission.locationAlways.status;
    if (check == PermissionStatus.denied) {
      final result = await Permission.locationAlways.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> getStoragePermission() async {
    var check = await Permission.storage.status;

    if (check == PermissionStatus.denied) {
      final result = await Permission.storage.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
      return false;
    } else {
      return true;
    }
  }

  static Future<PermissionStatus> checkGeolocationPermission() async {
    return Permission.location.status;
  }

  static Future<PermissionStatus> checkStoragePermission() async {
    return Permission.storage.status;
  }
}
