// ignore_for_file: constant_identifier_names

class RotogramModel {
  int? id;
  int idViagemLocal;
  int idViagemApi;
  String descricao;
  String urlIcone;
  double distanciaPercorridaKm;
  int tempoViagemSegundos;
  InformacaoPontoInstrucaoRotograma informacaoPonto;
  SentidoRota sentido;

  RotogramModel({
    this.id,
    required this.idViagemLocal,
    required this.idViagemApi,
    required this.descricao,
    required this.urlIcone,
    required this.distanciaPercorridaKm,
    required this.tempoViagemSegundos,
    required this.informacaoPonto,
    required this.sentido,
  });

  RotogramModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        idViagemLocal = json['idViagemLocal'],
        idViagemApi = json['idViagemApi'],
        descricao = json['descricao'],
        urlIcone = json['urlIcone'],
        distanciaPercorridaKm = json['distanciaPercorridaKm'],
        tempoViagemSegundos = json['tempoViagemSegundos'],
        informacaoPonto = InformacaoPontoInstrucaoRotograma.fromJson(json['informacaoPonto']),
        sentido = json['sentido'] == 'IDA' ? SentidoRota.IDA : SentidoRota.VOLTA;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idViagemLocal'] = idViagemLocal;
    data['idViagemApi'] = idViagemApi;
    data['descricao'] = descricao;
    data['urlIcone'] = urlIcone;
    data['distanciaPercorridaKm'] = distanciaPercorridaKm;
    data['tempoViagemSegundos'] = tempoViagemSegundos;
    data['informacaoPonto'] = informacaoPonto.toJson();
    data['sentido'] = sentido == SentidoRota.IDA ? 'IDA' : 'VOLTA';
    return data;
  }
}

class InformacaoPontoInstrucaoRotograma {
  int id;
  int ordemPassagem;
  double valor;
  double valorDesconto;
  ValorPedagioFimSemanaVO informacaoFimDeSemana;
  String? categoriaVeiculo;

  InformacaoPontoInstrucaoRotograma({
    required this.id,
    required this.ordemPassagem,
    required this.valor,
    required this.valorDesconto,
    required this.informacaoFimDeSemana,
    this.categoriaVeiculo,
  });

  InformacaoPontoInstrucaoRotograma.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        ordemPassagem = json['ordemPassagem'],
        valor = json['valor'],
        valorDesconto = json['valorDesconto'],
        informacaoFimDeSemana = ValorPedagioFimSemanaVO.fromJson(json['informacaoFimDeSemana']),
        categoriaVeiculo = json['categoriaVeiculo'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ordemPassagem'] = ordemPassagem;
    data['valor'] = valor;
    data['valorDesconto'] = valorDesconto;
    data['informacaoFimDeSemana'] = informacaoFimDeSemana.toJson();
    data['categoriaVeiculo'] = categoriaVeiculo;
    return data;
  }

  @override
  String toString() {
    return 'InformacaoPontoInstrucaoRotograma{id: $id, ordemPassagem: $ordemPassagem, valor: $valor, valorDesconto: $valorDesconto, informacaoFimDeSemana: $informacaoFimDeSemana, categoriaVeiculo: $categoriaVeiculo}';
  }
}

class ValorPedagioFimSemanaVO {
  bool alteraValor;
  String diaInicio;
  String horaInicioCobranca;
  String diaFim;
  String horaFimCobranca;
  double valor;
  double valorTag;

  ValorPedagioFimSemanaVO({
    required this.alteraValor,
    required this.diaInicio,
    required this.horaInicioCobranca,
    required this.diaFim,
    required this.horaFimCobranca,
    required this.valor,
    required this.valorTag,
  });

  ValorPedagioFimSemanaVO.fromJson(Map<String, dynamic> json)
      : alteraValor = json['alteraValor'],
        diaInicio = json['diaInicio'],
        horaInicioCobranca = json['horaInicioCobranca'],
        diaFim = json['diaFim'],
        horaFimCobranca = json['horaFimCobranca'],
        valor = json['valor'],
        valorTag = json['valorTag'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['alteraValor'] = alteraValor;
    data['diaInicio'] = diaInicio;
    data['horaInicioCobranca'] = horaInicioCobranca;
    data['diaFim'] = diaFim;
    data['horaFimCobranca'] = horaFimCobranca;
    data['valor'] = valor;
    data['valorTag'] = valorTag;
    return data;
  }

  @override
  String toString() {
    return 'ValorPedagioFimSemanaVO{alteraValor: $alteraValor, diaInicio: $diaInicio, horaInicioCobranca: $horaInicioCobranca, diaFim: $diaFim, horaFimCobranca: $horaFimCobranca, valor: $valor, valorTag: $valorTag}';
  }
}

enum SentidoRota {
  IDA,
  VOLTA,
}

enum DiaSemana {
  DOMINGO,
  SEGUNDA,
  TERCA,
  QUARTA,
  QUINTA,
  SEXTA,
  SABADO;
}
