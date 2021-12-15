import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reservas/services/importarapi.dart';
import 'package:reservas/utils/ferramentas.dart';
import 'package:reservas/utils/utils.dart';
import 'package:reservas/globals.dart' as globals;

import 'home.dart';

class Importar extends StatefulWidget {
  const Importar({Key? key}) : super(key: key);

  @override
  _ImportarState createState() => _ImportarState();
}

class _ImportarState extends State<Importar> {

  String diretorio = '...';
  String arquivo = '...';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
        const Image(
          image: AssetImage('assets/images/importar.png'),
          height: 150,
        ),
        textoinicial(),
        criaFormulario(),
      ],
    );
  }

  textoinicial() {
    return Container(
      padding: const EdgeInsets.only(top: 5.0),
      child: Column(
        children: const <Widget>[
          Texts.ImportarText,
        ],
      ),
    );
  }

  criaFormulario() {
    return Form(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 0, 20),
            child: Row(
              children: <Widget>[
                Text('Arquivo: ', style: globals.fomataTituloCampos()),
                Text(arquivo, style: globals.fomataDados()),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: MaterialButton(
              child: const Text('Buscar Arquivo',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
              ),
              color: Colors.blueGrey,
              elevation: 0,
              minWidth: 350,
              height: 60,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50)
              ),
              onPressed: () => procurarArquivo(),
            ),
          ),
          Divider(color: Colors.transparent),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: MaterialButton(
              child: const Text('Importar Arquivo',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
              color: Colors.orange,
              elevation: 0,
              minWidth: 350,
              height: 60,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)
              ),
              onPressed: () => _enviarArquivo(context),
            ),
          ),
        ],
      ),
    );
  }

  procurarArquivo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        diretorio = result.files.first.path!;
        arquivo = result.files.first.name;
      });
    }
  }

  _enviarArquivo(BuildContext context) {
    String conf = 'Você tem certeza que deseja importar o arquivo: ' + arquivo + ' ?';
    confirma(context, 'Reservas', conf).then((value) async {
      if(value == true){
        String msg = await importarArquivo(diretorio, arquivo, 'Enviando arquivo', context);
        if(msg == 'Importado com sucesso.'){
          String? msgm = await mostraMensage(context, "Reservas", msg);
          if(msgm == 'OK'){
            Navigator.of(context)
                .push(MaterialPageRoute<Map>(builder: (BuildContext context) {
              return const Home();
            }));
          }
        }
        else{
          mostraMensage(context, 'Erro', msg, 1);
        }
      }
    });
  }
}
