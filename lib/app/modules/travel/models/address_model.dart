import 'package:ailog_app_tracking/app/modules/travel/models/client_model.dart';

class AddressModel {
  int? id;
  int? travelId;
  String? travelIdApi;
  int passOrder;
  String? typeOperation;
  String city;
  String state;
  String? address;
  String? neighborhood;
  String? country;
  String? zipCode;
  String? number;
  String? complement;
  double? latitude;
  double? longitude;
  DateTime? estimatedDeparture;
  DateTime? estimatedArrival;
  DateTime? realDeparture;
  DateTime? realArrival;
  ClientModel? client;

  AddressModel({
    this.id,
    this.travelId,
    this.travelIdApi,
    required this.passOrder,
    this.typeOperation,
    required this.city,
    required this.state,
    this.address,
    this.neighborhood,
    this.country,
    this.zipCode,
    this.number,
    this.complement,
    this.latitude,
    this.longitude,
    this.estimatedDeparture,
    this.estimatedArrival,
    this.realDeparture,
    this.realArrival,
    this.client,
  });

  AddressModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        travelId = json['travel_id'],
        travelIdApi = json['travel_id_api'],
        passOrder = json['pass_order'],
        typeOperation = json['type_operation'],
        city = json['city'],
        state = json['state'],
        address = json['address'],
        neighborhood = json['neighborhood'],
        country = json['country'],
        zipCode = json['zip_code'],
        number = json['number'],
        complement = json['complement'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        estimatedDeparture = json['estimated_departure'] != null ? DateTime.parse(json['estimated_departure']) : null,
        estimatedArrival = json['estimated_arrival'] != null ? DateTime.parse(json['estimated_arrival']) : null,
        realDeparture = json['real_departure'] != null ? DateTime.parse(json['real_departure']) : null,
        realArrival = json['real_arrival'] != null ? DateTime.parse(json['real_arrival']) : null,
        client = json['client'] != null ? ClientModel.fromJson(json['client']) : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['travel_id'] = travelId;
    data['travel_id_api'] = travelIdApi;
    data['pass_order'] = passOrder;
    data['type_operation'] = typeOperation;
    data['city'] = city;
    data['state'] = state;
    data['address'] = address;
    data['neighborhood'] = neighborhood;
    data['country'] = country;
    data['zip_code'] = zipCode;
    data['number'] = number;
    data['complement'] = complement;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['estimated_departure'] = estimatedDeparture?.toString();
    data['estimated_arrival'] = estimatedArrival?.toString();
    data['real_departure'] = realDeparture?.toString();
    data['real_arrival'] = realArrival?.toString();
    data['client'] = client?.toJson();
    return data;
  }

  @override
  String toString() {
    return 'AddressModel{id: $id, travelId: $travelId, travelIdApi: $travelIdApi, passOrder: $passOrder, typeOperation: $typeOperation, city: $city, state: $state, address: $address, neighborhood: $neighborhood, country: $country, zipCode: $zipCode, number: $number, complement: $complement, latitude: $latitude, longitude: $longitude, estimatedDeparture: $estimatedDeparture, estimatedArrival: $estimatedArrival, realDeparture: $realDeparture, realArrival: $realArrival}';
  }
}
