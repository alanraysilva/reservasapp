// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'funcionariomdl.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FuncionarioMdl _$FuncionarioMdlFromJson(Map<String, dynamic> json) =>
    FuncionarioMdl(
      json['id'] as int,
      json['nome'] as String,
      json['telefone'] as String,
      json['status'] as String,
    );

Map<String, dynamic> _$FuncionarioMdlToJson(FuncionarioMdl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'telefone': instance.telefone,
      'status': instance.status,
    };
