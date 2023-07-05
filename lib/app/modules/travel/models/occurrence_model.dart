import 'package:ailog_app_tracking/app/modules/travel/models/address_model.dart';
import 'package:ailog_app_tracking/app/modules/travel/models/client_model.dart';
import 'package:ailog_app_tracking/app/modules/travel/models/lat_long_model.dart';
import 'package:ailog_app_tracking/app/modules/travel/models/type_occurence_model.dart';

class OccurrenceModel {
  int? id;
  final TypeOccurenceModel typeOccurrence;
  final String description;
  final DateTime dateHour;
  List<String>? urlPhotos;
  final LatLongModel? latLong;
  final ClientModel? client;
  final AddressModel? address;

  OccurrenceModel({
    this.id,
    required this.typeOccurrence,
    required this.description,
    required this.dateHour,
    this.urlPhotos,
    this.latLong,
    this.client,
    this.address,
  });

  factory OccurrenceModel.fromJson(Map<String, dynamic> json) {
    // parse date dd/MM/yyyy HH:mm:ss to yyyy-MM-dd HH:mm:ss
    String date = json['date_hour'];
    String dateParsed =
        '${date.substring(6, 10)}-${date.substring(3, 5)}-${date.substring(0, 2)} ${date.substring(11, 19)}';

    return OccurrenceModel(
      id: json['id'],
      typeOccurrence: TypeOccurenceModel.fromJson(json['type_occurrence']),
      description: json['description'],
      dateHour: DateTime.parse(dateParsed),
      urlPhotos: json['url_photos'] != null ? (json['url_photos'] as List).map((e) => e.toString()).toList() : null,
      latLong: json['lat_long'] != null ? LatLongModel.fromJson(json['lat_long']) : null,
      client: json['client'] != null ? ClientModel.fromJson(json['client']) : null,
      address: json['address'] != null ? AddressModel.fromJson(json['address']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type_occurrence'] = typeOccurrence.toJson();
    data['description'] = description;
    data['date_hour'] = dateHour.toString();
    data['url_photos'] = urlPhotos;
    data['lat_long'] = latLong?.toJson();
    data['client'] = client?.toJson();
    data['address'] = address?.toJson();
    return data;
  }

  @override
  String toString() {
    return 'OccurrenceModel{id: $id, typeOccurrence: $typeOccurrence, description: $description, dateHour: $dateHour, urlPhotos: $urlPhotos, latLong: $latLong, client: $client, address: $address}';
  }
}
