import 'dart:async';
import 'dart:convert';

// import 'package:android/history/detailTransaksi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../component.dart';
import '../dashboard.dart';
import '../listWarna.dart';
import '../routerName.dart';

class KonfirmasiPin extends StatefulWidget {
  KonfirmasiPin({this.data});
  final dynamic data;
  @override
  _KonfirmasiPinState createState() => _KonfirmasiPinState();
}

class _KonfirmasiPinState extends State<KonfirmasiPin> {
  LocalStorage storage = new LocalStorage('localstorage_app');
  dynamic res;
  String strPin;
  String pesan;
  dynamic result;

  void initState() {
    print(widget.data);
    super.initState();
  }

  loading() {
    showDialog(
        // barrierDismissible: false,
        context: this.context,
        builder: (BuildContext context) {
          return Loading();
        });
  }

  complete() {
    Navigator.pop(context);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Dashboard(
              selected: 0,
            )));
  }

  tambahSaldoDownline() async {
    loading();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = "inbox/inboxbalancecross";
    final params = null;
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());

    var response = await http.post(url, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "token": prefs.getString('token')
    }, body: {
      "destiny": widget.data["nomorTujuan"],
      "nominal": widget.data["nominal"],
      "pin": strPin
    });
    if (response.statusCode == 200) {
      res = json.decode(response.body);
      if (res['rc'] == '01' || res['rc'] == '02') {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(res['pesan']),
        ));
        Navigator.pop(context);
      } else {
        print(res);
        Navigator.pop(context);
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('TRANSFER SALDO BERHASIL'),
                content: Text(res['pesan']),
              );
            });
        Timer(Duration(seconds: 3), complete);
      }
    } else {
      print(response.body);
    }
  }

  tukarKomisi() async {
    loading();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _baseUrl = DotEnv.env['BASE_URL'];
    final _path = "inbox/ec";
    final _params = null; // {"key":"value"}
    final _uri = Uri.http(_baseUrl, _path, _params);
    debugPrint(
        _uri.toString()); // untuk ngecek url nya udah pas sesuai tujuan ato blm

    var response = await http.post(_uri, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "token": prefs.getString('token')
    }, body: {
      "nominal": widget.data['nominal'],
      "pin": strPin
    });

    if (response.statusCode == 200) {
      Navigator.pop(context);
      res = json.decode(response.body);
      pesan = res['pesan'];
      if (res['rc'] == 20) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Info"),
                content: Text(pesan),
              );
            });
        Timer(Duration(seconds: 3), complete);
      } else {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Info"),
                content: Text(pesan),
                actions: <Widget>[
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('tutup'))
                ],
              );
            });
      }
    } else {
      print(response.body);
    }
  }

  _response(String pesan) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Information'),
            content: Container(
              height: 100,
              child: Text(pesan),
            ),
          );
        });
  }

  bayar() async {
    // print('sudah di hit');
    loading();
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = 'inbox/inboxtrx';
    final params = null; // {key:value}
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());

    var response = await http.post(url, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      "token": storage.getItem('token')
    }, body: {
      "harga_produk": "${widget.data['harga_produk']}",
      "code_product": "${widget.data['code_product']}",
      "destiny": "${widget.data['destiny']}"
    });

    if (response.statusCode == 200) {
      result = json.decode(response.body);
      print('ini result seluruh nya');
      print(result);
      pesan = result[0]['pesan'];
      int kodeTransaksi = result[0]['kode_transaksi'];
      print(pesan);
      if (pesan.contains('RC:00') == true) {
        print('status ini setelah transaksi berhasil');
        print(kodeTransaksi);
        dynamic result = await findOneTransaksi(kodeTransaksi);
        Navigator.pop(context);
        Navigator.popAndPushNamed(context, detailTransaksi, arguments: result);
      } else {
        Navigator.pop(context);
        _response(pesan);
        Timer(Duration(seconds: 3), complete);
      }
    } else if (response.statusCode == 400) {
      result = json.decode(response.body);
      print('ini result seluruh nya');
      print(result);
      res = await findOneTransaksi(result['kode']);
      Navigator.pop(context);
      Navigator.popAndPushNamed(context, detailTransaksi, arguments: res);
    } else if (response.statusCode == 401) {
      result = json.decode(response.body);
      Navigator.pop(context);
      _response(result['pesan']);
      Timer(Duration(seconds: 3), complete);
    } else {
      Navigator.pop(context);
      print(response.body);
      Timer(Duration(seconds: 3), complete);
    }
  }

  findOneTransaksi(int kodeTransaksi) async {
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = 'reseller/findOneTransaksi';
    final params = {"kode": "$kodeTransaksi"};
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());
    var response = await http.get(url, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      "token": storage.getItem('token')
    });
    if (response.statusCode == 200) {
      dynamic res = json.decode(response.body);
      print(res['status']);
      return res;
    }
  }

  bayarListrikToken() async {
    // print('ini bayar listrik token');
    loading();
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = 'inbox/inboxpay';
    final params = null; // {key:value}
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());

    var response = await http.post(url, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      "token": storage.getItem('token')
    }, body: {
      // "harga_produk": "${widget.data['harga_produk']}",
      "code_product": "${widget.data['code_product']}",
      "destiny": "${widget.data['destiny']}",
      "pin": strPin
    });

    if (response.statusCode == 200) {
      res = json.decode(response.body);
      print(res);
      int kodeTransaksi = res['kode_transaksi'];
      print(kodeTransaksi);
      result = await findOneTransaksi(kodeTransaksi);
      print('ini hasil pencarian Find One Transaksi');
      print(result);
      Navigator.pop(context);
      Navigator.popAndPushNamed(context, detailTransaksi, arguments: result);
    } else {
      Navigator.pop(context);
      res = json.decode(response.body);
      pesan = res['pesan'];
      _response(pesan);
      Timer(Duration(seconds: 3), complete);
    }
  }

  bayarTagihan() async {
    print('ini fungsi bayar tagihan');
    print(widget.data);
    loading();
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = 'inbox/inboxpay';
    final params = null; // {key:value}
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());

    var response = await http.post(url, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      "token": storage.getItem('token')
    }, body: {
      // "harga_produk": "${widget.data['harga_produk']}",
      "code_product": "${widget.data['code_product']}",
      "destiny": "${widget.data['destiny']}",
      "pin": strPin,
      "totalTagihan": widget.data['totalTagihan']
    });

    if (response.statusCode == 200) {
      res = json.decode(response.body);
      print(res);
      int kodeTransaksi = res['kode_transaksi'];
      print(kodeTransaksi);
      result = await findOneTransaksi(kodeTransaksi);
      print('ini hasil pencarian Find One Transaksi');
      print(result);
      Navigator.pop(context);
      Navigator.popAndPushNamed(context, detailTransaksi, arguments: result);
    } else {
      Navigator.pop(context);
      res = json.decode(response.body);
      pesan = res['pesan'];
      _response(pesan);
      Timer(Duration(seconds: 3), complete);
    }
  }

  withdraw() async {
    print(widget.data);
    loading();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = 'inbox/inboxtrxid';
    // 'linkqu/payTransferBank/${widget.data['bankcode']}/${widget.data['accountnumber']}/${widget.data['amount']}/${widget.data['partner_reff']}/${widget.data['inquiry_reff'].toString()}/${widget.data['remark']}';
    final params = null; // {key:value}
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());

    var response = await http.post(url, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      "token": prefs.getString('token')
    }, body: {
      "code_product": widget.data['bankcode'],
      "destiny": widget.data['accountnumber'],
      "pin": strPin,
      "qty": widget.data['amount'].toString(),
      "partner_reff": widget.data['partner_reff'],
      "inquiry_reff": widget.data['inquiry_reff'].toString(),
      "remark": "Funmobile"
    });

    if (response.statusCode == 200) {
      print('status 200');
      res = json.decode(response.body);
      print(res);
      int kodeTransaksi = res['kode_transaksi'];
      print(kodeTransaksi);
      result = await findOneTransaksi(kodeTransaksi);
      print('ini hasil pencarian Find One Transaksi');
      print(result);
      Navigator.pop(context);
      Navigator.popAndPushNamed(context, detailTransaksi, arguments: result);
    } else {
      print('status 400');
      print(response.body);
      Navigator.pop(context);
      res = json.decode(response.body);
      pesan = res['pesan'];
      print(pesan);
      _response(pesan);
      Timer(Duration(seconds: 3), complete);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Konfirmasi PIN'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Image.asset("image/funmo/icon/enterPin.png"),
                Text("Masukkan PIN Anda"),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 50),
                    child: PinCodeTextField(
                      backgroundColor: Colors.transparent,
                      textStyle: TextStyle(color: Warna.warna(biru)),
                      appContext: context,
                      keyboardType: TextInputType.number,
                      length: 6,
                      obscureText: true,
                      // obscuringCharacter: '*',
                      cursorColor: Warna.warna(biru),
                      pinTheme: PinTheme(
                        fieldHeight: 40,
                        fieldWidth: 30,
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(10),
                        activeColor: Warna.warna(kuning),
                        selectedColor: Warna.warna(biru),
                      ),
                      validator: (variablenyabebas) {
                        if (variablenyabebas.length < 6) {
                          return "Must 6 digit";
                        } else {
                          return null;
                        }
                      },
                      onSubmitted: (v) {
                        strPin = v;
                        print(strPin);
                      },
                      onChanged: (v) {
                        strPin = v;
                        print(strPin);
                      },
                      onCompleted: (strPin) {
                        switch (widget.data['kode']) {
                          case 'KirimSaldo':
                            tambahSaldoDownline();
                            break;
                          case 'TukarKomisi':
                            tukarKomisi();
                            break;
                          case 'transaksiProduk':
                            bayar();
                            break;
                          case 'listrikToken':
                            bayarListrikToken();
                            break;
                          case 'bayarTagihan':
                            bayarTagihan();
                            break;
                          case 'withdraw':
                            withdraw();
                            break;
                          default:
                        }
                        // widget.data["kode"] == "KirimSaldo"
                        //     ?
                        //     : print("Kode tidak ditemukan");
                      },
                    )),
                // ElevatedButton(
                //     onPressed: () {
                //       findOneTransaksi(6591);
                //     },
                //     child: Text('findone'))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
