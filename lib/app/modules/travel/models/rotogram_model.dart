// ignore_for_file: constant_identifier_names

import 'package:ailog_app_tracking/app/modules/travel/models/lat_long_model.dart';

class RotogramModel {
  int? id;
  int? travelId;
  String? travelIdApi;
  String? description;
  String? urlIcon;
  double? distanceTraveledKm;
  int? travelTimeSeconds;
  String? distanceTraveledFormatted;
  InformationPointRotogramModel? informationPoint;
  DirectionRoute? directionRoute;
  LatLongModel? latLng;

  RotogramModel({
    this.id,
    this.travelId,
    this.travelIdApi,
    this.description,
    this.urlIcon,
    this.distanceTraveledKm,
    this.distanceTraveledFormatted,
    this.travelTimeSeconds,
    this.informationPoint,
    this.directionRoute,
    this.latLng,
  });

  RotogramModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        travelId = json['travel_id'],
        travelIdApi = json['travel_id_api'],
        description = json['descricao'],
        urlIcon = json['urlIcone'],
        distanceTraveledKm = json['distanciaPercorridaKm'],
        distanceTraveledFormatted = json['tempoViagemFormatado'],
        travelTimeSeconds = json['tempoViagemSegundos'] as int?,
        informationPoint =
            json['informacaoPonto'] != null ? InformationPointRotogramModel.fromJson(json['informacaoPonto']) : null,
        directionRoute =
            json['sentido'] != null ? DirectionRoute.values.firstWhere((e) => e.name == json['sentido']) : null,
        latLng = json['latLng'] != null ? LatLongModel.fromJson(json['latLng']) : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['travel_id'] = travelId;
    data['travel_id_api'] = travelIdApi;
    data['descricao'] = description;
    data['urlIcone'] = urlIcon;
    data['distanciaPercorridaKm'] = distanceTraveledKm;
    data['tempoViagemFormatado'] = distanceTraveledFormatted;
    data['tempoViagemSegundos'] = travelTimeSeconds;
    data['informacaoPonto'] = informationPoint?.toJson();
    data['sentido'] = directionRoute?.name;
    data['latLng'] = latLng?.toJson();
    return data;
  }

  @override
  String toString() {
    return 'RotogramModel{id: $id, travelId: $travelId, travelIdApi: $travelIdApi, description: $description, urlIcon: $urlIcon, distanceTraveledKm: $distanceTraveledKm, distanceTraveledFormatted: $distanceTraveledFormatted, travelTimeSeconds: $travelTimeSeconds, informationPoint: $informationPoint, directionRoute: $directionRoute, latLng: $latLng}';
  }
}

class InformationPointRotogramModel {
  int? informationId;
  int? orderPassage;
  double? value;
  double? valueDiscount;
  ValueTollWeekModel? weekend;
  String? categoryVehicle;

  InformationPointRotogramModel({
    this.informationId,
    this.orderPassage,
    this.value,
    this.valueDiscount,
    this.weekend,
    this.categoryVehicle,
  });

  InformationPointRotogramModel.fromJson(Map<String, dynamic> json)
      : informationId = json['id'],
        orderPassage = json['ordemPassagem'],
        value = json['valor'],
        valueDiscount = json['valorDesconto'],
        weekend = json['fimSemana'] != null ? ValueTollWeekModel.fromJson(json['fimSemana']) : null,
        categoryVehicle = json['categoriaVeiculo'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = informationId;
    data['ordemPassagem'] = orderPassage;
    data['valor'] = value;
    data['valorDesconto'] = valueDiscount;
    data['fimSemana'] = weekend?.toJson();
    data['categoriaVeiculo'] = categoryVehicle;
    return data;
  }

  @override
  String toString() {
    return 'InformationPointRotogramModel{informationId: $informationId, orderPassage: $orderPassage, value: $value, valueDiscount: $valueDiscount, weekend: $weekend, categoryVehicle: $categoryVehicle}';
  }
}

class ValueTollWeekModel {
  bool? changeValue;
  String? dayStart;
  String? hourStart;
  String? dayEnd;
  String? hourEnd;
  double? value;
  double? valueTag;

  ValueTollWeekModel({
    this.changeValue,
    this.dayStart,
    this.hourStart,
    this.dayEnd,
    this.hourEnd,
    this.value,
    this.valueTag,
  });

  ValueTollWeekModel.fromJson(Map<String, dynamic> json)
      : changeValue = json['alteraValor'],
        dayStart = json['diaInicio'],
        hourStart = json['horaInicio'],
        dayEnd = json['diaFim'],
        hourEnd = json['horaFim'],
        value = json['valor'],
        valueTag = json['valorTag'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['alteraValor'] = changeValue;
    data['diaInicio'] = dayStart;
    data['horaInicio'] = hourStart;
    data['diaFim'] = dayEnd;
    data['horaFim'] = hourEnd;
    data['valor'] = value;
    data['valorTag'] = valueTag;
    return data;
  }

  @override
  String toString() {
    return 'ValueTollWeekModel{changeValue: $changeValue, dayStart: $dayStart, hourStart: $hourStart, dayEnd: $dayEnd, hourEnd: $hourEnd, value: $value, valueTag: $valueTag}';
  }
}

enum DirectionRoute { IDA, VOLTA }
