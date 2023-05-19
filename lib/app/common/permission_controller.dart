import 'package:permission_handler/permission_handler.dart';

class PermissionController {
  Future<bool> getGeolocationPermission() async {
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

  static Future<PermissionStatus> checkGeolocationPermission() async {
    return Permission.location.status;
  }
}
