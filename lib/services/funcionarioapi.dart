import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:reservas/globals.dart' as globals;
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:reservas/models/funcionariomdl.dart';
import 'package:reservas/utils/ferramentas.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

Future<List<FuncionarioMdl>>getFuncionarios(BuildContext context) async{
  try{
    final Dio dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
    String apiUrl =  globals.baseUrlTeste + '/api/Funcionario/GetFuncionario';
    Response response = await dio.get(apiUrl,
      options: Options(headers: {
        HttpHeaders.authorizationHeader:globals.BasicAutenticate,
      }),
    );
    var getFuncionariosData = response.data as List;
    var listFuncionarios = getFuncionariosData.map((i) => FuncionarioMdl.fromJson(i)).toList();
    return listFuncionarios;

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


Future<String> atualizarFuncionario(FuncionarioMdl mdl, String msg, BuildContext context) async{
  ProgressDialog pd = ProgressDialog(context: context);
  pd.show(max: 100, msg: msg, progressType: ProgressType.valuable);

  try{
    final Dio dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
    String apiUrl =  globals.baseUrlTeste + '/api/Funcionario/Atualizar';
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

Future<String> cadastrarFuncionario(FuncionarioMdl mdl, String msg, BuildContext context) async{
  ProgressDialog pd = ProgressDialog(context: context);
  pd.show(max: 100, msg: msg, progressType: ProgressType.valuable);

  try{
    final Dio dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
    String apiUrl =  globals.baseUrlTeste + '/api/Funcionario/Cadastrar';
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