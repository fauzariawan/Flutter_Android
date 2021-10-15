import 'package:android/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../routerName.dart';

class Telkom extends StatefulWidget {
  @override
  _TelkomState createState() => _TelkomState();
}

class _TelkomState extends State<Telkom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TELKOM'),
        elevation: 0,
        centerTitle: true,
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        },
        child: ListView(
          children: [
            PangkatPendek(
              height: 80,
            ),
            AnimationLimiter(
                child: Column(
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 1000),
                childAnimationBuilder: (widget) => SlideAnimation(
                  horizontalOffset: MediaQuery.of(context).size.width / 2,
                  child: FadeInAnimation(child: widget),
                ),
                children: [
                  // GreenBoard(),
                  CardMenu(
                    title: 'TELKOM',
                    description: 'Bayar Tagihan Menggunakan ID Telpon',
                    route: cekTagihan,
                    data: {
                      "kode": "CTELKOM",
                      "nama": "TELKOM",
                      "apk_ikon":
                          "https://res.cloudinary.com/funmo-co-id/image/upload/v1626249417/product/1200px-Telkom_Indonesia_2013.svg_adbatw.png"
                    },
                  ),
                  CardMenu(
                    title: 'SPEEDY',
                    description: 'Bayar Tagihan Menggunakan ID Speedy',
                    route: cekTagihan,
                    data: {
                      "kode": "CSPEEDY",
                      "nama": "SPEEDY",
                      "apk_ikon":
                          "https://res.cloudinary.com/funmo-co-id/image/upload/v1624693230/product/indihome1_rozk1k.png"
                    },
                  ),
                  CardMenu(
                    title: 'Voucher WIFI.ID',
                    description: 'Pembelian Voucher WIFI.ID',
                    route: produkPromo,
                    data: {
                      "kode": "wifi",
                      "nama": "Voucher Wifi.ID",
                      "apk_ikon":
                          "https://res.cloudinary.com/funmo-co-id/image/upload/v1624691471/product/nzdpwgmy5kui0mf6moph.jpg"
                    },
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
