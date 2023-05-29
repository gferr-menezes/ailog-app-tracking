import 'package:get/get.dart';

class RestClient extends GetConnect {
  //final _appBaseUrl = 'http://192.168.0.87:8095/tracking';
  final _appBaseUrl = 'https://way-dev.webrouter.com.br/appTracking/tracking';
  // final _appBaseUrl = 'http://192.168.138.131:8095/tracking';
  RestClient() {
    httpClient.baseUrl = _appBaseUrl;
    httpClient.timeout = const Duration(seconds: 20);
  }
}
