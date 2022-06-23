import 'package:flutter/material.dart';
import 'package:reservas/models/garagemmdl.dart';
import 'package:reservas/services/garagemapi.dart';
import 'package:reservas/utils/ferramentas.dart';
import 'package:reservas/utils/utils.dart';
import 'package:reservas/views/cadastrogaragem.dart';

class ConsultaGaragem extends StatefulWidget {
  const ConsultaGaragem({Key? key}) : super(key: key);

  @override
  _ConsultaGaragemState createState() => _ConsultaGaragemState();
}

class _ConsultaGaragemState extends State<ConsultaGaragem> {
  GaragemMdl novo = GaragemMdl(0, 0, '', 'A');
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
            onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => CadastroGaragem(garagemMdl: novo))),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(Icons.add,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(height: MediaQuery.of(context).size.height),
          //criabordalateral(),
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
        consultaGaragem()
      ],
    );
  }

  textoinicial() {
    return Container(
      padding: const EdgeInsets.only(top: 5.0),
      child: Column(
        children: const <Widget>[
          Texts.GaragemText,
        ],
      ),
    );
  }

  consultaGaragem() {
    return Container(
        padding: EdgeInsets.all(5.0),
        child: FutureBuilder(
            future: getGaragem(context),
            initialData: "Aguardando os dados...",
            builder:  (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting: return const CircularProgressIndicator();
                default:
                  if(snapshot.hasError){
                    return Text(snapshot.hasError.toString());
                  }else{
                    List<GaragemMdl> lst = snapshot.data as List<GaragemMdl>;
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: lst.length,
                        itemBuilder:  (BuildContext context, int i) {
                          GaragemMdl mdl = lst[i];
                          return Dismissible(
                              key: Key('item ${lst[i]}'),
                              direction: DismissDirection.endToStart,
                              confirmDismiss: (DismissDirection direction) async{
                                if(direction == DismissDirection.endToStart){
                                  return inativaGaragem(mdl);
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

  inativaGaragem(GaragemMdl mdl) {
    String msg = '';
    msg = 'Você tem certeza que deseja excluir essa garagem : ' + mdl.numero.toString() + '?';

    return confirma(context, 'Reservas', msg).then((onValue) async {
      if(onValue == true){
        mdl.status = 'I';
        String msg = await atualizarGaragem(mdl,'Atualizando', context );
        if (msg != 'Registro atualizado com sucesso.'){
          mostraMensage(context, "Erro", msg,1);
          return false;
        } else {
          return true;
        }
      }
    });
  }

  criaItem(GaragemMdl mdl) {
    return InkWell(
      child: ListTile(
        leading: const CircleAvatar(
          backgroundImage: AssetImage('assets/images/garagem.png'),
          radius: 25.0,
        ),
        title: Text(mdl.numero.toString(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        subtitle: Text(verificaDescricao(mdl), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      ),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CadastroGaragem(garagemMdl: mdl))),
    );
  }

  String verificaDescricao(GaragemMdl mdl) {
    if(mdl.descricao != null) {
      return mdl.descricao.toString();
    } else {
      return "";
    }
  }

}
