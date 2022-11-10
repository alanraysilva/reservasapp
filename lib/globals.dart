library reservas.globals;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


//String baseUrlTeste = 'https://10.0.2.2:5001';
//String baseUrlTeste = 'https://101.102.100.78:5001';
String baseUrlTeste = 'http://reservasapi-env.eba-ps27spem.us-east-2.elasticbeanstalk.com';
String BasicAutenticate = 'Basic cmVzZXJ2YTpTVzRANHYjbw==';

TextStyle fomataTituloCampos(){
  return const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 16
  );
}

TextStyle fomataFonteDinheiro(){
  return const TextStyle(
      color: Color(0xff00C853),
      fontWeight: FontWeight.bold,
      fontSize: 16
  );
}

TextStyle fomataDadosDinheiro(){
  return const TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.bold,
      fontSize: 14
  );
}

//TESTE

TextStyle fomataDados(){
  return const TextStyle(
      color: Colors.black,
      fontSize: 14
  );
}

TextStyle fomataTituloMenu(){
  return const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 18
  );
}

String formatTimeOfDay(TimeOfDay tod) {
  final now = new DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
  return DateFormat('HH:mm').format(dt);
}

DateTime juntaDatahora(String dt, String hr){
  DateTime dh = DateFormat('dd/MM/yyyy HH:mm').parse(dt + ' ' +  hr);
  return dh;
}


String formataMoeda(double? valor, bool usarmascara){
  if(valor != null){
    String res = '';
    String vl = NumberFormat.currency(locale: 'BR', decimalDigits: 2, symbol: '').format(valor);
    if (usarmascara == true){
      res = 'R\$';
    }
    return res + vl;
  }else {
    return 'R\$0,00';
  }

}

Widget loadingDados(){
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Aguardando os dados...",
            style: TextStyle(
              fontSize: 28.0,
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
            )
          ),
        ],
      ),
    ],
  );
}

String formataTelefone(String numero){
  //19992266794  //193226-0861   //992266794   //32660861
  //numero = '32660861';
  if(numero.length == 11){
    return '(' + numero.substring(0,2) + ')' + numero.substring(2,7) + '-' + numero.substring(7,11);
  } else if(numero.length == 10){
    return '(' + numero.substring(0,2) + ')' + numero.substring(2,6) + '-' + numero.substring(7,10);
  } else if(numero.length == 9){
    return numero.substring(0,5) + '-' + numero.substring(5,9);
  } else if(numero.length == 8){
    return numero.substring(0,4) + '-' + numero.substring(4,8);
  } else{
    return numero;
  }

}

DateTime PrimeiroDiadoMes(DateTime date){
  return DateTime(date.year, date.month, 01);
}
DateTime UltimoDiadoMes(DateTime date){
  return DateTime(date.year, date.month + 1, -01);
}


// Comando para criar classe automatico
// flutter pub run build_runner build
//flutter pub run build_runner build --delete-conflicting-outputs