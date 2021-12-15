import 'package:flutter/material.dart';
import 'package:reservas/models/funcionariomdl.dart';
import 'package:reservas/services/funcionarioapi.dart';
import 'package:reservas/utils/ferramentas.dart';
import 'package:reservas/utils/utils.dart';
import 'package:reservas/views/consultafuncionario.dart';
import 'package:reservas/views/home.dart';

class CadastroFuncionario extends StatefulWidget {
  final FuncionarioMdl funcionarioMdl;
  const CadastroFuncionario({Key? key, required this.funcionarioMdl}) : super(key: key);

  @override
  _CadastroFuncionarioState createState() => _CadastroFuncionarioState(funcionarioMdl);
}

class _CadastroFuncionarioState extends State<CadastroFuncionario> {

  final FuncionarioMdl funcmdl;
  final TextEditingController _nome = TextEditingController();
  final TextEditingController _telefone = TextEditingController();

  bool _valnome = false;
  bool _valtelefone = false;
  String? _msgErro = '';

  _CadastroFuncionarioState(this.funcmdl);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(funcmdl != null){
      if(funcmdl.id > 0){
        _nome.text = funcmdl.nome;
        _telefone.text = funcmdl.telefone;
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
          Texts.FunciorioText,
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
            controller: _nome,
            keyboardType: TextInputType.text,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black)
              ),
              labelText: 'Nome',
              hintText: 'digite o nome',
              labelStyle: const TextStyle(fontSize: 15, color: Colors.black),
              errorText: _valnome? _msgErro:null,
            ),
          ),
          SizedBox(height: 50),
          TextFormField(
            controller: _telefone,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)
              ),
              labelText: 'Telefone',
              hintText: 'digite o telefone',
              labelStyle: const TextStyle(fontSize: 15, color: Colors.black),
              errorText: _valtelefone? _msgErro:null,
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
        onPressed: () => _gravarFuncionario(),
      ),
    );
  }

  _gravarFuncionario() async {
    if(podeSalvar()){
      FuncionarioMdl envio = FuncionarioMdl(funcmdl.id, _nome.text, _telefone.text, 'A');
      String msg;
      if (envio.id > 0){
        msg = await atualizarFuncionario(envio,'Atualizando', context );
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
        msg = await cadastrarFuncionario(envio,'Cadastrando', context );
        if (msg == 'Registro criado com sucesso.'){
          String? m = await mostraMensage(context, "Reservas", msg);
          if(m == 'OK'){
            Navigator.of(context)
                .pop(MaterialPageRoute<Map>(builder: (BuildContext context) {
              return const ConsultaFuncionario();
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
    if(_nome.text.isEmpty){
      setState(() {
        _valnome = true;
      });
    } else{
      setState(() {
        _valnome = false;
      });
    }
    if (_telefone.text.isEmpty){
      setState(() {
        _valtelefone = true;
      });
    } else{
      setState(() {
        _valtelefone = false;
      });
    }
    return _valnome == false && _valtelefone == false ? true: false;
  }

}


