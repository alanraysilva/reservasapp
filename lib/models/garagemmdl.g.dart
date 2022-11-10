// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'garagemmdl.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GaragemMdl _$GaragemMdlFromJson(Map<String, dynamic> json) => GaragemMdl(
      json['id'] as int,
      json['numero'] as int,
      json['descricao'] as String?,
      json['status'] as String,
    );

Map<String, dynamic> _$GaragemMdlToJson(GaragemMdl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'numero': instance.numero,
      'descricao': instance.descricao,
      'status': instance.status,
    };
