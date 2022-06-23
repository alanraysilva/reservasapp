import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:reservas/models/airbndmdl.dart';
import 'package:reservas/models/garagemmdl.dart';
import 'package:reservas/services/garagemapi.dart';
import 'package:reservas/services/reservasapi.dart';
import 'package:reservas/utils/ferramentas.dart';
import 'package:reservas/utils/utils.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:reservas/views/entrada.dart';
import 'package:reservas/globals.dart' as globals;
import 'package:reservas/views/home.dart';


class EditarEntrada extends StatefulWidget {
  final Airbndmdl airbndmdl;
  const EditarEntrada({Key? key, required this.airbndmdl}) : super(key: key);

  @override
  _EditarEntradaState createState() => _EditarEntradaState(airbndmdl);
}

class _EditarEntradaState extends State<EditarEntrada> {
  final Airbndmdl airmdl;
  late List<GaragemMdl> lstGaragem = [];


  final TextEditingController _cliente = TextEditingController();
  final TextEditingController _telefone = TextEditingController();
  final TextEditingController _qtdeAdultos = TextEditingController();
  final TextEditingController _qtdecriancas = TextEditingController();
  final TextEditingController _qtdebebes = TextEditingController();
  final TextEditingController _dtentrada = TextEditingController();
  final TextEditingController _hrentrada = TextEditingController();
  final TextEditingController _dtsaida = TextEditingController();
  final TextEditingController _hrsaida = TextEditingController();
  final TextEditingController _pedido = TextEditingController();


  List<DropdownMenuItem<String>> _dropDownMenuItems = [];
  String _currentGaragem = "";

  bool _valcliente = false;
  bool _valtelefone = false;
  bool _valAdultos = false;
  bool _valCriancas = false;
  bool _valbebes = false;
  bool _valDtEntrada = false;
  bool _valhrEntrada = false;
  bool _valDtSaida = false;
  bool _valhrSaida = false;
  String? _msgErro = '';
  bool _isSelected = false;
  bool _isCheckin = false;

  final maskFormatterDtEntrada = MaskTextInputFormatter(mask: '##/##/#### ##:##', filter: { "#": RegExp(r'[0-9]') });
  final maskFormatterDtSaida = MaskTextInputFormatter(mask: '##/##/#### ##:##', filter: { "#": RegExp(r'[0-9]') });
  final maskFormatterHrEntrada = MaskTextInputFormatter(mask: '##:##', filter: { "#": RegExp(r'[0-9]') });
  final maskFormatterHrSaida = MaskTextInputFormatter(mask: '##:##', filter: { "#": RegExp(r'[0-9]') });


  _EditarEntradaState(this.airmdl);

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _getLista().then((value) {
      lstGaragem = value;
      setState(() {
        _dropDownMenuItems = getDropDownMenuItems();
        if(airmdl.objGaragem != null){
          for(var item in _dropDownMenuItems){
            if(item.value == airmdl.objGaragem!.id.toString()) {
              _currentGaragem = item.value!;
            }
          }
        } else {
          _currentGaragem = _dropDownMenuItems[0].value!;
        }

      });
    });

    _cliente.text = airmdl.hospede.toString();
    _telefone.text = airmdl.telefone.toString();
    _qtdeAdultos.text = airmdl.qtdeAdultos.toString();
    _qtdecriancas.text = airmdl.qtdeCriancas.toString();
    _qtdebebes.text = airmdl.qtdeBebes.toString();
    _dtentrada.text = DateFormat('dd/MM/yyyy').format(airmdl.entrada);
    _dtsaida.text = DateFormat('dd/MM/yyyy').format(airmdl.saida);
    _hrentrada.text = DateFormat('HH:mm').format(airmdl.entrada);
    _hrsaida.text = DateFormat('HH:mm').format(airmdl.saida);


    if(airmdl.pedido != null){
      _pedido.text =  airmdl.pedido.toString();
    }

    if(airmdl.verificadoEntrada.toString() == 'S'){
      _isSelected = true;
    }

    if(airmdl.situacao.toString() == 'S'){
      _isCheckin = true;
    }

  }

  Future<List<GaragemMdl>> _getLista() async{
    return await getGaragem(context);

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
          Texts.CheckInText,
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

  criaForm() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Código: ' + airmdl.codigo.toString()),
            ],
          ),
          Divider(color: Colors.transparent),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Apartamento: ' + airmdl.objApartamento.numero.toString()),
            ],
          ),
          Divider(color: Colors.transparent),
          TextFormField(
            controller: _cliente,

            keyboardType: TextInputType.text,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)
              ),
              labelText: 'Cliente',
              hintText: 'digite nome do cliente',
              labelStyle: const TextStyle(fontSize: 15, color: Colors.black),
              errorText: _valcliente? _msgErro:null,
            ),
          ),
          Divider(color: Colors.transparent),
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
          ),
          Divider(color: Colors.transparent),
          TextFormField(
            controller: _qtdeAdultos,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)
              ),
              labelText: 'Adultos',
              hintText: 'digite a quantidade',
              labelStyle: const TextStyle(fontSize: 15, color: Colors.black),
              errorText: _valAdultos? _msgErro:null,
            ),
          ),
          Divider(color: Colors.transparent),
          TextFormField(
            controller: _qtdecriancas,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)
              ),
              labelText: 'Crianças',
              hintText: 'digite a quantidade',
              labelStyle: const TextStyle(fontSize: 15, color: Colors.black),
              errorText: _valCriancas? _msgErro:null,
            ),
          ),
          Divider(color: Colors.transparent),
          TextFormField(
            controller: _qtdebebes,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)
              ),
              labelText: 'Bebês',
              hintText: 'digite a quantidade',
              labelStyle: const TextStyle(fontSize: 15, color: Colors.black),
              errorText: _valbebes? _msgErro:null,
            ),
          ),
          Divider(color: Colors.transparent),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: const Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Text("GARAGEM",
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
                      value: _currentGaragem,
                      items: _dropDownMenuItems,
                      onChanged: (String? newValue) {
                        setState(() {
                          _currentGaragem = newValue!;
                        });
                      },
                    )
                )
            ),
          ),
          VerificaConflitoGaragem(context),
          Divider(color: Colors.transparent),
          Wrap(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width / 4,
                child: TextFormField(
                  controller: _dtentrada,
                  keyboardType: TextInputType.number,
                  inputFormatters: [maskFormatterDtEntrada],
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)
                    ),
                    labelText: 'Data Entrada',
                    hintText: 'digite a saida',
                    labelStyle: const TextStyle(fontSize: 15, color: Colors.black),
                    errorText: _valDtEntrada? _msgErro:null,
                  ),
                ),
              ),
              MaterialButton(
                  child: Icon(
                    Icons.calendar_today,
                    size: 35,
                  ),
                  padding: const EdgeInsets.only(top: 10),
                  onPressed: (){
                    showDatePicker(
                      context: context,
                      initialDate: airmdl.entrada != null ? airmdl.entrada: DateTime.now(),
                      firstDate: DateTime(DateTime.now().year),
                      lastDate: DateTime(DateTime.now().year + 1)
                    ).then((date) {
                      setState(() {
                        if(date != null){
                          _dtentrada.text = DateFormat('dd/MM/yyyy').format(date);
                        }
                      });
                    });
                  }
              ),
              Container(
                width: MediaQuery.of(context).size.width / 5,
                child: TextFormField(
                  controller: _hrentrada,
                  keyboardType: TextInputType.number,
                  inputFormatters: [maskFormatterHrEntrada],
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)
                    ),
                    labelText: 'Horário' ,
                    hintText: 'digite a saida',
                    labelStyle: const TextStyle(fontSize: 15, color: Colors.black),
                    errorText: _valhrEntrada? _msgErro:null,
                  ),
                ),
              ),
              MaterialButton(
                  child: Icon(
                    Icons.more_time,
                    size: 40,
                  ),
                  padding: const EdgeInsets.only(top: 10, left: 15),

                  onPressed: (){
                    showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(airmdl.entrada) != null ? TimeOfDay.fromDateTime(airmdl.entrada): TimeOfDay.now(),
                    ).then((time){
                      setState(() {
                        if(time != null){
                          _hrentrada.text =  globals.formatTimeOfDay(time);
                        }
                      });
                    });
                  }
              )
            ],
          ),

          Divider(color: Colors.transparent),
          Wrap(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width / 4,
                child: TextFormField(
                  controller: _dtsaida,
                  keyboardType: TextInputType.number,
                  inputFormatters: [maskFormatterDtSaida],
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)
                    ),
                    labelText: 'Data Saída' ,
                    hintText: 'digite a saida',
                    labelStyle: const TextStyle(fontSize: 15, color: Colors.black),
                    errorText: _valDtSaida? _msgErro:null,
                  ),
                ),
              ),
              MaterialButton(
                  child: Icon(
                    Icons.calendar_today,
                    size: 35,
                  ),
                  padding: const EdgeInsets.only(top: 10),
                  onPressed: (){
                    showDatePicker(
                        context: context,
                        initialDate: airmdl.saida != null ? airmdl.saida: DateTime.now(),
                        firstDate: DateTime(DateTime.now().year),
                        lastDate: DateTime(DateTime.now().year + 1)
                    ).then((date) {
                      setState(() {
                        if(date != null){
                          _dtsaida.text = DateFormat('dd/MM/yyyy').format(date);
                        }
                      });
                    });
                  }
              ),
              Container(
                width: MediaQuery.of(context).size.width / 5,
                child: TextFormField(
                  controller: _hrsaida,
                  keyboardType: TextInputType.number,
                  inputFormatters: [maskFormatterHrEntrada],
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)
                    ),
                    labelText: 'Horário' ,
                    hintText: 'digite a saida',
                    labelStyle: const TextStyle(fontSize: 15, color: Colors.black),
                    errorText: _valhrSaida? _msgErro:null,
                  ),
                ),
              ),
              MaterialButton(
                  child: Icon(
                    Icons.more_time,
                    size: 40,
                  ),
                  padding: const EdgeInsets.only(top: 10, left: 15),

                  onPressed: (){
                    showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(airmdl.saida) != null ? TimeOfDay.fromDateTime(airmdl.saida): TimeOfDay.now(),
                    ).then((time){
                      setState(() {
                        if(time != null){
                          _hrsaida.text =  globals.formatTimeOfDay(time);
                        }
                      });
                    });
                  }
              )
            ],
          ),
          Divider(color: Colors.transparent),
          Card(
              color: Colors.grey,
              child: Padding(
                padding: EdgeInsets.all(4.0),
                child: TextFormField(
                    controller: _pedido,
                    keyboardType: TextInputType.multiline,
                    maxLines: 8,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration.collapsed(
                        hintText: "Pedido extra aqui"
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
                    airmdl.verificadoEntrada = 'S';
                  } else {
                    airmdl.verificadoEntrada = 'N';
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

   VerificaConflitoGaragem(BuildContext context) {
    if(airmdl.conflitoGaragem != 'N')
    {
      return criabotaoVerificarConflito(context);
    } else{
      return Divider(color: Colors.transparent);
    }
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = [];
    items.add(DropdownMenuItem(value: '0',
        child: Text("SEM GARAGEM")));
    for (var item in lstGaragem) {
      items.add(DropdownMenuItem(value: item.id.toString(),
          child: Text("Nº: " + item.numero.toString())));
    }
    return items;
  }

  gravaralteracoes() async {
    if(podeSalvar()){


      //airmdl.objGaragem = lstGaragem.firstWhere((e) => e.id.toString() == _currentGaragem.toString(), orElse: airmdl.objGaragem = null);


      for(var item in lstGaragem){
        if(item.id.toString() == _currentGaragem.toString()){
          airmdl.objGaragem = item;
        } else {
          if(_currentGaragem == '0'){
            airmdl.objGaragem = null;
          }
        }
      }

      Airbndmdl envio = Airbndmdl(airmdl.id,
          airmdl.codigo, airmdl.status, _cliente.text,
          _telefone.text, int.parse(_qtdeAdultos.text),
          int.parse(_qtdecriancas.text), int.parse(_qtdebebes.text),
          airmdl.noites, globals.juntaDatahora(_dtentrada.text, _hrentrada.text),
          globals.juntaDatahora(_dtsaida.text, _hrsaida.text), airmdl.dtReserva,
          airmdl.ganhos, airmdl.descricao, _pedido.text, airmdl.proximaEntrada,
          airmdl.objApartamento, airmdl.objGaragem,
          airmdl.verificadoEntrada, airmdl.verificadoSaida,
          DateFormat('dd/MM/yyyy HH:mm').parse('01/01/0001 00:00'),
          null, null, null, 'O','');
          //null, null, null, airmdl.situacao);

      String msg;
      if (envio.id > 0){
        msg = await atualizarReserva(envio,'Atualizando', context );
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
    }
  }

  bool podeSalvar() {
    _msgErro = "O campo não pode ficar em branco";
    if(_cliente.text.isEmpty){
      setState(() {
        _valcliente = true;
      });
    } else{
      setState(() {
        _valcliente = false;
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
    if (_qtdeAdultos.text.isEmpty){
      setState(() {
        _valAdultos = true;
      });
    } else{
      setState(() {
        _valAdultos = false;
      });
    }

    if (_qtdecriancas.text.isEmpty){
      setState(() {
        _valCriancas = true;
      });
    } else{
      setState(() {
        _valCriancas = false;
      });
    }

    if (_qtdebebes.text.isEmpty){
      setState(() {
        _valbebes = true;
      });
    } else{
      setState(() {
        _valbebes = false;
      });
    }

    if (_dtentrada.text.isEmpty){
      setState(() {
        _valDtEntrada = true;
      });
    } else{
      setState(() {
        _valDtEntrada = false;
      });
    }

    if (_hrentrada.text.isEmpty){
      setState(() {
        _valhrEntrada = true;
      });
    } else{
      setState(() {
        _valhrEntrada = false;
      });
    }

    if (_dtsaida.text.isEmpty){
      setState(() {
        _valDtSaida = true;
      });
    } else{
      setState(() {
        _valDtSaida = false;
      });
    }

    if (_hrsaida.text.isEmpty){
      setState(() {
        _valhrSaida = true;
      });
    } else{
      setState(() {
        _valhrSaida = false;
      });
    }

    return _valcliente == false && _valtelefone == false
        && _valAdultos == false && _valCriancas == false
        && _valbebes == false && _valDtEntrada == false
        && _valDtSaida == false && _valhrEntrada == false
        && _valhrSaida == false ? true: false;
  }

  Widget criabotaoVerificarConflito(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: MaterialButton(
        child: const Text('Conflitos',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
        color: Colors.redAccent,
        elevation: 0,
        minWidth: 150,
        height: 40,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
        ),
        onPressed: () => mostraconflitos(context),
      ));
  }

  mostraconflitos(BuildContext context) {
    String msg = "";
    var conf = airmdl.conflitoGaragem?.split(';');
    List<String> n = [];
    if(conf != null)
    {
      n.addAll(conf);
      n.forEach((i) {
        if(i != ''){
           msg = msg + "Ap.: "+ i.toString() + "\n";
        }
      });
      if(msg != null){
        mostraMensage(context, "Conflitos", msg,1);
      }
    }


  }
}



