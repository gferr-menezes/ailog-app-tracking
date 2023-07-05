// ignore_for_file: constant_identifier_names

class TypeOccurenceModel {
  int? id;
  final String? typeOperation;
  final String? code;
  final String? description;
  bool? lateTravel = false;
  bool? endTravel = false;
  bool? endPassagePoint = false;

  TypeOccurenceModel({
    this.id,
    required this.typeOperation,
    this.code,
    this.description,
    this.lateTravel,
    this.endTravel,
    this.endPassagePoint,
  });

  factory TypeOccurenceModel.fromJson(Map<String, dynamic> json) {
    return TypeOccurenceModel(
      id: json['id'],
      typeOperation: json['tipoOperacao'],
      code: json['codigo'],
      description: json['descricao'],
      lateTravel: json['causaAtrasoViagem'],
      endTravel: json['encerraViagem'],
      endPassagePoint: json['encerraPontoPassagem'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tipoOperacao'] = typeOperation;
    data['codigo'] = code;
    data['descricao'] = description;
    data['causaAtrasoViagem'] = lateTravel;
    data['encerraViagem'] = endTravel;
    data['encerraPontoPassagem'] = endPassagePoint;
    return data;
  }

  @override
  String toString() {
    return 'TypeOccurenceModel{id: $id, typeOperation: $typeOperation, code: $code, description: $description, lateTravel: $lateTravel, endTravel: $endTravel, endPassagePoint: $endPassagePoint}';
  }
}

enum TypeOperation { NAO_DEFINIDO, VISITA, COLETA, ENTREGA }
