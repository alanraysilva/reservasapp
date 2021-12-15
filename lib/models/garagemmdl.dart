import 'package:json_annotation/json_annotation.dart';
part 'garagemmdl.g.dart';

@JsonSerializable()
class GaragemMdl{
  int id;
  int numero;
  String? descricao;
  String status;

  GaragemMdl(this.id, this.numero, this.descricao, this.status);

  factory GaragemMdl.fromJson(Map<String, dynamic> json) => _$GaragemMdlFromJson(json);
  Map<String, dynamic> toJson() => _$GaragemMdlToJson(this);

}