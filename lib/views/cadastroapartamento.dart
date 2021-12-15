import 'package:flutter/material.dart';
import 'package:reservas/models/apartamentomdl.dart';
import 'package:reservas/services/apartamentoapi.dart';
import 'package:reservas/utils/ferramentas.dart';
import 'package:reservas/utils/utils.dart';
import 'package:reservas/views/home.dart';

class CadastroApartamento extends StatefulWidget {
  final ApartamentoMdl apartamentoMdl;
  const CadastroApartamento({Key? key, required this.apartamentoMdl}) : super(key: key);

  @override
  _CadastroApartamentoState createState() => _CadastroApartamentoState(apartamentoMdl);
}

class _CadastroApartamentoState extends State<CadastroApartamento> {

  final ApartamentoMdl aptomdl;
  final TextEditingController _numero = TextEditingController();
  final TextEditingController _descricao = TextEditingController();


  bool _valnumero = false;
  bool _valdescricao = false;
  bool _possuiGaragem = false;
  String? _msgErro = '';

  _CadastroApartamentoState(this.aptomdl);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(aptomdl != null){
      if(aptomdl.id > 0){
        _numero.text = aptomdl.numero.toString();
        _descricao.text = aptomdl.descricao.toString();

        if(aptomdl.possuiGaragem.toString() == 'S'){
          _possuiGaragem = true;
        }

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
          Texts.ApartamentoText,
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
              labelText: 'Nº do apartamento',
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
          ),
          Divider(color: Colors.transparent),
          Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.teal)),
            child: CheckboxListTile(
              title: const Text('Possui garagem'),
              value: _possuiGaragem,
              onChanged: (newvalue) {
                setState(() {
                  _possuiGaragem = newvalue!;
                  if(_possuiGaragem){
                    aptomdl.possuiGaragem = 'S';
                  } else {
                    aptomdl.possuiGaragem = 'N';
                  }
                });
              },
            ),
          ),
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
        onPressed: () => _gravarApartamento(),
      ),
    );
  }

  _gravarApartamento() async {
    if(podeSalvar()){
      ApartamentoMdl envio = ApartamentoMdl(aptomdl.id, int.parse(_numero.text), _descricao.text, aptomdl.possuiGaragem, 'A');
      String msg;
      if (envio.id > 0){
        msg = await atualizarApartamento(envio,'Atualizando', context );
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
        msg = await cadastrarApartamento(envio,'Cadastrando', context );
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
