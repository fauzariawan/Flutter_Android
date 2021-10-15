import 'package:android/component.dart';
import 'package:android/menuutama/subPaketData/dataInjek.dart';
import 'package:android/menuutama/subPaketData/dataVoucher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../dashboard.dart';
import '../listWarna.dart';
import 'subPaketData/kuota.dart';

class PaketData extends StatefulWidget {
  @override
  _PaketDataState createState() => _PaketDataState();
}

class _PaketDataState extends State<PaketData> {
  List<dynamic> paketData = [
    {
      "kode": "2",
      "title": "Data Injek",
      "subTitle": "Paket Data Yang Langsung Masuk Ke Nomor Tujuan",
      "routing": "/paketDataInjek"
    },
  ];

  Future<bool> _back() {
    return Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Dashboard(
              selected: 0,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _back,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text('Paket Data'),
            centerTitle: true,
            elevation: 0,
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
                    children: <Widget>[
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => DataInjek()));
                          },
                          child: Menu(
                              // icon: Icons.data_usage,
                              icon:
                                  'https://res.cloudinary.com/funmo-co-id/image/upload/v1632971746/icons/ICON_DATA_2_ffjv7m.png',
                              title: 'Data Injek',
                              description:
                                  'Paket Data Yang Langsung Masuk Ke Nomor Tujuan')),
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => dataVoucher()));
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) => Kuota(
                            //           kode: '3',
                            //           title: 'Data Voucher',
                            //         )));
                          },
                          child: Menu(
                              // icon: Icons.data_usage,
                              icon:
                                  'https://res.cloudinary.com/funmo-co-id/image/upload/v1632538437/icons/VOUCHERDATA_128_hxjg9c.png',
                              title: 'Data Voucher',
                              description:
                                  'Paket Data Yang Harus Di Masukkan Secara Manual Oleh Pembeli')),
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Kuota(
                                      kode: 'injek',
                                      title: 'Injek Voucher',
                                    )));
                          },
                          child: Menu(
                              // icon: Icons.data_usage,
                              icon:
                                  'https://res.cloudinary.com/funmo-co-id/image/upload/v1632538514/icons/VOUCHER_ZERO_pxdvho.png',
                              title: 'Injek Voucher',
                              description: 'Aktivasi Voucher Kosong(Zero)'))
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
  Menu({this.icon, this.title, this.description, this.data});
  final String icon;
  final String title;
  final String description;
  final dynamic data;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration,
      // width: MediaQuery.of(context).size.width / 2 + 70,
      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: <Widget>[
            Format.iconNetwork(icon),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Padding(padding: EdgeInsets.all(3.0)),
                Container(
                  width: MediaQuery.of(context).size.width / 2 + 50,
                  child: Text(
                    description,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
