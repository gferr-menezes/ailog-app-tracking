class SupplyModel {
  int? id;
  final int? supplyIdApi;
  final int travelId;
  final String? travelIdApi;
  final double valueLiter;
  final double liters;
  final int odometer;
  String? pathImagePump;
  String? urlImagePump;
  String? pathImageOdometer;
  String? urlImageOdometer;
  String? pathImageInvoice;
  String? urlImageInvoice;
  final DateTime? dateSupply;
  final String? statusSendApi;
  final DateTime? dateSendApi;
  final double? latitude;
  final double? longitude;
  String? ocrRecibo;

  SupplyModel({
    this.id,
    this.supplyIdApi,
    required this.travelId,
    this.travelIdApi,
    required this.valueLiter,
    required this.liters,
    required this.odometer,
    this.pathImagePump,
    this.urlImagePump,
    this.pathImageOdometer,
    this.urlImageOdometer,
    this.pathImageInvoice,
    this.urlImageInvoice,
    this.dateSupply,
    this.statusSendApi,
    this.dateSendApi,
    this.latitude,
    this.longitude,
    this.ocrRecibo,
  });

  factory SupplyModel.fromJson(Map<String, dynamic> json) {
    return SupplyModel(
      id: json['id'],
      supplyIdApi: json['supply_id_api'],
      travelId: json['travel_id'],
      travelIdApi: json['travel_id_api'],
      valueLiter: json['value_liter'],
      liters: json['liters'],
      odometer: json['odometer'],
      pathImagePump: json['path_image_pump'],
      urlImagePump: json['url_image_pump'],
      pathImageOdometer: json['path_image_odometer'],
      urlImageOdometer: json['url_image_odometer'],
      pathImageInvoice: json['path_image_invoice'],
      urlImageInvoice: json['url_image_invoice'],
      dateSupply: json['date_supply'] != null ? DateTime.parse(json['date_supply']) : null,
      statusSendApi: json['status_send_api'],
      dateSendApi: json['date_send_api'] != null ? DateTime.parse(json['date_send_api']) : null,
      latitude: json['latitude'],
      longitude: json['longitude'],
      ocrRecibo: json['ocr_recibo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'supply_id_api': supplyIdApi,
      'travel_id': travelId,
      'travel_id_api': travelIdApi,
      'value_liter': valueLiter,
      'liters': liters,
      'odometer': odometer,
      'path_image_pump': pathImagePump,
      'url_image_pump': urlImagePump,
      'path_image_odometer': pathImageOdometer,
      'url_image_odometer': urlImageOdometer,
      'path_image_invoice': pathImageInvoice,
      'url_image_invoice': urlImageInvoice,
      'date_supply': dateSupply?.toIso8601String(),
      'status_send_api': statusSendApi,
      'date_send_api': dateSendApi?.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'ocr_recibo': ocrRecibo,
    };
  }

  @override
  String toString() {
    return 'Supply(id: $id, supplyIdApi: $supplyIdApi, travelId: $travelId, travelIdApi: $travelIdApi, valueLiter: $valueLiter, liters: $liters, odometer: $odometer, pathImagePump: $pathImagePump, urlImagePump: $urlImagePump, pathImageOdometer: $pathImageOdometer, urlImageOdometer: $urlImageOdometer, pathImageInvoice: $pathImageInvoice, urlImageInvoice: $urlImageInvoice, dateSupply: $dateSupply, statusSendApi: $statusSendApi, dateSendApi: $dateSendApi, latitude: $latitude, longitude: $longitude, ocrRecibo: $ocrRecibo)';
  }
}
