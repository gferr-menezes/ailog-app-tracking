class ClientModel {
  int? id;
  int? addressId;
  int? travelId;
  String? travelIdApi;
  String name;
  String? typeDocument;
  String? documentNumber;
  String? documentNumberWithoutMask;
  String? cellPhone;
  String? phone;

  ClientModel({
    this.id,
    this.addressId,
    this.travelId,
    this.travelIdApi,
    required this.name,
    this.typeDocument,
    this.documentNumber,
    this.documentNumberWithoutMask,
    this.cellPhone,
    this.phone,
  });

  ClientModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        addressId = json['address_id'],
        travelId = json['travel_id'],
        travelIdApi = json['travel_id_api'],
        name = json['name'],
        typeDocument = json['type_document'],
        documentNumber = json['document_number'],
        documentNumberWithoutMask = json['document_number_without_mask'],
        cellPhone = json['cell_phone'],
        phone = json['phone'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address_id'] = addressId;
    data['travel_id'] = travelId;
    data['travel_id_api'] = travelIdApi;
    data['name'] = name;
    data['type_document'] = typeDocument;
    data['document_number'] = documentNumber;
    data['document_number_without_mask'] = documentNumberWithoutMask;
    data['cell_phone'] = cellPhone;
    data['phone'] = phone;
    return data;
  }

  @override
  String toString() {
    return 'ClientModel{id: $id, addressId: $addressId, travelId: $travelId, travelIdApi: $travelIdApi, name: $name, typeDocument: $typeDocument, documentNumber: $documentNumber, documentNumberWithoutMask: $documentNumberWithoutMask, cellPhone: $cellPhone, phone: $phone}';
  }
}
