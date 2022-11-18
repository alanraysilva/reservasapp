import 'package:flutter/material.dart';
import 'package:reservas/utils/utils.dart';
import 'package:reservas/views/relatoriogaragem.dart';

import 'consultacheckin.dart';

class Relatorios extends StatefulWidget {
  const Relatorios({Key? key}) : super(key: key);

  @override
  State<Relatorios> createState() => _RelatoriosState();
}

class _RelatoriosState extends State<Relatorios> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0
      ),
      body: Stack(
        children: <Widget>[
          criaItens(),
        ],
      ),
    );
  }

  criaItens() {
    return ListView(
      children: <Widget>[
        textoinicial(),
        SizedBox(height: 50),
        criaBotaoRptEntrada(),
        SizedBox(height: 50),
        criaBotaoRptSaida(),
      ],
    );
  }

  textoinicial() {
    return Container(
      padding: const EdgeInsets.only(top: 5.0),
      child: Column(
        children: const <Widget>[
          Texts.RelatoriosText,
        ],
      ),
    );
  }
  // TESTE
  criaBotaoRptEntrada() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: MaterialButton(
        child: const Text('Entrada Check-in',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
        color: AppColors.primaryBlack,
        elevation: 0,
        minWidth: 350,
        height: 60,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
        ),
        onPressed: () => Navigator.push(context, MaterialPageRoute(
            builder: (context) => ConsultaCheckin())),
      ),
    );
  }

  criaBotaoRptSaida() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: MaterialButton(
        child: const Text('Garagem',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
        color: Colors.redAccent,
        elevation: 0,
        minWidth: 350,
        height: 60,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
        ),
        onPressed: () => Navigator.push(context, MaterialPageRoute(
            builder: (context) => RelatorioGaragem())),
      ),
    );
  }

}
