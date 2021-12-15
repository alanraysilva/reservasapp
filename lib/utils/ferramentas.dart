
import 'package:flutter/material.dart';
import 'package:reservas/globals.dart' as globals;
import 'package:url_launcher/url_launcher.dart';

Future<String?> mostraMensage(BuildContext context, String titulo, String mensagem, [int tipo = 0])  async {
  var alert = AlertDialog(
    scrollable: true,
    title: Row(
        children:[
          tipo == 0 ?
          Image.asset('assets/dialogo/informacao.png', width: 40, height: 40, fit: BoxFit.contain):
          Image.asset('assets/dialogo/error.png', width: 40, height: 40, fit: BoxFit.contain),
          Text(" " + titulo)
        ]
    ),
    content: Text(mensagem),
    actions: <Widget>[
      TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text("OK")),
    ],
  );
  bool clicou = await showDialog(context: context, builder: (context) => alert);
  if(clicou){
    print('clicou');
    return 'OK';
  }
  else{
    return null;
  }
}

Future<bool?> confirma(
    BuildContext context, String titulo, String mensagem) {
  // flutter defined function

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: Row(
            children:[
              Image.asset('assets/dialogo/informacao.png', width: 40, height: 40, fit: BoxFit.contain),
              Text(" " + titulo)
            ]
        ),
        content: Text(mensagem, textAlign: TextAlign.justify),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          TextButton(
            child: const Text("Não Aceito"),
            onPressed: () {
              //globals.statusConfirma = false;
              Navigator.pop(context, false);
            },
          ),
          TextButton(
            child: const Text("Aceito"),
            onPressed: () {
              //globals.statusConfirma = true;
              Navigator.pop(context, true);
            },
          ),
        ],
      );
    },
  );
}

Future ObterValor(BuildContext context, String msg){
  TextEditingController valorController = TextEditingController();
  double? retorno = 0;
  return showDialog(context: context, builder: (context){
    return AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: Row(
          children:[
            Image.asset('assets/dialogo/dinheiro.png', width: 40, height: 40, fit: BoxFit.contain),
            const Text('  Obter Valor ')
          ]
      ),
      content:  Container(
        height: 90,
        child: Column(
          children: <Widget>[
            Text(msg, style: globals.fomataTituloCampos()),
            const Divider(color:Colors.transparent),
            TextField(
              controller: valorController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)
                ),
                hintText: 'valor',
                labelStyle: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.redAccent
            ),
            child: const Text("Cancelar"),
            onPressed: (){
              retorno = 0;
              Navigator.of(context).pop(retorno);
            }
        ),
        ElevatedButton(
            child: const Text("OK"),
            onPressed: (){
              if(valorController.text.isNotEmpty){
                retorno = double.tryParse(valorController.text.toString());
                Navigator.of(context).pop(retorno);
              }
              else{
                retorno = 0;
                Navigator.of(context).pop(retorno);
              }
            }
        ),
      ],
    );
  });
}


Future ObterQuantidade(BuildContext context, String msg){
  TextEditingController valorController = TextEditingController();
  int retorno = 0;
  return showDialog(context: context, builder: (context){
    return AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: Row(
          children:[
            Image.asset('assets/dialogo/quantidade.png', width: 40, height: 40, fit: BoxFit.contain),
            const Text('  Obter Quantidade ')
          ]
      ),
      content:  Container(
        height: 90,
        child: Column(
          children: <Widget>[
            Text(msg, style: globals.fomataTituloCampos()),
            const Divider(color:Colors.transparent),
            TextField(
              controller: valorController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)
                ),
                hintText: 'Quantide',
                labelStyle: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.redAccent
            ),
            child: const Text("Cancelar"),
            onPressed: (){
              retorno = 0;
              Navigator.of(context).pop(retorno);
            }
        ),
        ElevatedButton(
            child: const Text("OK"),
            onPressed: (){
              if(valorController.text.isNotEmpty){
                retorno = int.tryParse(valorController.text.toString())?? 0;
                Navigator.of(context).pop(retorno);
              }
              else{
                retorno = 0;
                Navigator.of(context).pop(retorno);
              }
            }
        ),
      ],
    );
  });
}


Future Autentica(BuildContext context){
  TextEditingController loginController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  Map<String,String> retorno;
  return showDialog(context: context, builder: (context){
    return AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: Row(
          children:[
            Image.asset('assets/dialogo/login.png', width: 40, height: 40, fit: BoxFit.contain),
            const Text('  Autenticação ')
          ]
      ),
      content:  ConstrainedBox(
        constraints: BoxConstraints(
            minHeight: 100
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            TextField(
              controller: loginController,
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)
                ),
                labelText: 'Login',
                hintText: 'informe o login',
                labelStyle: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
            const SizedBox(height: 30,),
            TextField(
              controller: senhaController,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)
                ),
                labelText: 'Senha',
                hintText: 'informe a senha',
                labelStyle: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
          ],
        ),
      ),

      actions: <Widget>[
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.redAccent
            ),
            child: const Text("Cancelar"),
            onPressed: (){
              retorno = {"cancelou": "S"};
              Navigator.of(context).pop(retorno);
            }
        ),
        ElevatedButton(
            child: const Text("Login"),
            onPressed: (){
              if(loginController.text.isNotEmpty && senhaController.text.isNotEmpty){
                retorno = {
                  "login": loginController.text.toString(),
                  "senha": senhaController.text.toString(),
                  "cancelou": "N"
                };
                Navigator.of(context).pop(retorno);
              }
              else{
                retorno = {"cancelou": "N"};
                Navigator.of(context).pop(retorno);
              }
            }
        ),
      ],
    );
  });
}

 abreWhatsApp(BuildContext context,@required numero, @required msg) async{
  String url = "https://api.whatsapp.com/send?phone=$numero&text=$msg";
  await canLaunch(url)? launch(url): mostraMensage(context, 'Envio', 'Erro ao tentar enviar mensagem por whats app', 1);
}