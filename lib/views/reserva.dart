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

class Reserva extends StatefulWidget {
  final Airbndmdl airbndmdl;
  const Reserva({Key? key, required this.airbndmdl}) : super(key: key);

  @override
  State<Reserva> createState() => _ReservaState(airbndmdl);
}

class _ReservaState extends State<Reserva> {
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

  _ReservaState(this.airmdl);

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
        // criaBotaoSalvar(),
        // const Divider(color: Colors.transparent),
      ],
    );
  }
  textoinicial() {
    return Container(
      padding: const EdgeInsets.only(top: 5.0),
      child: Column(
        children: const <Widget>[
          Texts.ReservasAntigasText,
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
            enabled: false,
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
            enabled: false,
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
            enabled: false,
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
            enabled: false,
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
            enabled: false,
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
          // VerificaConflitoGaragem(context),
          Divider(color: Colors.transparent),
          Wrap(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width / 4,
                child: TextFormField(
                  enabled: false,
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
                  enabled: false,
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
                  enabled: false,
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
                  enabled: false,
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
                    enabled: false,
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

  // VerificaConflitoGaragem(BuildContext context) {
  //   if(airmdl.conflitoGaragem != 'N')
  //   {
  //     return criabotaoVerificarConflito(context);
  //   } else{
  //     return Divider(color: Colors.transparent);
  //   }
  // }

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

}
