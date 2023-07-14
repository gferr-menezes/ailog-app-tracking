import 'package:ailog_app_tracking/app/modules/travel/models/rotogram_model.dart';

import 'address_model.dart';
import 'toll_model.dart';

class TravelModel {
  int? id;
  String? code;
  String? travelIdApi;
  DateTime? estimatedDeparture;
  DateTime? estimatedArrival;
  String? vpoEmitName;
  double? valueTotal;
  String? plate;
  String? status;
  List<AddressModel>? addresses;
  List<TollModel>? tolls;
  List<RotogramModel>? rotograms;

  TravelModel({
    this.id,
    this.code,
    this.travelIdApi,
    this.estimatedDeparture,
    this.estimatedArrival,
    this.vpoEmitName,
    this.valueTotal,
    this.plate,
    this.status,
    this.addresses,
    this.tolls,
    this.rotograms,
  });

  TravelModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        code = json['code'],
        travelIdApi = json['travel_id_api'],
        estimatedDeparture = DateTime.parse(json['estimated_departure']),
        estimatedArrival = DateTime.parse(json['estimated_arrival']),
        vpoEmitName = json['vpo_emit_name'],
        valueTotal = json['value_total'],
        plate = json['plate'],
        status = json['status'] ?? StatusTravel.inProgress.name,
        addresses = json['addresses'] != null
            ? (json['addresses'] as List).map((e) => AddressModel.fromJson(e)).toList()
            : null,
        tolls = json['tolls'] != null ? (json['tolls'] as List).map((e) => TollModel.fromJson(e)).toList() : null,
        rotograms = json['rotograma']?['instrucoes'] != null
            ? (json['rotograma']['instrucoes'] as List).map((e) => RotogramModel.fromJson(e)).toList()
            : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['travel_id_api'] = travelIdApi;
    data['estimated_departure'] = estimatedDeparture.toString();
    data['estimated_arrival'] = estimatedArrival.toString();
    data['vpo_emit_name'] = vpoEmitName;
    data['value_total'] = valueTotal;
    data['plate'] = plate;
    data['status'] = status ?? StatusTravel.inProgress.name;
    data['addresses'] = addresses?.map((e) => e.toJson()).toList();
    data['tolls'] = tolls?.map((e) => e.toJson()).toList();
    data['rotograma'] = rotograms?.map((e) => e.toJson()).toList();
    return data;
  }

  @override
  String toString() {
    return 'TravelModel{id: $id, code: $code, travelIdApi: $travelIdApi, estimatedDeparture: $estimatedDeparture, estimatedArrival: $estimatedArrival, vpoEmitName: $vpoEmitName, valueTotal: $valueTotal, plate: $plate, status: $status addresses: $addresses, tolls: $tolls, rotograms: $rotograms}';
  }
}

///enum status
enum StatusTravel {
  waiting,
  inProgress,
  finished,
  canceled,
  error,
}
