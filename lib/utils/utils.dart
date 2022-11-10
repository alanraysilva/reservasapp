import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


bool letrasMaiusculas = true;
bool letrasMinusculas = true;
bool numeros = true;
bool simbolos = true;

class AppColors {
  static const primaryBlack = const Color(0xFF313544);
  static const primaryBlue = const Color(0xFF272F5F);
  static const secondaryColor = const Color(0xFFFF8C33);
}


class Fonts {
  static const primaryFont = "Quicksand";
}

class Texts {
  static const welcomeText = Text(
    'Reservas',
    style: TextStyle(
      fontFamily: Fonts.primaryFont,
      fontSize: 28.0,
      color: AppColors.primaryBlue,
      fontWeight: FontWeight.bold,
    ),
  );

  static const ImportarText = Text(
    'Importar Dados',
    style: TextStyle(
      fontFamily: Fonts.primaryFont,
      fontSize: 28.0,
      color: AppColors.primaryBlue,
      fontWeight: FontWeight.bold,
    ),
  );

  static const FunciorioText = Text(
    'Funcionários',
    style: TextStyle(
      fontFamily: Fonts.primaryFont,
      fontSize: 28.0,
      color: AppColors.primaryBlue,
      fontWeight: FontWeight.bold,
    ),
  );

  static const GaragemText = Text(
    'Garagem',
    style: TextStyle(
      fontFamily: Fonts.primaryFont,
      fontSize: 28.0,
      color: AppColors.primaryBlue,
      fontWeight: FontWeight.bold,
    ),
  );

  static const CalendarioText = Text(
    'Calendário',
    style: TextStyle(
      fontFamily: Fonts.primaryFont,
      fontSize: 28.0,
      color: AppColors.primaryBlue,
      fontWeight: FontWeight.bold,
    ),
  );

  static const AgendaText = Text(
    'Agenda',
    style: TextStyle(
      fontFamily: Fonts.primaryFont,
      fontSize: 28.0,
      color: AppColors.primaryBlue,
      fontWeight: FontWeight.bold,
    ),
  );

  static const CheckInText = Text(
    'Check-in',
    style: TextStyle(
      fontFamily: Fonts.primaryFont,
      fontSize: 28.0,
      color: AppColors.primaryBlue,
      fontWeight: FontWeight.bold,
    ),
  );

  static const CheckOutText = Text(
    'Check-out',
    style: TextStyle(
      fontFamily: Fonts.primaryFont,
      fontSize: 28.0,
      color: AppColors.primaryBlue,
      fontWeight: FontWeight.bold,
    ),
  );

  static const ReservasAntigasText = Text(
    'Reservas Antigas',
    style: TextStyle(
      fontFamily: Fonts.primaryFont,
      fontSize: 28.0,
      color: AppColors.primaryBlue,
      fontWeight: FontWeight.bold,
    ),
  );

  static const RelatorioEntradaText = Text(
    'Relatório Entrada',
    style: TextStyle(
      fontFamily: Fonts.primaryFont,
      fontSize: 24.0,
      color: AppColors.primaryBlue,
      fontWeight: FontWeight.bold,
    ),
  );

  static const RelatorioFaxinaText = Text(
    'Relatório Faxina',
    style: TextStyle(
      fontFamily: Fonts.primaryFont,
      fontSize: 24.0,
      color: AppColors.primaryBlue,
      fontWeight: FontWeight.bold,
    ),
  );

  static const ApartamentoText = Text(
    'Apartamento',
    style: TextStyle(
      fontFamily: Fonts.primaryFont,
      fontSize: 28.0,
      color: AppColors.primaryBlue,
      fontWeight: FontWeight.bold,
    ),
  );

}

class Gerador {
  static String senhaGerada(bool letrasMai, bool letrasMin, bool numeros, bool simbolos) {
    String letrasMaiusculas = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    String letrasMinusculas = "abcdefghijklmnopqrstuvwxyz";
    String numbers = "0123456789";
    String symbolos = "!@#\$%&*(){}[]-_=+<>,./";

    int tam = 10;
    String senha = "";
    String senhaGer = "";
    senhaGer += (letrasMai ? letrasMaiusculas : "");
    senhaGer += (letrasMin ? letrasMinusculas : "");
    senhaGer += (numeros ? numbers : "");
    senhaGer += (simbolos ? symbolos : "");

    String pass = "";

    for(int i = 0; i < tam; i++) {
      int random = Random.secure().nextInt(senhaGer.length);
      pass += senhaGer[random];
      senha = pass;
    }

    return senha;

  }
}

class DataUtil{
  static String diaSemana (DateTime dt, bool abreviado){
    if(dt.weekday == 1){
      return abreviado ? 'Seg': 'Segunda - Feira';
    } else if(dt.weekday == 2){
      return abreviado ? 'Ter': 'Terça - Feira';
    } else if(dt.weekday == 3){
      return abreviado ? 'Qua': 'Quarta - Feira';
    } else if(dt.weekday == 4){
      return abreviado ? 'Qui': 'Quinta - Feira';
    } else if(dt.weekday == 5){
      return abreviado ? 'Sex': 'Sexta - Feira';
    } else if(dt.weekday == 6){
      return abreviado ? 'Sab': 'Sábado';
    } else {
      return abreviado ? 'Dom': 'Domingo';
    }
  }
  static String formataDataComDiaExtenso(DateTime? dt){
    // 01/02 Seg 00:00
    if (dt != null){
      String diaExtenso = diaSemana(dt, true);
      String diaMes = DateFormat('dd/MM').format(dt);
      return diaMes + ' ' + diaExtenso + ' ' + DateFormat('HH:mm').format(dt);
    } else {
      return '';
    }

  }
  static String formataDataComDiaExtensoSemHora(DateTime dt){
    // 01/02 Seg 00:00
    String diaExtenso = diaSemana(dt, true);
    String diaMes = DateFormat('dd/MM').format(dt);
    return diaMes + ' ' + diaExtenso;
  }

}