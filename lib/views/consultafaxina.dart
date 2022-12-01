import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:reservas/models/airbndmdl.dart';
import 'package:reservas/models/funcionariomdl.dart';
import 'package:reservas/services/funcionarioapi.dart';
import 'package:reservas/services/reservasapi.dart';
import 'package:reservas/utils/ferramentas.dart';
import 'package:reservas/utils/utils.dart';
import 'package:reservas/utils/viewpdf.dart';
import 'package:share_extend/share_extend.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:reservas/globals.dart' as globals;

class ConsultaFaxina extends StatefulWidget {
  const ConsultaFaxina({Key? key}) : super(key: key);

  @override
  _ConsultaFaxinaState createState() => _ConsultaFaxinaState();
}

class _ConsultaFaxinaState extends State<ConsultaFaxina> {

  late List<FuncionarioMdl> lstFuncionario = [];
  final TextEditingController _dtentrada = TextEditingController();
  final TextEditingController _dtsaida = TextEditingController();

  List<DropdownMenuItem<String>> _dropDownMenuItems = [];
  String _currentFuncionario = "";


  bool _valDtEntrada = false;
  bool _valDtSaida = false;
  String? _msgErro = '';

  var maskFormatterEntrada = MaskTextInputFormatter(mask: '##/##/####', filter: { "#": RegExp(r'[0-9]') });
  var maskFormatterSaida = MaskTextInputFormatter(mask: '##/##/####', filter: { "#": RegExp(r'[0-9]') });

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLista().then((value) {
      lstFuncionario = value;
      setState(() {
        _dropDownMenuItems = getDropDownMenuItems();
        _currentFuncionario = _dropDownMenuItems[0].value!;
      });
    });

  }

  Future<List<FuncionarioMdl>> _getLista() async{
    return await getFuncionarios(context);

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
        SizedBox(height: 20),
        criaForm(),
        SizedBox(height: 10),
        criaBotaoConsultar(),
        SizedBox(height: 10),
        //criaBotaoWhatZap(),
      ],
    );
  }

  textoinicial() {
    return Container(
      padding: const EdgeInsets.only(top: 5.0),
      child: Column(
        children: const <Widget>[
          Texts.RelatorioFaxinaText,
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
            controller: _dtentrada,
            keyboardType: TextInputType.number,
            inputFormatters: [maskFormatterEntrada],
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)
              ),
              labelText: 'Data inicial' ,
              hintText: 'digite a entrada',
              labelStyle: const TextStyle(fontSize: 15, color: Colors.black),
              errorText: _valDtEntrada? _msgErro:null,
            ),
          ),
          Divider(color: Colors.transparent),
          TextFormField(
            controller: _dtsaida,
            keyboardType: TextInputType.number,
            inputFormatters: [maskFormatterSaida],
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)
              ),
              labelText: 'Data final',
              hintText: 'digite a saida',
              labelStyle: const TextStyle(fontSize: 15, color: Colors.black),
              errorText: _valDtSaida? _msgErro:null,
            ),
          ),
        ],
      ),
    );
  }

  criaBotaoConsultar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: MaterialButton(
        child: const Text('Consultar',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
        color: Colors.redAccent,
        elevation: 0,
        minWidth: 350,
        height: 60,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
        ),
        onPressed: () => consulta(1),
      ),
    );
  }

  consulta(int tipo) async {
    if(podeConsultar()){

      ProgressDialog pd = ProgressDialog(context: context);
      pd.show(max: 100, msg: 'Consultando', progressType: ProgressType.valuable);

      DateTime dtini = DateFormat('dd/MM/yyyy').parse(_dtentrada.text);
      DateTime dtfim = DateFormat('dd/MM/yyyy').parse(_dtsaida.text);
      String d1 = DateFormat('yyyy-MM-dd').format(dtini);
      String d2 = DateFormat('yyyy-MM-dd').format(dtfim);
      int idFuncionario = 0;

      if(existeFuncionario()){
        idFuncionario = lstFuncionario.firstWhere((e) => e.id.toString() == _currentFuncionario.toString()).id;
      }


      List<Airbndmdl> envio = await getConsultaLimpeza(context, d1, d2, idFuncionario);
      pd.close();
      if(envio != null) {
        if(tipo == 1){
          await _criaPdf(context, envio);
        } else if (tipo == 2) {
          if(idFuncionario != 0){
            String? numero = envio[0].objFuncionario?.telefone.toString();
            String msg = "";
            List<String> lst = [];
            for (var item in envio) {
              /*
              DataUtil.formataDataComDiaExtenso(mdl[i].dataLimpeza)}',
                    '${mdl[i].objApartamento.numero.toString()}',
                    '${globals.formataMoeda(mdl[i].valorLimpeza, false)
              * */
              lst.add(item.objFuncionario!.nome.toString() +
                  " - " + DataUtil.formataDataComDiaExtenso(item.dataLimpeza) +
                  " - " + item.objApartamento.numero.toString() +
                  " - " + globals.formataMoeda(item.valorLimpeza, false));
            }

            await abreWhatsApp(context, numero, lst.toString());
          } else {
            mostraMensage(context, "Erro", "Para fazer o envio por WhatsApp é necessário selecionar um funcionário.",1);
          }
        }


      } else {
        mostraMensage(context, "Erro", "Ao carregar consulta.",1);
      }
    } else {
      mostraMensage(context, "Erro", "É necessário informar os campos data corretamente.",1);
    }
  }

  bool podeConsultar() {
    _msgErro = "O campo não pode ficar em branco";
    if (_dtentrada.text.isEmpty){
      setState(() {
        _valDtEntrada = true;
      });
    } else{
      setState(() {
        _valDtEntrada = false;
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

    return _valDtEntrada == false && _valDtSaida == false ? true: false;
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

  criaBotaoWhatZap() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: MaterialButton(
        child: const Text('Enviar WhatsApp',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
        color: Colors.green,
        elevation: 0,
        minWidth: 350,
        height: 60,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
        ),
        onPressed: () => consulta(2),
      ),
    );
  }

  _criaPdf(BuildContext context, List<Airbndmdl> mdl) async {
    List<Airbndmdl> lst = mdl;
    final pw.Document pdf = pw.Document(deflate: zlib.encode);
    pdf.addPage(pw.MultiPage(
        margin: const pw.EdgeInsets.all(4),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => <pw.Widget>[
          pw.Table.fromTextArray(
              context: context,
              headerStyle: pw.TextStyle(fontSize: 14),
              headerAlignment: pw.Alignment.centerLeft,
              cellAlignment: pw.Alignment.topLeft,
              cellStyle: pw.TextStyle(fontSize: 12),
              data: <List<String>>[
                //<String>['Pessoa','Data/Hora','Ap','Valor'],
                <String>['Data/Hora','Ap','Valor','Pessoa'],

                for (int i = 0; i < lst.length; i++)
                  <String>['${DataUtil.formataDataComDiaExtenso(lst[i].dataLimpeza)}',
                    '${lst[i].objApartamento.numero.toString()}',
                    '${globals.formataMoeda(lst[i].valorLimpeza, false)}',
                    '${verificaObjFuncionario(lst[i].objFuncionario)}'],
              ]),
          pw.Padding(padding: const pw.EdgeInsets.all(10)),
        ]));


    final String dir = (await getTemporaryDirectory()).path;

    final String arquivo = 'Limpeza_'+ DateFormat('dd_MM_yyyy_HH_mm_ss').format(DateTime.now()) +'.pdf';
    final String diretorio = '$dir';
    final file = File("${diretorio}/" + arquivo);

    await file.writeAsBytes(await pdf.save());

    /*ShareExtend.share(diretorio + '/' + arquivo, "file",
        sharePanelTitle: "Enviar PDF", subject: "Reservas");*/

    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ViewPdf("${diretorio}/" + arquivo)));
  }

  String verificaObjFuncionario(FuncionarioMdl? objFuncionario) {
    if (objFuncionario != null){
      return objFuncionario.nome.toString();
    } else {
      return 'Sem informação.';
    }
  }

}
