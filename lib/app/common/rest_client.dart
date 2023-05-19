import 'package:get/get.dart';

class RestClient extends GetConnect {
  final _appBaseUrl = 'https://way-dev.webrouter.com.br/appTracking/tracking';
  RestClient() {
    httpClient.baseUrl = _appBaseUrl;
    httpClient.timeout = const Duration(seconds: 20);
  }
}
