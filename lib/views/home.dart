import 'package:flutter/material.dart';
import 'package:reservas/utils/utils.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var menu = [
    {
      'id':'1',
      'title':'Check-In  Check-Out',
      'img':'assets/images/calendario.png',
      'rota':'/calendario'
    },
    {
      'id':'2',
      'title':'Importar',
      'img':'assets/images/importar.png',
      'rota':'/importar'
    },
    {
      'id':'3',
      'title':'Funcionario',
      'img':'assets/images/faxineira.png',
      'rota':'/funcionario'
    },
    {
      'id':'4',
      'title':'Cadastro',
      'img':'assets/images/cadastro.png',
      'rota':'/cadastro'
    },
    /*{
      'id':'4',
      'title':'Garagem',
      'img':'assets/images/garagem.png',
      'rota':'/garagem'
    },*/
    {
      'id':'5',
      'title':'Relatório Entrada',
      'img':'assets/images/rptentrada.png',
      'rota':'/consultacheckin'
    },
    {
      'id':'6',
      'title':'Relatório Faxina',
      'img':'assets/images/rptLimpeza.png',
      'rota':'/consultafaxina'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              bordaSuperior(),
              imagemCentro(),

            ],
          ),
          textoinicial(),
          itens(),
        ],
      )
    );
  }

  bordaSuperior() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: ClipPath(
        clipper: ClippingClass(),
        child: Container(
          height: 120.0,
          decoration: BoxDecoration(color: AppColors.primaryBlack),
        ),
      ),
    );
  }

  imagemCentro() {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 90.0,
          width: 90.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: AssetImage('assets/images/reserva.png')),
            border: Border.all(
              color: Colors.white,
              width: 5.0,
            ),
          ),
        ),
      ),
    );
  }

  textoinicial() {
    return Container(
      child: Column(
        children: const <Widget>[
          Texts.welcomeText,
        ],
      ),
    );
  }

  itens() {
    return Container(
      height: MediaQuery.of(context).size.height / 1.4,
      child: GridView.count(

        scrollDirection: Axis.vertical,
        crossAxisCount: 2,
        children: List.generate(menu.length, (i) {
          return InkWell(
            child: montaItens(i),
            onTap: () => Navigator.pushNamed(context,  menu[i]['rota'].toString()),
          );
        }),
      ),
    );
  }

  Widget buildTitle(String title) {
    return Center(
      child: Container(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        decoration: BoxDecoration(
            border: Border.all(
                width: 2, color: Colors.white, style: BorderStyle.solid)),
      ),
    );
  }

  montaItens(int i) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0)
        ),
        margin: const EdgeInsets.all(10),
        height: 40,
        child: Card(
          elevation: 4,
          child: Container(

              child: Container(
                color: const Color.fromRGBO(0, 0, 0, 0.4),
                child: buildTitle(menu[i]['title'].toString()),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(menu[i]['img'].toString()),
                    fit: BoxFit.contain),

              )
          ),
        )

    );
  }


}

class ClippingClass extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 80);
    path.quadraticBezierTo(
      size.width / 4,
      size.height,
      size.width / 2,
      size.height,
    );
    path.quadraticBezierTo(
      size.width - (size.width / 4),
      size.height,
      size.width,
      size.height - 80,
    );
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
