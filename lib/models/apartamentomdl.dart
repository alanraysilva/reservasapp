import 'package:json_annotation/json_annotation.dart';
part 'apartamentomdl.g.dart';

@JsonSerializable()
class ApartamentoMdl{
  int id;
  int numero;
  String? descricao;
  String possuiGaragem;
  String status;
  String? horarioEntrada;
  String? horarioSaida;

  ApartamentoMdl(this.id, this.numero, this.descricao, this.possuiGaragem,
      this.status, this.horarioEntrada, this.horarioSaida);

  factory ApartamentoMdl.fromJson(Map<String, dynamic> json) => _$ApartamentoMdlFromJson(json);
  Map<String, dynamic> toJson() => _$ApartamentoMdlToJson(this);

}