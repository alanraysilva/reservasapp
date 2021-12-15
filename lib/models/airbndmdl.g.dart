// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'airbndmdl.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Airbndmdl _$AirbndmdlFromJson(Map<String, dynamic> json) => Airbndmdl(
      json['id'] as int,
      json['codigo'] as String?,
      json['status'] as String?,
      json['hospede'] as String?,
      json['telefone'] as String?,
      json['qtdeAdultos'] as int,
      json['qtdeCriancas'] as int,
      json['qtdeBebes'] as int,
      json['noites'] as int,
      DateTime.parse(json['entrada'] as String),
      DateTime.parse(json['saida'] as String),
      DateTime.parse(json['dtReserva'] as String),
      (json['ganhos'] as num?)?.toDouble(),
      json['descricao'] as String?,
      json['pedido'] as String?,
      json['proximaEntrada'] == null
          ? null
          : DateTime.parse(json['proximaEntrada'] as String),
      ApartamentoMdl.fromJson(json['objApartamento'] as Map<String, dynamic>),
      json['objGaragem'] == null
          ? null
          : GaragemMdl.fromJson(json['objGaragem'] as Map<String, dynamic>),
      json['verificadoEntrada'] as String?,
      json['verificadoSaida'] as String?,
      json['dataLimpeza'] == null
          ? null
          : DateTime.parse(json['dataLimpeza'] as String),
      (json['valorLimpeza'] as num?)?.toDouble(),
      json['observacaoLimpeza'] as String?,
      json['objFuncionario'] == null
          ? null
          : FuncionarioMdl.fromJson(
              json['objFuncionario'] as Map<String, dynamic>),
      json['situacao'] as String?,
    );

Map<String, dynamic> _$AirbndmdlToJson(Airbndmdl instance) => <String, dynamic>{
      'id': instance.id,
      'codigo': instance.codigo,
      'status': instance.status,
      'hospede': instance.hospede,
      'telefone': instance.telefone,
      'qtdeAdultos': instance.qtdeAdultos,
      'qtdeCriancas': instance.qtdeCriancas,
      'qtdeBebes': instance.qtdeBebes,
      'noites': instance.noites,
      'entrada': instance.entrada.toIso8601String(),
      'saida': instance.saida.toIso8601String(),
      'dtReserva': instance.dtReserva.toIso8601String(),
      'ganhos': instance.ganhos,
      'descricao': instance.descricao,
      'pedido': instance.pedido,
      'proximaEntrada': instance.proximaEntrada?.toIso8601String(),
      'objApartamento': instance.objApartamento,
      'objGaragem': instance.objGaragem,
      'verificadoEntrada': instance.verificadoEntrada,
      'verificadoSaida': instance.verificadoSaida,
      'dataLimpeza': instance.dataLimpeza?.toIso8601String(),
      'valorLimpeza': instance.valorLimpeza,
      'observacaoLimpeza': instance.observacaoLimpeza,
      'objFuncionario': instance.objFuncionario,
      'situacao': instance.situacao,
    };
