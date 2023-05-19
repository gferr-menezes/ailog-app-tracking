class GeolocationModel {
  int? id;
  int? travelId;
  String? travelIdApi;
  final double latitude;
  final double longitude;
  final DateTime collectionDate;
  String? statusSendApi;
  DateTime? dateSendApi;

  GeolocationModel({
    this.id,
    this.travelId,
    this.travelIdApi,
    required this.latitude,
    required this.longitude,
    required this.collectionDate,
    this.statusSendApi,
    this.dateSendApi,
  });

  GeolocationModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        travelId = json['travel_id'],
        travelIdApi = json['travel_id_api'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        collectionDate = DateTime.parse(json['collection_date']),
        statusSendApi = json['status_send_api'] ?? StatusSendApi.pending.name,
        dateSendApi = json['date_send_api'] != null ? DateTime.parse(json['date_send_api']) : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['travel_id'] = travelId;
    data['travel_id_api'] = travelIdApi;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['collection_date'] = collectionDate.toString();
    data['status_send_api'] = statusSendApi;
    data['date_send_api'] = dateSendApi;
    return data;
  }

  @override
  String toString() {
    return 'GeolocationModel{id: $id, travelId: $travelId, travelIdApi: $travelIdApi, latitude: $latitude, longitude: $longitude, collectionDate: $collectionDate, statusSendApi: $statusSendApi, dateSendApi: $dateSendApi}';
  }
}

enum StatusSendApi {
  pending,
  sended,
}
