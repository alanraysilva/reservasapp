import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:reservas/models/airbndmdl.dart';
import 'package:reservas/services/reservasapi.dart';
import 'package:reservas/utils/utils.dart';

import 'package:reservas/globals.dart' as globals;
import 'package:reservas/views/reserva.dart';

class ReservasAntigas extends StatefulWidget {
  const ReservasAntigas({Key? key}) : super(key: key);

  @override
  State<ReservasAntigas> createState() => _ReservasAntigasState();
}

class _ReservasAntigasState extends State<ReservasAntigas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),

        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              //criabordalateral(),
              textoinicial(),
              consultaReservasAntigas()
            ],
          ),
        )
    );
  }

  textoinicial() {
    return Positioned(
        top: 60.0,
        left: MediaQuery.of(context).size.width / 4.5,
        child: Container(
          padding: const EdgeInsets.only(top: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              Texts.ReservasAntigasText,
            ],
          ),
        )
    );
  }
  consultaReservasAntigas()  {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          SizedBox(height: 100,),
          Container(
            height: MediaQuery.of(context).size.height - 90,
            child: FutureBuilder(
                future: getReservasAntigas(context, 1),
                initialData: "Aguardando os dados...",
                builder:  (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return globals.loadingDados();
                    default:
                      if(snapshot.hasError){
                        return Text(snapshot.hasError.toString());
                      }else{
                        List<Airbndmdl> lst = snapshot.data as List<Airbndmdl>;

                        return Scrollbar(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: lst.length,
                                itemBuilder:  (BuildContext context, int i) {
                                  Airbndmdl mdl = lst[i];
                                  return Column(
                                    children: [
                                      InkWell(
                                        child: _buildExchangeRate(Color(0xFF7E0E0E0), mdl.objApartamento.numero.toString(),
                                            mdl.hospede.toString(),
                                            DataUtil.formataDataComDiaExtenso(mdl.entrada)
                                                + ' à ' +  DataUtil.formataDataComDiaExtenso(mdl.saida),
                                            verificaGaragem(mdl), mdl,
                                            context),
                                        onTap: () => Navigator.push(context,
                                            MaterialPageRoute(builder: (context) =>
                                                Reserva(airbndmdl: mdl))),
                                      ),
                                      SizedBox(
                                        height: 15.0,
                                      )
                                    ],
                                  );

                                }
                            )
                        );
                      }
                  }
                }
            ),
          )
        ],
      ),
    );
  }

  Widget _buildExchangeRate(Color color, String currencyName,
      String currencyCode, String amount, String garagem, Airbndmdl mdl, BuildContext context) {
    return Container(
      height: 120.0,
      width: MediaQuery.of(context).size.width - 30.0,
      decoration: BoxDecoration(
        color: color.withAlpha(220),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.elliptical(90.0, 110.0),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width / 2 - 20,
                decoration: BoxDecoration(color: color),
              ),
            ),
          ),
          Positioned(
            top: 10.0,
            left: 20.0,
            child: Container(
              padding: const EdgeInsets.all(2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    currencyName,
                    style: TextStyle(
                      fontFamily: Fonts.primaryFont,
                      //color: Colors.white.withOpacity(0.8),
                      color: Colors.black.withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    currencyCode,
                    style: TextStyle(
                      fontFamily: Fonts.primaryFont,
                      //color: Colors.white.withOpacity(0.8),
                      color: Colors.black.withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    amount,
                    style: TextStyle(
                      fontFamily: Fonts.primaryFont,
                      //color: Colors.white.withOpacity(0.8),
                      color: Colors.black.withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    garagem,
                    style: TextStyle(
                      fontFamily: Fonts.primaryFont,
                      //color: Colors.white.withOpacity(0.8),
                      color: Colors.black.withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  )
                ],
              ),
            ),
          ),
          //verificaPendencia(mdl),
          //verificaConflitoGaragem(mdl)
        ],
      ),
    );
  }

}

String verificaGaragem(Airbndmdl mdl) {
  return "Garagem: " + (mdl.objGaragem != null ? mdl.objGaragem!.numero.toString(): "");
}