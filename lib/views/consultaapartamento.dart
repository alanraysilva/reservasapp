import 'package:flutter/material.dart';
import 'package:reservas/models/apartamentomdl.dart';
import 'package:reservas/services/apartamentoapi.dart';
import 'package:reservas/utils/ferramentas.dart';
import 'package:reservas/utils/utils.dart';
import 'package:reservas/views/cadastroapartamento.dart';

class ConsultaApartamento extends StatefulWidget {
  const ConsultaApartamento({Key? key}) : super(key: key);

  @override
  _ConsultaApartamentoState createState() => _ConsultaApartamentoState();
}

class _ConsultaApartamentoState extends State<ConsultaApartamento> {
  ApartamentoMdl novo = ApartamentoMdl(0, 1, '', '', 'A');
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          InkWell(
            customBorder: CircleBorder(),
            onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => CadastroApartamento(apartamentoMdl: novo))),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(Icons.add,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(height: MediaQuery.of(context).size.height),
          criabordalateral(),
          criaItens(),
        ],
      ),
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

  criaItens() {
    return ListView(
      children: <Widget>[
        textoinicial(),
        SizedBox(height: 20),
        consultaApartamento()
      ],
    );
  }

  textoinicial() {
    return Container(
      padding: const EdgeInsets.only(top: 5.0),
      child: Column(
        children: const <Widget>[
          Texts.ApartamentoText,
        ],
      ),
    );
  }

  consultaApartamento() {
    return Container(
        padding: EdgeInsets.all(5.0),
        child: FutureBuilder(
            future: getApartamento(context),
            initialData: "Aguardando os dados...",
            builder:  (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting: return const CircularProgressIndicator();
                default:
                  if(snapshot.hasError){
                    return Text(snapshot.hasError.toString());
                  }else{
                    List<ApartamentoMdl> lst = snapshot.data as List<ApartamentoMdl>;
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: lst.length,
                        itemBuilder:  (BuildContext context, int i) {
                          ApartamentoMdl mdl = lst[i];
                          return Dismissible(
                              key: Key('item ${lst[i]}'),
                              direction: DismissDirection.endToStart,
                              confirmDismiss: (DismissDirection direction) async{
                                if(direction == DismissDirection.endToStart){
                                  return inativaApartamento(mdl);
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
                              child: criaItem(mdl)
                          );
                        }
                    );
                  }
              }
            }
        )
    );
  }

  inativaApartamento(ApartamentoMdl mdl) {
    String msg = '';
    msg = 'Você tem certeza que deseja excluir esse apartamento : ' + mdl.numero.toString() + '?';

    return confirma(context, 'Reservas', msg).then((onValue) async {
      if(onValue == true){
        mdl.status = 'I';
        String msg = await atualizarApartamento(mdl,'Atualizando', context );
        if (msg != 'Registro atualizado com sucesso.'){
          mostraMensage(context, "Erro", msg,1);
          return false;
        } else {
          return true;
        }
      }
    });
  }

  criaItem(ApartamentoMdl mdl) {
    return InkWell(
      child: ListTile(
        leading: const CircleAvatar(
          backgroundImage: AssetImage('assets/images/apartamento.png'),
          radius: 25.0,
        ),
        title: Text(mdl.numero.toString(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        subtitle: Text(verificaDescricao(mdl), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      ),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CadastroApartamento(apartamentoMdl: mdl))),
    );
  }

  String verificaDescricao(ApartamentoMdl mdl) {
    if(mdl.descricao != null) {
      return mdl.descricao.toString();
    } else {
      return "";
    }
  }

}
