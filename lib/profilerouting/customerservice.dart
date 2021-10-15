import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:flutter/services.dart'; // untuk whatsapp
import 'dart:async';

import '../component.dart';
import '../listWarna.dart';

class CustomerService extends StatefulWidget {
  @override
  _CustomerServiceState createState() => _CustomerServiceState();
}

class _CustomerServiceState extends State<CustomerService> {
  Future<void> _makePhoneCall(String url) async {
    await launch(url); // untuk menjalan kan ini, applikasi harus di matikan kemudian jalankan kembali melalui flutter run
    // if (await canLaunch(url)) {
    //   await launch(url);
    // } else {
    //   throw 'Could not launch $url';
    // }
  }

  // ignore: unused_field
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterOpenWhatsapp.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: Text('Customer Service')),
        body: Column(
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 30),
                child: Image.asset(
                  'image/funmo/icon/cs2.png',
                  height: 150,
                )),
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      FlutterOpenWhatsapp.sendSingleMessage("+6285824242500", "Hello");
                    },
                    child: CardCs(
                      noTelp: '+6285824242500',
                      title: 'WHATSAPP',
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        _makePhoneCall('tel:085824242500');
                      },
                      child:
                          CardCs(noTelp: '085824242500', title: 'CALL CENTER'))
                ],
              ),
            )
          ],
        ));
  }
}

class CardCs extends StatelessWidget {
  CardCs({this.noTelp, this.title});
  final String noTelp;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        color: Warna.warna(biru),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              title == 'WHATSAPP' ? Image.asset("image/funmo/wa.png", width: 50) : Image.asset("image/funmo/phoneClassic2.png", width: 50),
              Container(
                margin: EdgeInsets.only(left: 10),
                height: 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      noTelp,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Warna.warna(kuning)),
                    ),
                    Text(title,
                        style: TextStyle(fontSize: 12, color: Warna.warna(kuning)))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
