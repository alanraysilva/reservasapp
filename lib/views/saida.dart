import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reservas/models/airbndmdl.dart';
import 'package:reservas/services/reservasapi.dart';
import 'package:reservas/utils/ferramentas.dart';
import 'package:reservas/utils/utils.dart';
import 'package:reservas/views/editarsaida.dart';
import 'package:reservas/globals.dart' as globals;

class Saida extends StatefulWidget {
  const Saida({Key? key}) : super(key: key);

  @override
  _SaidaState createState() => _SaidaState();
}

class _SaidaState extends State<Saida> {
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
              criabordalateral(),
              textoinicial(),
              consultaReservas()
            ],
          ),
        )
    );
  }

  criabordalateral() {
    return Container(
      height: 250.0,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
              bottom: 0,
              top: -260.0,
              right: -1100.0 + (MediaQuery.of(context).size.width),
              child: Container(
                height: 300.0,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryBlack
                ),
              )
          )
        ],
      ),
    );
  }

  textoinicial() {
    return Positioned(
        top: 60.0,
        left: MediaQuery.of(context).size.width / 3,
        child: Container(
          padding: const EdgeInsets.only(top: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              Texts.CheckOutText,
            ],
          ),
        )
    );
  }

  consultaReservas()  {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          SizedBox(height: 100,),
          Container(
            height: MediaQuery.of(context).size.height - 90,
            child: FutureBuilder(
                future: getReservas(context, 2),
                initialData: "Aguardando os dados...",
                builder:  (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting: return globals.loadingDados();
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
                                      Dismissible(
                                        key: Key('item ${lst[i]}'),
                                        direction: DismissDirection.endToStart,
                                        confirmDismiss: (DismissDirection direction) async{
                                          if(direction == DismissDirection.endToStart){
                                            return inativaReserva(mdl);
                                          }
                                        } ,
                                        background: Container(
                                          color: Colors.red,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: const <Widget>[
                                              Icon(Icons.delete_forever_outlined,
                                                size: 35,)
                                            ],
                                          ),
                                        ),
                                        child: InkWell(
                                          child: _buildExchangeRate(Color(0xFFFF7B2B), mdl.objApartamento.numero.toString(),
                                              mdl.hospede.toString(),
                                              DataUtil.formataDataComDiaExtenso(mdl.entrada)
                                                  + ' à ' +  DataUtil.formataDataComDiaExtenso(mdl.saida),
                                              verificaDiaLimpeza(mdl),
                                              verificaProximaReseva(mdl),
                                              verificaGaragem(mdl), mdl,
                                              context),
                                          onTap: () => Navigator.push(context,
                                              MaterialPageRoute(builder: (context) =>
                                                  EditarSaida(airbndmdl: mdl))),
                                        ),
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
      String currencyCode, String amount, String dialimpeza,
      String proximaReserva, String garagem,
      Airbndmdl mdl, BuildContext context) {
    return Container(
      height: 160.0,
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
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
                  ),
                  Text(
                    dialimpeza,
                    style: TextStyle(
                      fontFamily: Fonts.primaryFont,
                      //color: Colors.white.withOpacity(0.8),
                      color: Colors.black.withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    proximaReserva,
                    style: TextStyle(
                      fontFamily: Fonts.primaryFont,
                      //color: Colors.white.withOpacity(0.8),
                      color: Colors.black.withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          verificaPendencia(mdl)
        ],
      ),
    );
  }

  verificaPendencia(Airbndmdl mdl) {
    if(mdl.verificadoSaida != 'S'){
      return Positioned(
          top: 15.0,
          right: 20.0,
          child: Image(
            image: AssetImage('assets/dialogo/atencao.png'),
            height: 30,
            width: 30,
          )
      );
    } else {
      return Text('');
    }
  }


  String verificaGaragem(Airbndmdl mdl) {
    return "Garagem: " + (mdl.objGaragem != null ? mdl.objGaragem!.numero.toString(): "");
  }

  String verificaDiaLimpeza(Airbndmdl mdl) {
    if(mdl.dataLimpeza != null){
      if(mdl.objFuncionario != null) {
        DateTime dt = DateTime.parse(mdl.dataLimpeza.toString());
        return "Dt. Faxina: " + DataUtil.formataDataComDiaExtenso(dt)
            + ' - ' + mdl.objFuncionario!.nome.toString();
      } else {
        DateTime dt = DateTime.parse(mdl.dataLimpeza.toString());
        return "Dt. Faxina: " + DataUtil.formataDataComDiaExtenso(dt);
      }
    }
    else {
      return "Dt. Faxina: ";
    }
  }

  String verificaProximaReseva(Airbndmdl mdl) {
    if(mdl.proximaEntrada != null){
      DateTime dt = DateTime.parse(mdl.proximaEntrada.toString());
      return "Próx. Reserva: " + DataUtil.formataDataComDiaExtenso(dt);
    }
    else {
      return "Próx. Reserva: ";
    }
  }

  inativaReserva(Airbndmdl mdl) {
    String msg = '';
    msg = 'Você tem certeza que deseja excluir a reserva do hospede : ' + mdl.hospede.toString() + '?';

    return confirma(context, 'Reservas', msg).then((onValue) async {
      if(onValue == true){
        mdl.status = 'I';
        String msg = await deletarReserva(mdl,'Atualizando', context );
        if (msg != 'Registro atualizado com sucesso.'){
          mostraMensage(context, "Erro", msg,1);
          return false;
        } else {
          return true;
        }
      }
    });
  }

}
