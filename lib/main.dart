import 'package:flutter/material.dart';
import 'package:reservas/views/cadastro.dart';
import 'package:reservas/views/calendario.dart';
import 'package:reservas/views/consultacheckin.dart';
import 'package:reservas/views/consultafaxina.dart';
import 'package:reservas/views/consultafuncionario.dart';
import 'package:reservas/views/consultagaragem.dart';
import 'package:reservas/views/home.dart';
import 'package:reservas/views/importar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [const Locale('pt', 'BR')],
      debugShowCheckedModeBanner: false,
      title: 'Reservas',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const Home(),
      routes: {
        '/home':(context) => const Home(),
        '/importar':(context) => const Importar(),
        '/funcionario':(context) => const ConsultaFuncionario(),
        '/garagem':(context) => const ConsultaGaragem(),
        '/calendario':(context) => const Calendario(),
        '/consultacheckin':(context) => const ConsultaCheckin(),
        '/consultafaxina':(context) => const ConsultaFaxina(),
        '/cadastro':(context) => const Cadastro(),
      },
    );
  }

}

