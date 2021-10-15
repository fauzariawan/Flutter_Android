import 'dart:async';
import 'dart:convert';
import 'dart:io'; // untuk class File
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:android/history/choosePrinter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import '../component.dart';
import '../listWarna.dart';
import 'formatPrint.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

class PreviewMutasi extends StatefulWidget {
  const PreviewMutasi({Key key, this.data}) : super(key: key);
  final dynamic data;

  @override
  _PreviewMutasiState createState() => _PreviewMutasiState();
}

class _PreviewMutasiState extends State<PreviewMutasi> {
  dynamic dataUser;
  int nominal = 0;
  bool _connected;
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  FormatPrint testPrint;
  String pathImage;
  String text = 'https://medium.com/@suryadevsingh24032000';
  String subject = 'follow me';

  // untuk save gambar di library
  GlobalKey _globalKey = GlobalKey();
  // untuk screen shoot //
  int _counter = 0;
  Uint8List _imageFile;
  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    cekPrinter();
    testPrint = FormatPrint();
    print(widget.data);
    // .abs() => berfungsi untuk mengubah minus menjadi plus
    nominal = widget.data['jumlah'].abs();
    callDataUser();
    super.initState();
  }

  cekPrinter() async {
    _connected = await bluetooth.isConnected;
  }

  callDataUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      dataUser = json.decode(prefs.getString('dataUser'));
    });
  }

  cetakStruk() async {
    print('sudah terpanggil');
    testPrint.mutasi(widget.data);
  }

  _saveScreen() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData byteData = await (image.toByteData(format: ui.ImageByteFormat.png)
        as FutureOr<ByteData>);
    if (byteData != null) {
      final result =
          await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
      print(result);
      _toastInfo(result.toString());
    }
  }

  _toastInfo(String info) {
    Fluttertoast.showToast(msg: info, toastLength: Toast.LENGTH_LONG);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Preview Mutasi'),
          centerTitle: true,
        ),
        body: Screenshot(
          // yang di wrap dengan screenshoot akan menjadi gambar
          controller: screenshotController,
          child: imageToShare(),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: FloatingActionButton(
                onPressed: () {
                  takeScreenshoot();
                },
                child: Icon(Icons.share),
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                _connected
                    ? cetakStruk()
                    : Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChoosePrinter(
                              type: 'mutasi',
                              data: widget.data,
                            )));
              },
              child: Icon(Icons.print),
            ),
          ],
        ));
  }

  Widget imageToShare() {
    TextStyle style = TextStyle(fontFamily: 'thermal', color: Colors.black);
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
      // margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      decoration: BoxDecoration(color: Colors.white),
      child: ListView(
        children: <Widget>[
          Text(
            NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                .format(nominal),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Warna.warna(biru), fontFamily: 'thermal', fontSize: 25),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.green[100]),
            child: Text('Transfer Berhasil',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontFamily: 'thermal')),
          ),
          Container(
              margin: EdgeInsets.all(10),
              child: Text(
                "ID Trx : ${widget.data['kode'].toString()}",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 17, fontFamily: 'thermal', color: Colors.black),
              )),
          Divider(),
          Center(
            child: Text('RINCIAN TRANSFER',
                style: TextStyle(fontFamily: 'thermal', color: Colors.black)),
          ),
          Divider(),
          SizedBox(height: 10),
          // Mutasi(
          //   title: 'Pengirim',
          //   value: dataUser['nama'] ?? '',
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Pengirim', style: style),
              Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Text(
                    dataUser['nama'] ?? '',
                    style: style,
                    textAlign: TextAlign.right,
                  ))
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Nominal', style: style),
              Text(
                  NumberFormat.currency(
                          locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                      .format(nominal),
                  style: style)
            ],
          ),
          SizedBox(height: 10),
          // Mutasi(
          //   title: 'Sumber Dana',
          //   value: 'Saldo',
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Sumber Dana', style: style),
              Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Text(
                    'Saldo',
                    style: style,
                    textAlign: TextAlign.right,
                  ))
            ],
          ),
          SizedBox(height: 10),
          // Mutasi(
          //   title: 'Keterangan',
          //   value: widget.data['keterangan'],
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Keterangan', style: style),
              Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Text(
                    widget.data['keterangan'] ?? '',
                    style: style,
                    textAlign: TextAlign.right,
                  ))
            ],
          ),
          SizedBox(height: 20),
          Column(children: <Widget>[
            Text('Transfer Via Funmobile', style: style),
            SizedBox(height: 10),
            Text(Format.formatTanggal(widget.data['tanggal']), style: style)
          ])
        ],
      ),
    );
  }

  void takeScreenshoot() async {
    final imageFile =
        await screenshotController.captureFromWidget(imageToShare());
    saveAndShare(imageFile);
    // Share.shareFiles([imageFile.path]);
    // if (imageFile == null) return;
    // final imagePath = await saveImage(imageFile);
    // print(imagePath);
    // final RenderBox box = context.findRenderObject();
    // Share.shareFiles([imagePath],
    //     text: 'Dari Funmo',
    //     sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    // Share.share('Belum bisa Share ',
    //     subject: subject,
    //     sharePositionOrigin:
    //         box.localToGlobal(Offset.zero) & box.size)
  }

  saveImage(Uint8List imageFile) async {
    await [Permission.storage].request();
    var time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');
    final name = 'FunmoImage_$time';
    final result = await ImageGallerySaver.saveImage(imageFile, name: name);
    return result['filePath'];
  }

  Future saveAndShare(Uint8List imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory);
    var time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');
    final image = File('${directory.path}/funmo$time.png');
    image.writeAsBytesSync(imageFile);
    print(image.path);
    await Share.shareFiles([image.path]);
    // await Share.share('tes');
  }
}

class Mutasi extends StatelessWidget {
  const Mutasi({Key key, this.title, this.value}) : super(key: key);
  final String title;
  final String value;
  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(fontFamily: 'thermal');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(title, style: style),
        Container(
            width: MediaQuery.of(context).size.width / 2,
            child: Text(
              value,
              style: style,
              textAlign: TextAlign.right,
            ))
      ],
    );
  }
}
