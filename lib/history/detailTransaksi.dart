import 'dart:async';

import 'package:android/history/preview.dart';
// import 'package:bluetooth/bluetooth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'package:scoped_model/scoped_model.dart';

import '../categoryOperator.dart';
import '../component.dart';
import '../dashboard.dart';
import '../listWarna.dart';

class DetailTransaksi extends StatefulWidget {
  DetailTransaksi({this.data, this.kode});
  final dynamic data;
  final int kode;
  @override
  _DetailTransaksiState createState() => _DetailTransaksiState();
}

class _DetailTransaksiState extends State<DetailTransaksi> {
  // BluetoothState bluetoothState = BluetoothState.UNKNOWN;
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  // String _address = "...";
  // String _name = "...";

  Timer _discoverableTimeoutTimer;
  // int _discoverableTimeoutSecondsLeft = 0;

  // // BackgroundCollectingTask _collectingTask;

  // bool _autoAcceptPairingRequests = false;
  List ket;
  dynamic keterangan;
  // FlutterBlue flutterBlue = FlutterBlue.instance;
  // ignore: cancel_subscriptions
  // scanBluetooth() {
  //   flutterBlue.scan().listen((scanResult) {
  //     print('ini hasil scan <<<<<<<<<');
  //     print(scanResult);
  //   });
  // }

  get dompetDigita => null;

  @override
  void initState() {
    super.initState();
    // scanBluetooth();
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
      print('ini state nya <<<<<<<<<<<<<<<<');
      print(_bluetoothState.toString());
    });

    // Future.doWhile(() async {
    //   // Wait if adapter not enabled
    //   if (await FlutterBluetoothSerial.instance.isEnabled) {
    //     return false;
    //   }
    //   await Future.delayed(Duration(milliseconds: 0xDD));
    //   return true;
    // }).then((_) {
    //   // Update the address field
    //   FlutterBluetoothSerial.instance.address.then((address) {
    //     setState(() {
    //       _address = address;
    //     });
    //   });
    // });

    // FlutterBluetoothSerial.instance.name.then((name) {
    //   setState(() {
    //     _name = name;
    //   });
    // });

    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;

        // Discoverable mode is disabled when Bluetooth gets disabled
        // _discoverableTimeoutTimer = null;
        // _discoverableTimeoutSecondsLeft = 0;
      });
    });

    print('ini sn');
    print(widget.data['sn']);
    if (widget.data['produk']['kode_operator'] == 'PP' &&
        widget.data['sn'] != null) {
      print('kriteria terpenuhi');
      ket = widget.data['sn'].split('/');
      if (ket.length > 0) {
        setState(() {
          keterangan = {
            "token": "${ket[0]}",
            "nama": "${ket[1]}",
            "golongan": "${ket[2]}",
            "daya": "${ket[3]}",
            "kwh": "${ket[4]}",
          };
          print(keterangan['kwh']);
        });
      }
    } else if (widget.data['produk']['kode_operator'] == 'PPLN' &&
        widget.data['sn'] != null) {
      ket = widget.data['sn'].split('/');
      String tarif = ket[1].substring(10, ket[1].length);
      String jmlBln = ket[3].substring(7, ket[3].length);
      String periode = ket[4].substring(8, ket[4].length);
      String tagihan = ket[5].substring(3, ket[5].length);
      String denda = ket[6].substring(6, ket[6].length);
      String admin = ket[7].substring(6, ket[7].length);
      String totalTagihan = ket[8].substring(9, ket[8].length);
      String stand = ket[9].substring(6, ket[9].length);
      if (ket.length > 0) {
        setState(() {
          keterangan = {
            "nama": "${ket[0]}",
            "tarifDaya": "$tarif / ${ket[2]}",
            "jumlahBulan": "$jmlBln",
            "periode": "$periode",
            "tagihan": "$tagihan",
            "denda": "$denda",
            "admin": "$admin",
            "totalTagihan": "$totalTagihan",
            "stand": "$stand"
          };
          print(keterangan);
        });
      }
    } else if (widget.data['produk']['kode_operator'] ==
            'TELP' && // sudah ada reff nya
        widget.data['sn'] != null) {
      if (widget.data['sn'] != null) {
        ket = widget.data['sn'].split('/');
        print(ket);
        String totalTagihan = ket[1].substring(3, ket[1].length);
        print(totalTagihan);
        String biller = ket[2].substring(7, ket[2].length);
        print(biller);
        String jumlahBulan = ket[3].substring(7, ket[3].length);
        print(jumlahBulan);
        String adm = ket[4].substring(4, ket[4].length);
        print(adm);
        String reff = ket[5].substring(5, ket[5].length);
        print('ini reff nya <<<<<<<<<<');
        print(reff);
        if (ket.length > 0) {
          setState(() {
            keterangan = {
              "nama": "${ket[0]}",
              "totalTagihan": "$totalTagihan",
              "biller": "$biller",
              "jumlahBulan": "$jumlahBulan",
              "admin": "$adm",
              "reff": "$reff"
            };
            print(keterangan);
          });
        }
      }
    } else if (widget.data['produk']['kode_operator'] == 'BPJS' &&
        widget.data['sn'] != null) {
      ket = widget.data['sn'].split('/');
      String totalTagihan = ket[1].substring(3, ket[1].length);
      print(totalTagihan);
      String jumlahPeserta = ket[2].substring(8, ket[2].length);
      print(jumlahPeserta);
      String cabang = ket[3].substring(7, ket[3].length);
      print(cabang);
      String jumlahBulan = ket[4].substring(7, ket[4].length);
      print(jumlahBulan);
      String adm = ket[5].substring(4, ket[5].length);
      print(adm);
      if (ket.length > 0) {
        setState(() {
          keterangan = {
            "nama": "${ket[0]}",
            "jumlahPeserta": "$jumlahPeserta",
            "cabang": "$cabang",
            "jumlahBulan": "$jumlahBulan",
            "admin": "$adm",
            "totalTagihan": "$totalTagihan"
          };
          print(keterangan);
        });
      }
    } else if (widget.data['produk']['kode_operator'] == 'PAM' &&
        widget.data['sn'] != null) {
      ket = widget.data['sn'].split('/');
      if (widget.data["produk"]["nama"].contains('CEK') == false) {
        print(ket);
        String tagihan = ket[1].substring(6, ket[1].length);
        String admin = ket[2].substring(6, ket[2].length);
        String totalTagihan = ket[3].substring(9, ket[3].length);
        String jmlBln = ket[4].substring(7, ket[4].length);
        String periode = ket[5].substring(8, ket[5].length);
        String stand = ket[6].substring(6, ket[6].length);
        String reff = ket[7].substring(5, ket[7].length);
        print('ini reff nya <<<<<<<<<<');
        print(reff);
        if (ket.length > 0) {
          setState(() {
            keterangan = {
              "nama": "${ket[0]}",
              "periode": "$periode",
              "jumlahBulan": "$jmlBln",
              "stand": "$stand",
              "tagihan": "$tagihan",
              "admin": "$admin",
              "totalTagihan": "$totalTagihan",
              "reff": "$reff"
            };
            print(keterangan);
          });
        }
      } else {
        print(ket);
        String tagihan = ket[1].substring(6, ket[1].length);
        String admin = ket[2].substring(6, ket[2].length);
        String totalTagihan = ket[3].substring(9, ket[3].length);
        String jmlBln = ket[4].substring(7, ket[4].length);
        String periode = ket[5].substring(8, ket[5].length);
        String stand = ket[6].substring(6, ket[6].length);
        if (ket.length > 0) {
          setState(() {
            keterangan = {
              "nama": "${ket[0]}",
              "periode": "$periode",
              "jumlahBulan": "$jmlBln",
              "stand": "$stand",
              "tagihan": "$tagihan",
              "admin": "$admin",
              "totalTagihan": "$totalTagihan",
            };
            print(keterangan);
          });
        }
      }
    } else if (widget.data['produk']['kode_operator'] ==
            'TELKOM' && // sudah ada reffnya
        widget.data['sn'] != null) {
      ket = widget.data['sn'].split('/');
      String totalTagihan = ket[1].substring(3, ket[1].length);
      print(totalTagihan);
      // String biller = ket[2].substring(8, ket[2].length);
      // print(biller);
      String periode = ket[2].substring(8, ket[2].length);
      print(periode);
      String jumlahBulan = ket[5].substring(7, ket[5].length);
      print(jumlahBulan);
      String adm = ket[6].substring(4, ket[6].length);
      print(adm);
      int tagihan = int.parse(totalTagihan) - int.parse(adm);
      print(tagihan);
      String reff = ket[7].substring(5, ket[7].length);
      print('ini reff nya <<<<<<<<<<');
      print(reff);
      if (ket.length > 0) {
        setState(() {
          keterangan = {
            "nama": "${ket[0]}",
            "totalTagihan": "$totalTagihan",
            // "biller": "$biller",
            "periode": "$periode",
            "jumlahBulan": "$jumlahBulan",
            "admin": "$adm",
            "tagihan": "$tagihan",
            "reff": "$reff"
          };
          print(keterangan);
        });
      }
    } else if (widget.data['produk']['kode_operator'] == 'PGN' &&
        widget.data['sn'] != null) {
      ket = widget.data['sn'].split('/');
      if (ket[ket.length - 1].contains('TAG')) {
        String totalTagihan = ket[1].substring(3, ket[1].length);
        String periode = ket[2].substring(8, ket[2].length);
        String jumlahBulan = ket[3].substring(7, ket[3].length);
        String adm = ket[4].substring(6, ket[4].length);
        String tagihan = ket[5].substring(4, ket[5].length);
        if (ket.length > 0) {
          setState(() {
            keterangan = {
              "nama": "${ket[0]}",
              "totalTagihan": "$totalTagihan",
              "periode": "$periode",
              "jumlahBulan": "$jumlahBulan",
              "admin": "$adm",
              "tagihan": "$tagihan"
            };
            print(keterangan);
          });
        }
      } else {
        String totalTagihan = ket[1].substring(3, ket[1].length);
        String periode = ket[2].substring(8, ket[2].length);
        String jumlahBulan = ket[3].substring(7, ket[3].length);
        String adm = ket[4].substring(6, ket[4].length);
        int tagihan = int.parse(totalTagihan) - int.parse(adm);
        if (ket.length > 0) {
          setState(() {
            keterangan = {
              "nama": "${ket[0]}",
              "totalTagihan": "$totalTagihan",
              "periode": "$periode",
              "jumlahBulan": "$jumlahBulan",
              "admin": "$adm",
              "tagihan": "$tagihan"
            };
            print(keterangan);
          });
        }
      }
    } else if (widget.data['produk']['kode_operator'] == 'ZWD' &&
        widget.data['sn'] != null) {
      ket = widget.data['sn'].split('/');
      var regex = new RegExp(r'[^0-9]'); // hapus semua kecuali 0-9
      print(ket);
      String bank = ket[1].substring(5, ket[1].length);
      print(bank);
      String noTujuan = ket[2];
      print(noTujuan);
      String nominal = ket[3].substring(3, ket[3].length);
      print(nominal);
      String adm = ket[4].substring(6, ket[4].length);
      print(adm);
      String totalTagihan =
          ket[5].substring(10, ket[5].length).replaceAll(regex, '');
      print(totalTagihan);
      String reff = ket[6].substring(5, ket[6].length);
      print(reff);
      if (ket.length > 0) {
        setState(() {
          keterangan = {
            "nama": "${ket[0]}",
            "bank": "$bank",
            "noTujuan": "$noTujuan",
            "nominal": "$nominal",
            "admin": "$adm",
            "totalTagihan": "$totalTagihan",
            "reff": "$reff"
          };
          print(keterangan);
        });
      }
    } else {
      print('produk blm di daftarkan');
      print(widget.data['produk']['kode_operator']);
      if (keterangan == null) {
        print('keterangan NULL');
      } else {
        print('keterangan TIDAK null');
      }
    }
    // print(keterangan);
  }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    // _collectingTask?.dispose();
    _discoverableTimeoutTimer?.cancel();
    super.dispose();
  }

  // ignore: missing_return
  Future<bool> _back() {
    if (widget.kode == 1) {
      Navigator.pop(context);
    } else {
      return Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => Dashboard(selected: 0)));
    }
  }

  @override
  Widget build(BuildContext context) {
    String waktuTransaksi = widget.data['tgl_entri'];
    String waktuStatus = widget.data['tgl_status'];
    DateTime parseDateTtransaksi =
        new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(waktuTransaksi);
    var inputDateTransaksi = DateTime.parse(parseDateTtransaksi.toString());
    var outputFormatTransaksi = DateFormat('dd/MMMM/yyyy hh:mm:ss');
    var outputDateTransaksi = outputFormatTransaksi.format(inputDateTransaksi);
    waktuTransaksi = outputDateTransaksi;
    DateTime parseDateStatus =
        new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(waktuStatus);
    var inputDateStatus = DateTime.parse(parseDateStatus.toString());
    var outputFormatStatus = DateFormat('dd/MMMM/yyyy hh:mm:ss');
    var outputDateStatus = outputFormatStatus.format(inputDateStatus);
    waktuStatus = outputDateStatus;
    return WillPopScope(
      onWillPop: _back,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Detail Transaksi'),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          body: AnimationLimiter(
              child: ListView(
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 1000),
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: MediaQuery.of(context).size.width / 2,
                child: FadeInAnimation(child: widget),
              ),
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0, 10),
                            blurRadius: 10)
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2 + 100,
                            child: Text(widget.data['produk']['nama'],
                                style: TextStyle(
                                    color: Warna.warna(biru),
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      Divider(),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Nomor Tujuan',
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(widget.data['tujuan']),
                                GestureDetector(
                                  onTap: () {
                                    Clipboard.setData(new ClipboardData(
                                        text:
                                            widget.data['tujuan'].toString()));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content:
                                          Text('No Tujuan Berhasil di Copy'),
                                    ));
                                  },
                                  child: Icon(
                                    Icons.copy_rounded,
                                    color: Warna.warna(biru),
                                  ),
                                )
                              ],
                            )
                          ]),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Deskripsi Produk',
                              style: TextStyle(color: Colors.grey[400])),
                          Text(widget.data['produk']['nama'])
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Harga',
                              style: TextStyle(color: Colors.grey[400])),
                          Text(NumberFormat.currency(
                                  locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                              .format(widget.data['harga']))
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0, 10),
                            blurRadius: 10)
                      ]),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Informasi Transaksi',
                                style: TextStyle(
                                    color: Warna.warna(biru),
                                    fontWeight: FontWeight.bold)),
                            Icon(Icons.event_note, color: Warna.warna(biru))
                          ],
                        ),
                        Divider(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            widget.data["status"] == 20
                                ? Text('Berhasil',
                                    style: TextStyle(
                                        color: Colors.green[600],
                                        fontWeight: FontWeight.bold))
                                : widget.data["status"] == 40
                                    ? Text('Gagal',
                                        style: TextStyle(
                                            color: Colors.red[600],
                                            fontWeight: FontWeight.bold))
                                    : widget.data["status"] == 55
                                        ? Text('Time Out',
                                            style: TextStyle(
                                                color: Colors.red[600],
                                                fontWeight: FontWeight.bold))
                                        : widget.data["status"] == 2 ||
                                                widget.data["status"] == 3
                                            ? Text('Dalam Proses',
                                                style: TextStyle(
                                                    color: Warna.warna(kuning),
                                                    fontWeight:
                                                        FontWeight.bold))
                                            : widget.data["status"] == 43
                                                ? Text('Saldo Tidak Cukup',
                                                    style: TextStyle(
                                                        color:
                                                            Warna.warna(kuning),
                                                        fontWeight:
                                                            FontWeight.bold))
                                                : Text(widget.data["status"]
                                                    .toString())
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        if (keterangan == null &&
                            produkReedem.contains(widget.data['kode_produk']) ==
                                false)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Nomor Serial',
                                  style: TextStyle(color: Colors.grey[400])),
                              Text(widget.data['sn'] ?? "-"),
                              // widget.data['sn'] != null
                              //     ? Text(widget.data['sn'])
                              //     : Text('null'),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        if (keterangan == null &&
                            produkReedem.contains(widget.data['kode_produk']))
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Kode Reedem',
                                  style: TextStyle(color: Colors.grey[400])),
                              Text(widget.data['sn'] ?? "-"),
                              // widget.data['sn'] != null
                              //     ? Text(widget.data['sn'])
                              //     : Text('null'),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        if (keterangan != null &&
                            widget.data['produk']['kode_operator'] == 'PP')
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Nama',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(keterangan['nama'])
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Golongan',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(keterangan['golongan'])
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Daya',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(keterangan['daya'])
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('KWH',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(keterangan['kwh'])
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Token',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(keterangan['token'],
                                        style: TextStyle(
                                            color: Warna.warna(biru),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        if (keterangan != null &&
                            widget.data['produk']['kode_operator'] == 'PPLN')
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Nama',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(keterangan['nama'])
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Tarif / Daya',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(keterangan['tarifDaya'])
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Jumlah Bulan',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(keterangan['jumlahBulan'])
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Periode',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(keterangan['periode'])
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Tagihan',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(
                                        NumberFormat.currency(
                                                locale: 'id',
                                                symbol: 'Rp ',
                                                decimalDigits: 0)
                                            .format(int.parse(
                                                keterangan['tagihan'])),
                                        style: TextStyle(
                                            color: Warna.warna(biru),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Denda',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(keterangan['denda'])
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Admin',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(keterangan['admin'])
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Total Tagihan',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(
                                        NumberFormat.currency(
                                                locale: 'id',
                                                symbol: 'Rp ',
                                                decimalDigits: 0)
                                            .format(int.parse(
                                                keterangan['totalTagihan'])),
                                        style: TextStyle(
                                            color: Warna.warna(biru),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Stand',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(keterangan['stand'],
                                        style: TextStyle(
                                            color: Warna.warna(biru),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        if (keterangan != null &&
                            widget.data['produk']['kode_operator'] == 'BPJS')
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Nama',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(keterangan['nama'])
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Jumlah Peserta',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(keterangan['jumlahPeserta'])
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Cabang',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(keterangan['cabang'])
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Jumlah Bulan',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(keterangan['jumlahBulan'])
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Admin',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(
                                        NumberFormat.currency(
                                                locale: 'id',
                                                symbol: 'Rp ',
                                                decimalDigits: 0)
                                            .format(
                                                int.parse(keterangan['admin'])),
                                        style: TextStyle(
                                            color: Warna.warna(biru),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Total Tagihan',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(
                                        NumberFormat.currency(
                                                locale: 'id',
                                                symbol: 'Rp ',
                                                decimalDigits: 0)
                                            .format(int.parse(
                                                keterangan['totalTagihan'])),
                                        style: TextStyle(
                                            color: Warna.warna(biru),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        if (keterangan != null &&
                            widget.data['produk']['kode_operator'] == 'TELP')
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Nama',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(keterangan['nama'])
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Reff',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(keterangan['reff'])
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Biller',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(keterangan['biller'])
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Jumlah Bulan',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(keterangan['jumlahBulan'])
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Admin',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(
                                        NumberFormat.currency(
                                                locale: 'id',
                                                symbol: 'Rp ',
                                                decimalDigits: 0)
                                            .format(
                                                int.parse(keterangan['admin'])),
                                        style: TextStyle(
                                            color: Warna.warna(biru),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Total Tagihan',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(
                                        NumberFormat.currency(
                                                locale: 'id',
                                                symbol: 'Rp ',
                                                decimalDigits: 0)
                                            .format(int.parse(
                                                keterangan['totalTagihan'])),
                                        style: TextStyle(
                                            color: Warna.warna(biru),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        if (keterangan != null &&
                            widget.data['produk']['kode_operator'] == 'PAM')
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Nama',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(keterangan['nama'])
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                if (widget.data["produk"]["nama"]
                                        .contains('CEK') ==
                                    false)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('Reff',
                                          style: TextStyle(
                                              color: Colors.grey[400])),
                                      Text(keterangan['reff']),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Periode',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(keterangan['periode'])
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Jumlah Bulan',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(keterangan['jumlahBulan'])
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Stand',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(keterangan['stand'],
                                        style: TextStyle(
                                            color: Warna.warna(biru),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Tagihan',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(
                                        NumberFormat.currency(
                                                locale: 'id',
                                                symbol: 'Rp ',
                                                decimalDigits: 0)
                                            .format(int.parse(
                                                keterangan['tagihan'])),
                                        style: TextStyle(
                                            color: Warna.warna(biru),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Admin',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(keterangan['admin'])
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Total Tagihan',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(
                                        NumberFormat.currency(
                                                locale: 'id',
                                                symbol: 'Rp ',
                                                decimalDigits: 0)
                                            .format(int.parse(
                                                keterangan['totalTagihan'])),
                                        style: TextStyle(
                                            color: Warna.warna(biru),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        if (keterangan != null &&
                            widget.data['produk']['kode_operator'] == 'TELKOM')
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Nama',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(keterangan['nama'])
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                // Column(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: <Widget>[
                                //     Text('Biller',
                                //         style:
                                //             TextStyle(color: Colors.grey[400])),
                                //     Text(keterangan['biller'])
                                //   ],
                                // ),
                                // SizedBox(
                                //   height: 10,
                                // ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Reff',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(keterangan['reff'])
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Periode',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(keterangan['periode'])
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Jumlah Bulan',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(keterangan['jumlahBulan'])
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Tagihan',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(
                                        NumberFormat.currency(
                                                locale: 'id',
                                                symbol: 'Rp ',
                                                decimalDigits: 0)
                                            .format(int.parse(
                                                keterangan['tagihan'])),
                                        style: TextStyle(
                                            color: Warna.warna(biru),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Admin',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(
                                        NumberFormat.currency(
                                                locale: 'id',
                                                symbol: 'Rp ',
                                                decimalDigits: 0)
                                            .format(
                                                int.parse(keterangan['admin'])),
                                        style: TextStyle(
                                            color: Warna.warna(biru),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Total Tagihan',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(
                                        NumberFormat.currency(
                                                locale: 'id',
                                                symbol: 'Rp ',
                                                decimalDigits: 0)
                                            .format(int.parse(
                                                keterangan['totalTagihan'])),
                                        style: TextStyle(
                                            color: Warna.warna(biru),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        if (keterangan != null &&
                            widget.data['produk']['kode_operator'] == 'PGN')
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Nama',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(keterangan['nama'])
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Periode',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(keterangan['periode'])
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Jumlah Bulan',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(keterangan['jumlahBulan'])
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Tagihan',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(
                                        NumberFormat.currency(
                                                locale: 'id',
                                                symbol: 'Rp ',
                                                decimalDigits: 0)
                                            .format(int.parse(
                                                keterangan['tagihan'])),
                                        style: TextStyle(
                                            color: Warna.warna(biru),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Admin',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(
                                        NumberFormat.currency(
                                                locale: 'id',
                                                symbol: 'Rp ',
                                                decimalDigits: 0)
                                            .format(
                                                int.parse(keterangan['admin'])),
                                        style: TextStyle(
                                            color: Warna.warna(biru),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Total Tagihan',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(
                                        NumberFormat.currency(
                                                locale: 'id',
                                                symbol: 'Rp ',
                                                decimalDigits: 0)
                                            .format(int.parse(
                                                keterangan['totalTagihan'])),
                                        style: TextStyle(
                                            color: Warna.warna(biru),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        if (keterangan != null &&
                            widget.data['produk']['kode_operator'] == 'ZWD')
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Nama',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(keterangan['nama'])
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Nominal',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(
                                        NumberFormat.currency(
                                                locale: 'id',
                                                symbol: 'Rp ',
                                                decimalDigits: 0)
                                            .format(int.parse(
                                                keterangan['nominal'])),
                                        style: TextStyle(
                                            color: Warna.warna(biru),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Admin',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(
                                        NumberFormat.currency(
                                                locale: 'id',
                                                symbol: 'Rp ',
                                                decimalDigits: 0)
                                            .format(
                                                int.parse(keterangan['admin'])),
                                        style: TextStyle(
                                            color: Warna.warna(biru),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Total Tagihan',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(
                                        NumberFormat.currency(
                                                locale: 'id',
                                                symbol: 'Rp ',
                                                decimalDigits: 0)
                                            .format(int.parse(
                                                keterangan['totalTagihan'])),
                                        style: TextStyle(
                                            color: Warna.warna(biru),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Reff',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    Text(keterangan['reff'])
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Pengisian Ke',
                                style: TextStyle(color: Colors.grey[400])),
                            Text('1')
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        if (keterangan == null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Admin',
                                  style: TextStyle(color: Colors.grey[400])),
                              Text('Rp. 0')
                            ],
                          ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Bonus Poin',
                                style: TextStyle(color: Colors.grey[400])),
                            Text(widget.data['poin'].toString() ?? '0')
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        if (widget.data["status"] == 40)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Keterangan',
                                  style: TextStyle(color: Colors.grey[400])),
                              Text(widget.data['keterangan'] ?? '-',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('ID Transaksi',
                                style: TextStyle(color: Colors.grey[400])),
                            Text(widget.data['kode'].toString())
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Waktu Transaksi',
                                style: TextStyle(color: Colors.grey[400])),
                            Text(waktuTransaksi)
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Waktu Status',
                                style: TextStyle(color: Colors.grey[400])),
                            Text(waktuStatus)
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ]),
                )
              ],
            ),
          )),
          floatingActionButton: widget.data["status"] == 20 &&
                  widget.data["produk"]["nama"].contains('CEK') == false &&
                  widget.data['harga'] != 0
              ? FloatingActionButton(
                  child: Icon(Icons.print),
                  onPressed: () {
                    if (_bluetoothState.toString().contains('ON')) {
                      print(_bluetoothState.toString());
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Preview(data: widget.data)));
                    } else {
                      print(_bluetoothState.toString());
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Bluetooth Anda Belum Aktif'),
                        duration: Duration(seconds: 3),
                        // margin: EdgeInsets.all(10),
                      ));
                    }
                  })
              : null
          // FloatingActionButton(
          //   onPressed: () {
          //     print(widget.data["produk"]["kode_operator"]);
          //     widget.data["status"] == 20 &&
          //             widget.data["produk"]["nama"].contains('CEK') == false &&
          //             widget.data['harga'] != 0
          //         ? Navigator.of(context).push(MaterialPageRoute(
          //             builder: (context) => Preview(data: widget.data)))
          //         : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //             content: Text("Tidak Bisa Diprint"),
          //             duration: Duration(milliseconds: 500)));
          //   },
          //   child: Icon(Icons.print),
          // )
          ),
    );
  }
}

// &&
//                       produkPrint
//                           .contains(widget.data["produk"]["kode_operator"]) 