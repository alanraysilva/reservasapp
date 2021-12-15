import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:reservas/models/apartamentomdl.dart';
import 'package:reservas/models/funcionariomdl.dart';
import 'package:reservas/models/garagemmdl.dart';
part 'airbndmdl.g.dart';

@JsonSerializable()
class Airbndmdl {
  int id;
  String? codigo;
  String? status;
  String? hospede;
  String? telefone;
  int qtdeAdultos;
  int qtdeCriancas;
  int qtdeBebes;
  int noites;
  DateTime entrada;
  DateTime saida;
  DateTime dtReserva;
  double? ganhos;
  String? descricao;
  String? pedido;
  DateTime? proximaEntrada;
  ApartamentoMdl objApartamento;
  GaragemMdl? objGaragem;
  String? verificadoEntrada;
  String? verificadoSaida;
  DateTime? dataLimpeza;
  double? valorLimpeza;
  String? observacaoLimpeza;
  FuncionarioMdl? objFuncionario;
  String? situacao;


  Airbndmdl(this.id, this.codigo, this.status, this.hospede, this.telefone,
      this.qtdeAdultos, this.qtdeCriancas, this.qtdeBebes, this.noites,
      this.entrada, this.saida, this.dtReserva, this.ganhos, this.descricao,
      this.pedido, this.proximaEntrada, this.objApartamento,
      this.objGaragem, this.verificadoEntrada, this.verificadoSaida,
      this.dataLimpeza, this.valorLimpeza, this.observacaoLimpeza,
      this.objFuncionario, this.situacao);

  factory Airbndmdl.fromJson(Map<String, dynamic> json) => _$AirbndmdlFromJson(json);
  Map<String, dynamic> toJson() => _$AirbndmdlToJson(this);
}