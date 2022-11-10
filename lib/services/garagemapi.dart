import 'dart:convert';
import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:reservas/models/garagemmdl.dart';
import 'package:reservas/globals.dart' as globals;
import 'package:reservas/utils/ferramentas.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

Future<List<GaragemMdl>>getGaragem(BuildContext context) async{
  try{
    final Dio dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
    String apiUrl =  globals.baseUrlTeste + '/api/Garagem/GetGaragem';
    Response response = await dio.get(apiUrl,
      options: Options(headers: {
        HttpHeaders.authorizationHeader:globals.BasicAutenticate,
      }),
    );
    var getGaragemData = response.data as List;
    var listGaragem = getGaragemData.map((i) => GaragemMdl.fromJson(i)).toList();
    return listGaragem;

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

Future<String> cadastrarGaragem(GaragemMdl mdl, String msg, BuildContext context) async{
  ProgressDialog pd = ProgressDialog(context: context);
  pd.show(max: 100, msg: msg, progressType: ProgressType.valuable);

  try{
    final Dio dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
    String apiUrl =  globals.baseUrlTeste + '/api/Garagem/Cadastrar';
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

Future<String> atualizarGaragem(GaragemMdl mdl, String msg, BuildContext context) async{
  ProgressDialog pd = ProgressDialog(context: context);
  pd.show(max: 100, msg: msg, progressType: ProgressType.valuable);

  try{
    final Dio dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
    String apiUrl =  globals.baseUrlTeste + '/api/Garagem/AtualizarGaragem';
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