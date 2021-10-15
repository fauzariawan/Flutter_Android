import 'package:flutter/material.dart';

import '../component.dart';
import '../listWarna.dart';

class TentangAplikasi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(elevation: 0, title: Text('Tentang Aplikasi')),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset('image/funmo/logofunmini.png'),
                Image.asset('image/funmo/funmomini.png'),
                Text(
                  'V.2.0.17',
                  style: TextStyle(fontSize: 20.0, color:Warna.warna(biru)),
                ),
              ],
            ),
          ),
        ));
  }
}
