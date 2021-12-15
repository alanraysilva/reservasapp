import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:reservas/models/funcionariomdl.dart';
import 'package:reservas/services/funcionarioapi.dart';
import 'package:reservas/utils/ferramentas.dart';
import 'package:reservas/utils/utils.dart';
import 'package:reservas/globals.dart' as globals;
import 'package:reservas/views/cadatrofuncionario.dart';

class ConsultaFuncionario extends StatefulWidget {
  const ConsultaFuncionario({Key? key}) : super(key: key);

  @override
  _ConsultaFuncionarioState createState() => _ConsultaFuncionarioState();
}

class _ConsultaFuncionarioState extends State<ConsultaFuncionario> {
  FuncionarioMdl novo = FuncionarioMdl(0, 'nome', 'telefone', 'A');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          InkWell(
            customBorder: CircleBorder(),
            onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => CadastroFuncionario(funcionarioMdl:novo))),
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

  textoinicial() {
    return Container(
      padding: const EdgeInsets.only(top: 5.0),
      child: Column(
        children: const <Widget>[
          Texts.FunciorioText,
        ],
      ),
    );
  }

  criaItens() {
    return ListView(
      children: <Widget>[
        textoinicial(),
        SizedBox(height: 20),
        consultaFuncionarios()
      ],
    );
  }

  consultaFuncionarios() {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: FutureBuilder(
          future: getFuncionarios(context),
          initialData: "Aguardando os dados...",
          builder:  (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting: return const CircularProgressIndicator();
              default:
                if(snapshot.hasError){
                  return Text(snapshot.hasError.toString());
                }else{
                  List<FuncionarioMdl> lst = snapshot.data as List<FuncionarioMdl>;
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: lst.length,
                      itemBuilder:  (BuildContext context, int i) {
                        FuncionarioMdl mdl = lst[i];
                        return Dismissible(
                            key: Key('item ${lst[i]}'),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (DismissDirection direction) async{
                              if(direction == DismissDirection.endToStart){
                                return inativaFuncionario(mdl);
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

  criaItem(FuncionarioMdl mdl) {
    return InkWell(
      child: ListTile(
        leading: const CircleAvatar(
          backgroundImage: AssetImage('assets/images/faxineira.png'),
          radius: 25.0,
        ),
        title: Text(mdl.nome,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        subtitle: Text(globals.formataTelefone(mdl.telefone), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      ),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CadastroFuncionario( funcionarioMdl: mdl))),
    );
  }

  inativaFuncionario(FuncionarioMdl mdl) {
    String msg = '';
    msg = 'Você tem certeza que deseja excluir o funcionário : ' + mdl.nome + '?';

    return confirma(context, 'Reservas', msg).then((onValue) async {
      if(onValue == true){
        mdl.status = 'I';
        String msg = await atualizarFuncionario(mdl,'Atualizando', context );
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
