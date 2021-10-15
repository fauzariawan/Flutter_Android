import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../component.dart';
import '../listWarna.dart';

class DaftarRekening extends StatefulWidget {
  DaftarRekening({this.data});
  final dynamic data;
  @override
  _DaftarRekeningState createState() => _DaftarRekeningState();
}

class _DaftarRekeningState extends State<DaftarRekening> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Daftar Rekening'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(children: <Widget>[
            GestureDetector(
              onTap: () {
                Clipboard.setData(new ClipboardData(text: widget.data['jumlah'].toString()));
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('No Rekening Berhasil di Copy'),
                ));
              },
              child: Container(
                alignment: Alignment.center,
                height: 170.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Warna.warna(biru),
                        Colors.white,
                      ]),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  Text(NumberFormat.currency(
                    locale: 'id',
                    decimalDigits: 0,
                    symbol: 'Rp '
                  ).format(widget.data['jumlah']),
                  style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)
                    ),
                  SizedBox(height: 10),
                  Text('KETUK UNTUK MENYALIN NOMINAL',style: TextStyle(fontSize: 12, color: Colors.white))
                ]),
              ),
            ),
            Container(
              child: Column(children: <Widget>[
                CardRekening(namaBank: 'BRI', noRek: '109201000130560', pemilikRek: 'a.n PT. LANGIT MULTI CHIP', status:'TERSEDIA'),
                CardRekening(namaBank: 'BCA', noRek: '8375666444', pemilikRek: 'a.n PT. LANGIT MULTI CHIP', status:'TERSEDIA'),
                CardRekening(namaBank: 'MANDIRI', noRek: '1060044447202', pemilikRek: 'a.n PT. LANGIT MULTI CHIP', status:'TERSEDIA'),
                CardRekening(namaBank: 'BNI', noRek: '4240044444', pemilikRek: 'a.n PT. LANGIT MULTI CHIP', status:'TERSEDIA')
              ],),
            )
          ],),
          Positioned(
            width: MediaQuery.of(context).size.width,
            bottom: 5,
            child: Center(child: Text('HARAP TRANSFER SESUAI NOMINAL YANG TERTERA', style: TextStyle(color: Colors.red[800]))))
        ],
      )
    );
  }
}

