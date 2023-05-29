class TollModel {
  int? id;
  int? travelId;
  String? travelIdApi;
  String tollName;
  int passOrder;
  int quantityAxes;
  int ailogId;
  String concessionaire;
  String highway;
  DateTime? datePassage;
  double valueTag;
  double valueManual;
  bool? acceptAutomaticBilling;
  bool? acceptPaymentProximity;
  double? latitude;
  double? longitude;

  TollModel({
    this.id,
    this.travelId,
    this.travelIdApi,
    required this.tollName,
    required this.passOrder,
    required this.quantityAxes,
    required this.ailogId,
    required this.concessionaire,
    required this.highway,
    this.datePassage,
    required this.valueTag,
    required this.valueManual,
    this.acceptAutomaticBilling,
    this.acceptPaymentProximity,
    this.latitude,
    this.longitude,
  });

  TollModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        travelId = json['travel_id'],
        travelIdApi = json['travel_id_api'],
        tollName = json['toll_name'],
        passOrder = json['pass_order'],
        quantityAxes = json['quantity_axes'],
        ailogId = json['ailog_id'],
        concessionaire = json['concessionaire'],
        highway = json['highway'],
        datePassage = json['date_passage'] != null ? DateTime.parse(json['date_passage']) : null,
        valueTag = json['value_tag'],
        valueManual = json['value_manual'],
        acceptAutomaticBilling = json['accept_automatic_billing'] == 1 ? true : false,
        acceptPaymentProximity = json['accept_payment_proximity'] == 1 ? true : false,
        latitude = json['latitude'],
        longitude = json['longitude'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['travel_id'] = travelId;
    data['travel_id_api'] = travelIdApi;
    data['toll_name'] = tollName;
    data['pass_order'] = passOrder;
    data['quantity_axes'] = quantityAxes;
    data['ailog_id'] = ailogId;
    data['concessionaire'] = concessionaire;
    data['highway'] = highway;
    data['date_passage'] = datePassage.toString();
    data['value_tag'] = valueTag;
    data['value_manual'] = valueManual;
    data['accept_automatic_billing'] = acceptAutomaticBilling;
    data['accept_payment_proximity'] = acceptPaymentProximity;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }

  @override
  String toString() {
    return 'TollModel{id: $id, travelId: $travelId, travelIdApi: $travelIdApi, tollName: $tollName, passOrder: $passOrder, quantityAxes: $quantityAxes, ailogId: $ailogId, concessionaire: $concessionaire, highway: $highway, datePassage: $datePassage, valueTag: $valueTag, valueManual: $valueManual, acceptAutomaticBilling: $acceptAutomaticBilling, acceptPaymentProximity: $acceptPaymentProximity, latitude: $latitude, longitude: $longitude}';
  }
}
