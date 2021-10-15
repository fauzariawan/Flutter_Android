import 'package:android/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../listWarna.dart';
import './produkPromo.dart';
import 'cekTagihan.dart';

class Pln extends StatefulWidget {
  @override
  _PlnState createState() => _PlnState();
}

class _PlnState extends State<Pln> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('PLN'),
          centerTitle: true,
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
          },
          child: ListView(
            children: [
              PangkatPendek(height: 80),
              Container(
                height: MediaQuery.of(context).size.height - 200,
                child: Stack(
                  children: [
                    AnimationLimiter(
                        child: Column(
                      children: AnimationConfiguration.toStaggeredList(
                        duration: const Duration(milliseconds: 1000),
                        childAnimationBuilder: (widget) => SlideAnimation(
                          horizontalOffset:
                              MediaQuery.of(context).size.width / 2,
                          child: FadeInAnimation(child: widget),
                        ),
                        children: <Widget>[
                          Menu(
                            title: 'PLN Prabayar',
                            subTitle: 'Beli Token Pulsa PLN',
                            kodeOperator: {
                              "kode": "PP",
                              "nama": "PLN Prabayar"
                            },
                          ),
                          Menu(
                            title: 'PLN Pascabayar',
                            subTitle: 'Bayar Tagihan PLN',
                            kodeOperator: {
                              "kode": "CPLN",
                              "nama": "PLN Pascabayar"
                            },
                          ),
                          Menu(
                            title: 'PLN NONTAGLIS',
                            subTitle: 'PLN NON TAGIHAN LISTRIK (NONTAGLIS)',
                            kodeOperator: {"kode": "", "nama": "PLN NONTAGLIS"},
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Produk maintenance pukul 23:45 s/d 00:30',
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )),

                    // Positioned(
                    //   bottom: 10,
                    //   child: Container(
                    //     width: MediaQuery.of(context).size.width,
                    //     child: Text(
                    //       'Produk maintenance pukul 23:45 s/d 00:30',
                    //       style: TextStyle(color: Colors.grey),
                    //       textAlign: TextAlign.center,
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class Menu extends StatelessWidget {
  Menu({this.title, this.subTitle, this.kodeOperator});
  final String title;
  final String subTitle;
  final dynamic kodeOperator;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        kodeOperator['kode'] == 'PP'
            ? Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProdukPromo(data: kodeOperator)))
            : Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CekTagihan(data: kodeOperator)));
      },
      child: Container(
        margin: EdgeInsets.only(top: 20, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Warna.warna(biru),
            boxShadow: [
              BoxShadow(color: Warna.warna(kuning), offset: Offset(0, 10))
            ]),
        // ini kalau container diatas di ganti sama Card()
        // shadowColor: Warna.warna(kuning),
        // elevation: 10,
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(10),
        //     side: BorderSide(color: Colors.grey, width: 0)),
        child: Row(children: <Widget>[
          Format.iconAsset('image/logooperator/pln.png'),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 8),
              Text(
                subTitle,
                style: TextStyle(fontSize: 10, color: Colors.white),
              )
            ],
          )
        ]),
      ),
    );
  }
}
