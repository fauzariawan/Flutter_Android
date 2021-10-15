import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../component.dart';
import '../routerName.dart';

class TelpDanSms extends StatefulWidget {
  @override
  _TelpDanSmsState createState() => _TelpDanSmsState();
}

class _TelpDanSmsState extends State<TelpDanSms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('Telp & SMS'),
          centerTitle: true,
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
          },
          child: ListView(
            children: [
              PangkatPendek(
                height: 100,
              ),
              AnimationLimiter(
                  child: Column(
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 1000),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    horizontalOffset: MediaQuery.of(context).size.width / 2,
                    child: FadeInAnimation(child: widget),
                  ),
                  children: <Widget>[
                    CardMenu(
                      title: 'Paket Nelpon',
                      description: 'Khusus Pembelian Paket Nelpon',
                      data: {
                        "kode": "pn",
                        "title": "Paket Nelpon",
                        "kriteria": "4",
                        "kriteria2": "telpon",
                        "description": "Khusus Pembelian Paket Nelpon",
                        "apk_ikon": "https://res.cloudinary.com/funmo-co-id/image/upload/v1632539353/icons/PAKET_TELEPON_x79fpa.png"
                      },
                      route: paketNelpon,
                    ),
                    CardMenu(
                      title: 'Paket SMS',
                      description: 'Khusus Pembelian Paket SMS',
                      data: {
                        "kode": "ps",
                        "title": "Paket SMS",
                        "kriteria": "4",
                        "kriteria2": "sms",
                        "description": "Khusus Pembelian Paket SMS",
                        "apk_ikon": "https://res.cloudinary.com/funmo-co-id/image/upload/v1632539353/icons/PAKET_SMS_r93v00.png"
                      },
                      route: paketNelpon,
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     // Navigator.pushNamed(context, routeName)
                    //   }
                    // )
                  ],
                ),
              )),
            ],
          ),
        ));
  }
}
