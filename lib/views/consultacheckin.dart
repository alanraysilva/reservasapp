import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:reservas/models/airbndmdl.dart';
import 'package:reservas/models/garagemmdl.dart';
import 'package:reservas/services/reservasapi.dart';
import 'package:reservas/utils/ferramentas.dart';
import 'package:reservas/utils/utils.dart';
import 'package:reservas/utils/viewpdf.dart';
import 'package:share_extend/share_extend.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:pdf/widgets.dart' as pw;

class ConsultaCheckin extends StatefulWidget {
  const ConsultaCheckin({Key? key}) : super(key: key);

  @override
  _ConsultaCheckinState createState() => _ConsultaCheckinState();
}

class _ConsultaCheckinState extends State<ConsultaCheckin> {

  final TextEditingController _dtentrada = TextEditingController();
  final TextEditingController _dtsaida = TextEditingController();

  bool _valDtEntrada = false;
  bool _valDtSaida = false;
  String? _msgErro = '';

  var maskFormatterEntrada = MaskTextInputFormatter(mask: '##/##/####', filter: { "#": RegExp(r'[0-9]') });
  var maskFormatterSaida = MaskTextInputFormatter(mask: '##/##/####', filter: { "#": RegExp(r'[0-9]') });

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
        SizedBox(height: 50),
        criaForm(),
        SizedBox(height: 50),
        criaBotaoConsultar(),
      ],
    );
  }

  textoinicial() {
    return Container(
      padding: const EdgeInsets.only(top: 5.0),
      child: Column(
        children: const <Widget>[
          Texts.RelatorioEntradaText,
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
        onPressed: () => consulta(),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Defina o período de data: '),
            ],
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

  consulta() async {
    if(podeConsultar()){
      ProgressDialog pd = ProgressDialog(context: context);
      pd.show(max: 100, msg: 'Consultando', progressType: ProgressType.valuable);

      DateTime dtini = DateFormat('dd/MM/yyyy').parse(_dtentrada.text);
      DateTime dtfim = DateFormat('dd/MM/yyyy').parse(_dtsaida.text);
      String d1 = DateFormat('yyyy-MM-dd').format(dtini);
      String d2 = DateFormat('yyyy-MM-dd').format(dtfim);

      List<Airbndmdl> envio = await getConsultaReservas(context, d1, d2);
      pd.close();
      if(envio != null) {
        await _criaPdf(context, envio);

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

  _criaPdf(BuildContext context, List<Airbndmdl> mdl) async {
    final pw.Document pdf = pw.Document(deflate: zlib.encode);
    pdf.addPage(pw.MultiPage(
        margin: pw.EdgeInsets.all(4),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => <pw.Widget>[
          pw.Paragraph(text: "OS INQUILINOS SÃO PROIBIDOS RECEBEREM VISITAS, SALVO SE AUTORIZADOS POR NÓS."),
          pw.Paragraph(text: " "),
          pw.Table.fromTextArray(
              context: context,
              headerStyle: pw.TextStyle(fontSize: 12),
              headerAlignment: pw.Alignment.centerLeft,
              cellAlignment: pw.Alignment.topLeft,
              cellStyle: pw.TextStyle(fontSize: 10),
              data: <List<String>>[
                <String>['Entrada','Saida','Ap','Inquilino','Garagem'],
                for (int i = 0; i < mdl.length; i++)
                  <String>['${DataUtil.formataDataComDiaExtensoSemHora(mdl[i].entrada)}',
                    '${DataUtil.formataDataComDiaExtensoSemHora(mdl[i].saida)}',
                    '${mdl[i].objApartamento.numero.toString()}',
                    '${mdl[i].hospede}', verificaGaragem(mdl[i].objGaragem)],
              ]),
          pw.Paragraph(text: " "),
          pw.Paragraph(text: "OS INQUILINOS SÃO PROIBIDOS RECEBEREM VISITAS, SALVO SE AUTORIZADOS POR NÓS."),
          pw.Paragraph(text: "Dúvidas, estamos a diposição."),
          pw.Paragraph(text: "Ennio (19) 99958.3622"),
          pw.Paragraph(text: "Sônia (35) 9744.4272"),
          pw.Padding(padding: const pw.EdgeInsets.all(10)),
        ]));

    final String dir = (await getTemporaryDirectory()).path;

    final String arquivo = 'pdf_'+ DateFormat('dd_MM_yyyy').format(DateTime.now()) +'.pdf';
    final String diretorio = '$dir';
    final file = File("${diretorio}/" + arquivo);

    await file.writeAsBytes(await pdf.save());
    var files = File("${diretorio}/" + arquivo);

    /*ShareExtend.share(diretorio + '/' + arquivo, "file",
        sharePanelTitle: "Enviar PDF", subject: "Reservas");*/

    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ViewPdf("${diretorio}/" + arquivo)));

  }

  String verificaGaragem(GaragemMdl? objGaragem) {
    if(objGaragem != null){
      return objGaragem.descricao.toString() + ' - ' + objGaragem.numero.toString();
    } else {
      return '';
    }
  }


}
