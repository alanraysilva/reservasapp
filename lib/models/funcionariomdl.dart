import 'package:json_annotation/json_annotation.dart';
part 'funcionariomdl.g.dart';

@JsonSerializable()
class FuncionarioMdl{
  int id;
  String nome;
  String telefone;
  String status;

  FuncionarioMdl(this.id, this.nome, this.telefone, this.status);


  factory FuncionarioMdl.fromJson(Map<String, dynamic> json) => _$FuncionarioMdlFromJson(json);
  Map<String, dynamic> toJson() => _$FuncionarioMdlToJson(this);

}