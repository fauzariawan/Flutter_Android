import 'dart:async';

import 'package:android/history/previewMutasi.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import '../component.dart';
import '../listWarna.dart';

class DetailMutasi extends StatefulWidget {
  DetailMutasi({this.data});
  final dynamic data;
  @override
  _DetailMutasiState createState() => _DetailMutasiState();
}

class _DetailMutasiState extends State<DetailMutasi> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  Timer _discoverableTimeoutTimer;

  void initState() {
    super.initState();
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
      print('ini state nya <<<<<<<<<<<<<<<<');
      print(_bluetoothState.toString());
    });
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
      });
    });
    cekTransaksi();
    print(widget.data);
  }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    // _collectingTask?.dispose();
    _discoverableTimeoutTimer?.cancel();
    super.dispose();
  }

  cekTransaksi() {
    if (widget.data["transaksi"] == null) {
      if (widget.data["jumlah"].toString().contains("-")) {
        int jml = int.parse(widget.data["jumlah"]
            .toString()
            .substring(1, widget.data["jumlah"].toString().length));
        widget.data["saldo_awal"] = widget.data["saldo_akhir"] + jml;
        print(widget.data);
      } else {
        widget.data["saldo_awal"] =
            widget.data["saldo_akhir"] - widget.data["jumlah"];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Detail Mutasi'),
          centerTitle: true,
          elevation: 0,
        ),
        body: ListView(
          children: [
            Container(
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
                    Text(
                        NumberFormat.currency(
                                locale: 'id', decimalDigits: 0, symbol: 'Rp ')
                            .format(widget.data['jumlah']),
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ]),
            ),
            Container(
              margin: EdgeInsets.only(top: 30, left: 20, right: 20),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey, offset: Offset(0, 5), blurRadius: 5)
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Informasi Mutasi'),
                      Icon(Icons.info, color: Warna.warna(biru))
                    ],
                  ),
                  Divider(),
                  SizedBox(height: 10),
                  Title(title: 'ID Mutasi'),
                  Text(widget.data["kode"].toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  SizedBox(height: 10),
                  Title(title: "Waktu"),
                  Text(Format.formatTanggal(widget.data["tanggal"]),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  SizedBox(height: 10),
                  Title(title: "Saldo Awal"),
                  widget.data["transaksi"] != null
                      ? Format.formatUang(
                          widget.data["transaksi"]["saldo_awal"])
                      : Format.formatUang(widget.data["saldo_awal"]),
                  SizedBox(height: 10),
                  Title(title: "Saldo Akhir"),
                  Format.formatUang(widget.data["saldo_akhir"]),
                  SizedBox(height: 10),
                  Title(title: "Keterangan"),
                  Text(widget.data["keterangan"],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14))
                ],
              ),
            )
          ],
        ),
        floatingActionButton: widget.data['jenis'] == '1'
            ? FloatingActionButton(
                onPressed: () {
                  if (_bluetoothState.toString().contains('ON')) {
                    print(_bluetoothState.toString());
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            PreviewMutasi(data: widget.data)));
                  } else {
                    print(_bluetoothState.toString());
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Bluetooth Anda Belum Aktif'),
                      duration: Duration(seconds: 3),
                      // margin: EdgeInsets.all(10),
                    ));
                  }
                },
                child: Icon(Icons.print),
              )
            : null);
  }
}

class Title extends StatelessWidget {
  Title({this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(title, style: TextStyle(color: Colors.grey[400], fontSize: 10));
  }
}
