import 'package:flutter/material.dart';
import 'package:reservas/models/garagemmdl.dart';
import 'package:reservas/services/garagemapi.dart';
import 'package:reservas/utils/ferramentas.dart';
import 'package:reservas/utils/utils.dart';
import 'package:reservas/views/consultagaragem.dart';
import 'package:reservas/views/home.dart';

class CadastroGaragem extends StatefulWidget {
  final GaragemMdl garagemMdl;
  const CadastroGaragem({Key? key, required this.garagemMdl}) : super(key: key);

  @override
  _CadastroGaragemState createState() => _CadastroGaragemState(garagemMdl);
}

class _CadastroGaragemState extends State<CadastroGaragem> {

  final GaragemMdl garmdl;
  final TextEditingController _numero = TextEditingController();
  final TextEditingController _descricao = TextEditingController();

  bool _valnumero = false;
  bool _valdescricao = false;
  String? _msgErro = '';

  _CadastroGaragemState(this.garmdl);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(garmdl != null){
      if(garmdl.id > 0){
        _numero.text = garmdl.numero.toString();
        _descricao.text = garmdl.descricao.toString();
      }
    }
  }

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
        SizedBox(height: 50),
        criaForm(),
        const Divider(color: Colors.transparent),
        criaBotaoSalvar(),
        const Divider(color: Colors.transparent),
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

  criaForm() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _numero,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)
              ),
              labelText: 'Nº da garagem',
              hintText: 'digite o número',
              labelStyle: const TextStyle(fontSize: 15, color: Colors.black),
              errorText: _valnumero? _msgErro:null,
            ),
          ),
          SizedBox(height: 50),
          TextFormField(
            controller: _descricao,
            keyboardType: TextInputType.text,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)
              ),
              labelText: 'Descrição',
              hintText: 'digite a descrição',
              labelStyle: const TextStyle(fontSize: 15, color: Colors.black),
              errorText: _valdescricao? _msgErro:null,
            ),
          )
        ],
      ),
    );
  }

  criaBotaoSalvar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: MaterialButton(
        child: const Text('Gravar',
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
        onPressed: () => _gravarGaragem(),
      ),
    );
  }

  _gravarGaragem() async {
    if(podeSalvar()){
      GaragemMdl envio = GaragemMdl(garmdl.id, int.parse(_numero.text), _descricao.text, 'A');
      String msg;
      if (envio.id > 0){
        msg = await atualizarGaragem(envio,'Atualizando', context );
        if (msg == 'Registro atualizado com sucesso.'){
          String? m = await mostraMensage(context, "Reservas", msg);
          if(m == 'OK'){
            Navigator.of(context)
                .push(MaterialPageRoute<Map>(builder: (BuildContext context) {
              return const Home();
            }));
          }
        } else {
          mostraMensage(context, "Erro", msg,1);
        }
      } else {
        msg = await cadastrarGaragem(envio,'Cadastrando', context );
        if (msg == 'Registro criado com sucesso.'){
          String? m = await mostraMensage(context, "Reservas", msg);
          if(m == 'OK'){
            Navigator.of(context)
                .push(MaterialPageRoute<Map>(builder: (BuildContext context) {
              return const Home();
            }));
          }
        } else {
          mostraMensage(context, "Erro", msg,1);
        }
      }
    }
  }

  bool podeSalvar() {
    _msgErro = "O campo não pode ficar em branco";
    if(_numero.text.isEmpty){
      setState(() {
        _valnumero = true;
      });
    } else{
      setState(() {
        _valnumero = false;
      });
    }
    if (_descricao.text.isEmpty){
      setState(() {
        _valdescricao = true;
      });
    } else{
      setState(() {
        _valdescricao = false;
      });
    }
    return _valnumero == false && _valdescricao == false ? true: false;
  }

}
