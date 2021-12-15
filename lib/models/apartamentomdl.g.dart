// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apartamentomdl.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApartamentoMdl _$ApartamentoMdlFromJson(Map<String, dynamic> json) =>
    ApartamentoMdl(
      json['id'] as int,
      json['numero'] as int,
      json['descricao'] as String?,
      json['possuiGaragem'] as String,
      json['status'] as String,
    );

Map<String, dynamic> _$ApartamentoMdlToJson(ApartamentoMdl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'numero': instance.numero,
      'descricao': instance.descricao,
      'possuiGaragem': instance.possuiGaragem,
      'status': instance.status,
    };
