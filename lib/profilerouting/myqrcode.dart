import 'package:android/component.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
// import '../dashboard.dart';

class MyQrcode extends StatefulWidget {
  MyQrcode({this.data});
  final dynamic data;

  @override
  _MyQrcodeState createState() => _MyQrcodeState();
}

class _MyQrcodeState extends State<MyQrcode> {
  void initState() {
    print(widget.data);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          centerTitle: true,
          // backgroundColor: Colors.blue,
          title: Text(
            'Terima Saldo',
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
        ),
        body: ListView(
          children: [
            PangkatPendek(height: 80),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width - 50,
                height: MediaQuery.of(context).size.height - 300,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[50],
                        blurRadius: 15.0,
                      ),
                    ]),
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Ajak Teman Kamu Untuk Scan QR Dibawah Ini Untuk Meminta Saldo Dari Mereka',
                          textAlign: TextAlign.center,
                        )),
                    Container(
                      width: MediaQuery.of(context).size.width - 80,
                      height: MediaQuery.of(context).size.height - 400,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          QrImage(
                            data:
                                "{${widget.data['kode']}/${widget.data['nama']}/${widget.data['pengirim'][0]['pengirim']}",
                            version: QrVersions.auto,
                            size: 200.0,
                          ),
                          Text(widget.data['nama'])
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
