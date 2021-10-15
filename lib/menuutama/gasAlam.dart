import 'package:android/component.dart';
import 'package:flutter/material.dart';

import '../routerName.dart';

class GasAlam extends StatefulWidget {
  @override
  _GasAlamState createState() => _GasAlamState();
}

class _GasAlamState extends State<GasAlam> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('GAS ALAM'),
        centerTitle: true,
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        },
        child: ListView(
          children: [
            Column(
              children: [
                // GreenBoard(),
                PangkatPendek(height: 80),
                CardMenu(
                  title: 'PGN (Perusahaan Gas Negara)',
                  description: 'PGN (Perusahaan Gas Negara)',
                  route: cekTagihan,
                  data: {
                    "kode": "CPGN",
                    "nama": "PGN",
                    "apk_ikon":
                        "https://res.cloudinary.com/funmo-co-id/image/upload/v1624674537/product/ea_pgn_d9d0t3.png"
                  },
                ),
                CardMenu(
                  title: 'PERTAGAS (Pertamina GAS)',
                  description: 'PERTAGAS (Pertamina GAS)',
                  route: cekTagihan,
                  data: {
                    "kode": "CPTRGAS",
                    "nama": "PERTAGAS",
                    "apk_ikon":
                        "https://res.cloudinary.com/funmo-co-id/image/upload/v1624675519/product/y8zRK5J4Ft_1517626570_odxvck.jpg"
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
