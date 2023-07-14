import 'package:intl/intl.dart';

class OccurenceVehicleModel {
  int? id;
  int? travelId;
  String? travelIdApi;
  int? order;
  String? description;
  DateTime? dateOccurrence;
  double? latitude;
  double? longitude;
  List<String>? urlPhotos;

  OccurenceVehicleModel({
    this.id,
    this.travelId,
    this.travelIdApi,
    this.order,
    this.description,
    this.dateOccurrence,
    this.latitude,
    this.longitude,
    this.urlPhotos,
  });

  OccurenceVehicleModel.fromJson(Map<String, dynamic> json) {
    var inputFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
    DateTime? inputDate = json['dataHora'] != null ? inputFormat.parse(json['dataHora']) : null;

    order = json['ordem'];
    description = json['descricao'];
    dateOccurrence = json['dataHora'] != null ? inputDate : null;
    latitude = json['latLng']['latitude'];
    longitude = json['latLng']['longitude'];
    urlPhotos = json['urlFotos'] != null ? List<String>.from(json['urlFotos']) : null;
  }

  Map<String, dynamic> toJson() => {
        'ordem': order,
        'descricao': description,
        'dataHora': dateOccurrence?.toIso8601String(),
        'latLng': {
          'latitude': latitude,
          'longitude': longitude,
        },
        'urlFotos': urlPhotos,
      };

  @override
  String toString() {
    return 'OccurenceVehicleModel(id: $id, travelId: $travelId, travelIdApi: $travelIdApi, order: $order, description: $description, dateOccurrence: $dateOccurrence, latitude: $latitude, longitude: $longitude, urlPhotos: $urlPhotos)';
  }
}
