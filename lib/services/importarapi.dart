import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reservas/utils/ferramentas.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:reservas/globals.dart' as globals;

Future<String> importarArquivo(String diretorio, String arquivo, String msg, BuildContext context) async{
  ProgressDialog pd = ProgressDialog(context: context);
  pd.show(max: 100, msg: msg, progressType: ProgressType.valuable);

  try{
    final Dio dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
    String apiUrl = globals.baseUrlTeste + '/api/Reservas/ImportarReservas';
    var formdata = FormData.fromMap({
      'file': await MultipartFile.fromFile(diretorio, filename: arquivo)
    });
    Response response = await dio.post(apiUrl,
        options: Options(headers: {HttpHeaders.authorizationHeader: globals.BasicAutenticate}),
        data: formdata);
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