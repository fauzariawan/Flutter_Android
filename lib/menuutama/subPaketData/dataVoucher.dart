import 'package:android/menuutama/paketData.dart';
import 'package:android/menuutama/subPaketData/kuota.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../component.dart';

class dataVoucher extends StatefulWidget {
  const dataVoucher({Key key}) : super(key: key);

  @override
  _dataVoucherState createState() => _dataVoucherState();
}

class _dataVoucherState extends State<dataVoucher> {
  Future<bool> _back() {
    return Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => PaketData()));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _back,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            centerTitle: true,
            title: Text('Data Voucher'),
            // flexibleSpace: FlexibleSpaceBar(
            //   stretchModes: const <StretchMode>[
            //     StretchMode.zoomBackground,
            //     StretchMode.blurBackground,
            //     StretchMode.fadeTitle,
            //   ],
            // ),
          ),
          body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowGlow();
            },
            child: ListView(
              children: [
                PangkatPendek(height: 100),
                AnimationLimiter(
                    child: Column(
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 1000),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      horizontalOffset: MediaQuery.of(context).size.width / 2,
                      child: FadeInAnimation(child: widget),
                    ),
                    children: [
                      Menu(
                        icon: 'image/logooperator/telkomselmini.png',
                        title: 'Voucher Telkomsel',
                        description: 'Voucher Data Telkomsel',
                        kode: '3t',
                      ),
                      Menu(
                          icon: 'image/logooperator/xlmini.png',
                          title: 'Voucher XL',
                          description: 'Voucher Data XL',
                          kode: '3x'),
                      Menu(
                        icon: 'image/logooperator/axismini.png',
                        title: 'Voucher Axis',
                        description: 'Voucher Data Axis',
                        kode: '3a',
                      ),
                      Menu(
                        icon: 'image/logooperator/threemini.png',
                        title: 'Voucher Three',
                        description: 'Voucher Data Three',
                        kode: '3h',
                      ),
                      Menu(
                          icon: 'image/logooperator/indosatmini.png',
                          title: 'Voucher Indosat',
                          description: 'Voucher Data Indosat',
                          kode: '3i'),
                      Menu(
                          icon: 'image/logooperator/smartfrenmini.png',
                          title: 'Voucher Smartfren',
                          description: 'Voucher Data Smartfren',
                          kode: '3s'),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ));
  }
}

class Menu extends StatelessWidget {
  Menu({this.icon, this.title, this.description, this.kode});
  final String icon;
  final String title;
  final String description;
  final String kode;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Kuota(title: title, kode: kode)));
      },
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 15),
        padding: EdgeInsets.all(10),
        decoration: decoration,
        child: Row(
          children: <Widget>[
            Image.asset(icon, width: 40),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  description,
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 10, color: Colors.white),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
