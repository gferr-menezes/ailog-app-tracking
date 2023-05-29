import 'dart:async';
import 'dart:developer';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class Geolocation {
  static Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      log("Location services are disabled.");
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        log("Location permissions are denied (actual value: $permission).");
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      log(
        "Location permissions are permanently denied, we cannot request permissions (actual value: $permission).",
      );
      return false;
    }

    if (permission == LocationPermission.whileInUse) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always) {
        return false;
      }
    }

    print('Location permissions are granted (actual value: $permission).');

    return true;
  }

  static Future<Position?> getCurrentPosition() async {
    try {
      await Geolocation._handleLocationPermission();

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return position;
    } catch (e) {
      log("Error: $e");
    }
    return null;
  }

  static Future<StreamSubscription<Position>?> callPositionStream() async {
    try {
      print("####### POSITION STREAM INITIATED");
      final LocationSettings locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1,
        forceLocationManager: true,
        intervalDuration: const Duration(seconds: 1),
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationIcon: AndroidResource(name: 'ic_stat_onesignal_default'),
          notificationText: "Coletando dados de localização",
          notificationTitle: "Ailog App",
          enableWakeLock: true,
        ),
      );

      var position = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
        (Position? position) {
          log("###### position stream ${DateTime.now()} $position");
        },
      );

      return position;
    } catch (e) {
      log("Error: $e");
    }

    return null;
  }

  static getLastKnownPosition() async {
    Position? lastPosition = await Geolocator.getLastKnownPosition();
    print("#################### lastPosition $lastPosition");
    if (lastPosition != null) {
      return lastPosition;
    }
  }

  static Future<List<Placemark>> getCity({required double latitude, required double longitude}) async {
    var result = await placemarkFromCoordinates(latitude, longitude);
    return result;
  }

  static requestPermission() async {
    Geolocation._handleLocationPermission();
  }
}
