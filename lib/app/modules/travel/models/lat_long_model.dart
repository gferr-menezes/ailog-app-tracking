class LatLongModel {
  double? latitude;
  double? longitude;

  LatLongModel({this.latitude, this.longitude});

  LatLongModel.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['latitude'] = longitude;
    return data;
  }

  @override
  String toString() {
    return 'LatLongModel{latitude: $latitude, latitude: $longitude}';
  }
}
