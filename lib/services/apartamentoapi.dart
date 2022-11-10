import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:reservas/globals.dart' as globals;
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:reservas/models/apartamentomdl.dart';
import 'package:reservas/utils/ferramentas.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

Future<List<ApartamentoMdl>>getApartamento(BuildContext context) async{
  try{
    final Dio dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
    String apiUrl =  globals.baseUrlTeste + '/api/Apartamento/GetApartamento';
    Response response = await dio.get(apiUrl,
      options: Options(headers: {
        HttpHeaders.authorizationHeader:globals.BasicAutenticate,
      }),
    );
    var getApartamentoData = response.data as List;
    var listApartamento = getApartamentoData.map((i) => ApartamentoMdl.fromJson(i)).toList();
    return listApartamento;

  }on DioError catch (e){
    if (e.response?.statusCode == HttpStatus.unauthorized){
      mostraMensage(context, "Erro", e.response!.data.toString(),1);
      throw("");
    }else if (e.response?.statusCode == HttpStatus.internalServerError){
      mostraMensage(context, "Erro", e.response!.data.toString(),1);
      throw("");
    }else if (e.response?.statusCode == HttpStatus.notFound){
      mostraMensage(context, "Erro", e.response!.data.toString(),1);
      throw("");
    }else{
      mostraMensage(context, "Erro", e.response!.data.toString(),1);
      throw("");
    }
  }
}

Future<String> cadastrarApartamento(ApartamentoMdl mdl, String msg, BuildContext context) async{
  ProgressDialog pd = ProgressDialog(context: context);
  pd.show(max: 100, msg: msg, progressType: ProgressType.valuable);

  try{
    final Dio dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
    String apiUrl =  globals.baseUrlTeste + '/api/Apartamento/Cadastrar';
    var jsonBody = jsonEncode(mdl);
    Response response = await dio.post(apiUrl,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader:globals.BasicAutenticate,
      }),
      data: jsonBody,
    );
    pd.close();
    return response.data;
  }on DioError catch (e){
    if (e.response?.statusCode == HttpStatus.unauthorized){
      pd.close();
      mostraMensage(context, "Erro", e.response!.data.toString(),1);
      throw("");
    }
    else if (e.response?.statusCode == HttpStatus.internalServerError){
      pd.close();
      mostraMensage(context, "Erro", e.response!.data.toString(),1);
      throw("");
    }
    else if (e.response?.statusCode == HttpStatus.notFound){
      pd.close();
      mostraMensage(context, "Erro", e.response!.data.toString(),1);
      throw("");
    }
    else{
      pd.close();
      mostraMensage(context, "Erro", e.response!.data.toString(),1);
      throw("");
    }
  }

}

Future<String> atualizarApartamento(ApartamentoMdl mdl, String msg, BuildContext context) async{
  ProgressDialog pd = ProgressDialog(context: context);
  pd.show(max: 100, msg: msg, progressType: ProgressType.valuable);

  try{
    final Dio dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
    String apiUrl =  globals.baseUrlTeste + '/api/Apartamento/AtualizarApartamento';
    var jsonBody = jsonEncode(mdl);
    Response response = await dio.put(apiUrl,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader:globals.BasicAutenticate,
      }),
      data: jsonBody,
    );
    pd.close();
    return response.data;
  }on DioError catch (e){
    if (e.response?.statusCode == HttpStatus.unauthorized){
      pd.close();
      mostraMensage(context, "Erro", e.response!.data.toString(),1);
      throw("");
    }
    else if (e.response?.statusCode == HttpStatus.internalServerError){
      pd.close();
      mostraMensage(context, "Erro", e.response!.data.toString(),1);
      throw("");
    }
    else if (e.response?.statusCode == HttpStatus.notFound){
      pd.close();
      mostraMensage(context, "Erro", e.response!.data.toString(),1);
      throw("");
    }
    else{
      pd.close();
      mostraMensage(context, "Erro", e.response!.data.toString(),1);
      throw("");
    }
  }

}