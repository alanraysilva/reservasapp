import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:reservas/models/airbndmdl.dart';
import 'package:reservas/models/funcionariomdl.dart';
import 'package:reservas/services/funcionarioapi.dart';
import 'package:reservas/services/reservasapi.dart';
import 'package:reservas/utils/ferramentas.dart';
import 'package:reservas/utils/utils.dart';
import 'package:reservas/views/home.dart';
import 'package:reservas/views/saida.dart';

class EditarSaida extends StatefulWidget {
  final Airbndmdl airbndmdl;
  const EditarSaida({Key? key, required this.airbndmdl}) : super(key: key);

  @override
  _EditarSaidaState createState() => _EditarSaidaState(this.airbndmdl);
}

class _EditarSaidaState extends State<EditarSaida> {
  final Airbndmdl airmdl;
  late List<FuncionarioMdl> lstFuncionario = [];

  final TextEditingController _dtlimpeza = TextEditingController();
  final TextEditingController _valor = TextEditingController();
  final TextEditingController _observacao = TextEditingController();

  bool _valdtlimpeza = false;
  bool _valvalor = false;

  String? _msgErro = '';
  bool _isSelected = false;
  bool _isCheckout = false;

  List<DropdownMenuItem<String>> _dropDownMenuItems = [];
  String _currentFuncionario = "";

  _EditarSaidaState(this.airmdl);

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _getLista().then((value) {
      lstFuncionario = value;
      setState(() {
        _dropDownMenuItems = getDropDownMenuItems();
        if(airmdl.objFuncionario != null){
          for(var item in _dropDownMenuItems){
            if(item.value == airmdl.objFuncionario!.id.toString()) {
              _currentFuncionario = item.value!;
            }
          }
        } else {
          _currentFuncionario = _dropDownMenuItems[0].value!;
        }

      });
    });

    if(airmdl.dataLimpeza != null){
      DateTime dt = DateTime.parse(airmdl.dataLimpeza.toString());
      _dtlimpeza.text = DateFormat('dd/MM/yyyy HH:mm').format(dt);
    }

    if(airmdl.valorLimpeza != null){
      double vl = double.parse(airmdl.valorLimpeza.toString());
      _valor.text = vl.toString();
    }

    if(airmdl.observacaoLimpeza != null){
      _observacao.text =  airmdl.pedido.toString();
    }

    if(airmdl.verificadoSaida.toString() == 'S'){
      _isSelected = true;
    }


  }

  Future<List<FuncionarioMdl>> _getLista() async{
    return await getFuncionarios(context);

  }


  var maskFormatter = MaskTextInputFormatter(mask: '##/##/#### ##:##', filter: { "#": RegExp(r'[0-9]') });

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
        const Divider(color: Colors.transparent),
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
          Texts.CheckOutText,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Text('Apartamento: ' + verificaNumeroApartamento(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          Divider(color: Colors.transparent),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text('Hospede: ' + airmdl.hospede.toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(color: Colors.transparent),
           Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: const Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Text("FUNCIONÁRIO",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            child: Container(
                alignment: Alignment.bottomCenter,
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: DropdownButton(
                      value: _currentFuncionario,
                      items: _dropDownMenuItems,
                      onChanged: (String? newValue) {
                        setState(() {
                          _currentFuncionario = newValue!;
                        });
                      },
                    )
                )
            ),
          ),
          Divider(color: Colors.transparent),
          TextFormField(
            controller: _dtlimpeza,
            keyboardType: TextInputType.number,
            inputFormatters: [maskFormatter],
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)
              ),
              labelText: 'Data da Limpeza ( Dt. Saída: ' + DateFormat('dd/MM/yyyy HH:mm').format(airmdl.saida) + ')',
              hintText: 'digite a saida',
              labelStyle: const TextStyle(fontSize: 15, color: Colors.black),
              errorText: _valdtlimpeza? _msgErro:null,
            ),
          ),
          Divider(color: Colors.transparent),
          TextFormField(
            controller: _valor,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)
              ),
              labelText: 'Valor da Limpeza',
              hintText: 'digite o valor',
              labelStyle: const TextStyle(fontSize: 15, color: Colors.black),
              errorText: _valvalor? _msgErro:null,
            ),
          ),
          Divider(color: Colors.transparent),
          Card(
              color: Colors.grey,
              child: Padding(
                padding: EdgeInsets.all(4.0),
                child: TextFormField(
                    controller: _observacao,
                    keyboardType: TextInputType.multiline,
                    maxLines: 8,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration.collapsed(
                        hintText: "Observações"
                    )
                ),
              )
          ),
          Divider(color: Colors.transparent),
          Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.teal)),
            child: CheckboxListTile(
              title: const Text('Verificado'),
              value: _isSelected,
              onChanged: (newvalue) {
                setState(() {
                  _isSelected = newvalue!;
                  if(_isSelected){
                    airmdl.verificadoSaida = 'S';
                  } else {
                    airmdl.verificadoSaida = 'N';
                  }
                });
              },
            ),
          ),
          Divider(color: Colors.transparent),
          Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.teal)),
            child: CheckboxListTile(
              title: const Text('Check-out'),
              value: _isCheckout,
              onChanged: (newvalue) {
                setState(() {
                  _isCheckout = newvalue!;
                  if(_isCheckout){
                    airmdl.situacao = 'I';
                  } else {
                    airmdl.situacao = 'A';
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
        onPressed: () => gravaralteracoes(),
      ),
    );
  }


  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = [];
    items.add(DropdownMenuItem(value: '0',
        child: Text("SEM FUNCIONÁRIO")));
    for (var item in lstFuncionario) {
      items.add(DropdownMenuItem(value: item.id.toString(),
          child: Text(item.nome.toString())));
    }
    return items;
  }

  gravaralteracoes() async {
    if(podeSalvar()){
      if(existeFuncionario()){

        FuncionarioMdl func = lstFuncionario.firstWhere((e) => e.id.toString() == _currentFuncionario.toString());


        Airbndmdl envio = Airbndmdl(airmdl.id,
            airmdl.codigo, airmdl.status, airmdl.hospede,
            airmdl.telefone, airmdl.qtdeAdultos,
            airmdl.qtdeCriancas, airmdl.qtdeBebes,
            airmdl.noites, airmdl.entrada,
            airmdl.saida, airmdl.dtReserva,
            airmdl.ganhos, airmdl.descricao, airmdl.pedido, airmdl.proximaEntrada,
            airmdl.objApartamento, airmdl.objGaragem,
            airmdl.verificadoEntrada, airmdl.verificadoSaida,
            DateFormat('dd/MM/yyyy HH:mm').parse(_dtlimpeza.text),
            double.parse(_valor.text), _observacao.text, func, airmdl.situacao);



        String msg;
        if (envio.id > 0){
          msg = await atualizarSaida(envio,'Atualizando', context );
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
        }
      } else {
        mostraMensage(context, "Erro", "É necessário escolher um funcionário.",1);
      }
    }
  }

  bool existeFuncionario() {
    bool achou = false;
    for(var item in lstFuncionario){
      if(item.id.toString() == _currentFuncionario.toString()){
        achou = true;
      }
    }
    return achou;
  }

  bool podeSalvar() {
    _msgErro = "O campo não pode ficar em branco";
    if(_dtlimpeza.text.isEmpty){
      setState(() {
        _valdtlimpeza = true;
      });
    } else{
      setState(() {
        _valdtlimpeza = false;
      });
    }
    if (_valor.text.isEmpty){
      setState(() {
        _valvalor = true;
      });
    } else{
      setState(() {
        _valvalor = false;
      });
    }

    return _valdtlimpeza == false && _valvalor == false ? true: false;
  }

  String verificaNumeroApartamento() {
    if(airmdl.objApartamento != null){
      return airmdl.objApartamento.numero.toString();
    } else {
      return 'Sem definição';
    }
  }

}
