// import 'package:flutter/material.dart';

// class WithdrawSaldo extends StatefulWidget {
//   const WithdrawSaldo({Key key, this.dari}) : super(key: key);
//   final String dari;
//   @override
//   _WithdrawSaldoState createState() => _WithdrawSaldoState();
// }

// class _WithdrawSaldoState extends State<WithdrawSaldo> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: TextFormField(
//           decoration: InputDecoration(
//         labelText: 'Nyoba',
//         border: OutlineInputBorder(),
//       )),
//     );
//   }
// }

import 'package:android/menuutama/kirimSaldo.dart';
import 'package:android/menuutama/konfirmasiPin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../component.dart';
import '../dashboard.dart';
import '../listWarna.dart';
import './daftarBank.dart';

class WithdrawSaldo extends StatefulWidget {
  WithdrawSaldo({this.from});
  final String from;
  @override
  _WithdrawSaldoState createState() => _WithdrawSaldoState();
}

class _WithdrawSaldoState extends State<WithdrawSaldo> {
  TextEditingController bankTujuan = new TextEditingController();
  TextEditingController noRekTujuan = new TextEditingController();
  TextEditingController nominal = new TextEditingController();

  final _formWithdrawSaldo = new GlobalKey<FormState>();
  List<dynamic> daftarBank;
  dynamic dataInq;
  LocalStorage storage = new LocalStorage('application_app');

  loading() {
    showDialog(
        // barrierDismissible: false,
        context: this.context,
        builder: (BuildContext context) {
          return Loading();
        });
  }

  getDaftarBank() async {
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = "linkqu/getDataBank";
    final params = null; // {key:value}
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());

    var response = await http.get(url);
    if (response.statusCode == 200) {
      daftarBank = json.decode(response.body);
      print(daftarBank);
      storage.setItem('daftarBank', daftarBank);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DaftarBank(from: widget.from)));
    } else {
      print('gagal');
    }
  }

  changeFormat() {
    int panjang = nominal.text.length;
    String clearStr;
    String edit;
    var regex = new RegExp(r'[^0-9]'); // hapus semua kecuali 0-9
    edit = nominal.text.replaceAll(regex, '');
    clearStr = edit.replaceFirst(
        RegExp(r'^0+'), ""); // menghilangkan semua angka 0 yang ada di depan
    print(clearStr);
    if (panjang >= 4) {
      var split = clearStr.split(',');
      var sisa = split[0].length % 3;
      var rupiah = split[0].substring(0, sisa);
      var cekRibuan = split[0].substring(sisa).split('');
      // print(cekRibuan);
      String group = ''; // untuk menampung "000"
      List ribuan = []; // untuk menampung ["000", "000", ..dst]
      String fix = ''; // untuk menampung hasil akhir "1.000.000"
      for (var i = 0; i <= cekRibuan.length; i++) {
        // print(group.length);
        if (group.length == 3) {
          ribuan.add(group);
          group = '';
          if (i < cekRibuan.length) {
            // untuk input angka terakhir
            group = '$group${cekRibuan[i]}';
          }
        } else {
          group = '$group${cekRibuan[i]}';
          // print(group);
        }
      }

      sisa == 0 ? fix = ribuan.join(".") : fix = '$rupiah.${ribuan.join(".")}';
      final val = TextSelection.collapsed(
          offset: fix.length); // to set cursor position at the end of the value

      setState(() {
        nominal.text = fix;
        nominal.selection =
            val; // to set cursor position at the end of the value
      });

      print(fix);
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

  cek() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var regex = new RegExp(r'[^0-9]'); // hapus semua kecuali 0-9
    String clearStr = nominal.text.replaceAll(regex, '');
    // String kodeBank = storage
    //     .getItem("kodeBank")
    //     .substring(1, storage.getItem("kodeBank").length);
    // String fixKodeBank = 'C$kodeBank';
    loading();
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = 'linkqu/inqTransfer';//'linkqu/inqTransferBank'; //
    final params = null; // {key:value}
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());

    var response = await http.post(url, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      "token": prefs.getString('token')
    }, body: {
      // "harga_produk": "${widget.data['harga_produk']}",
      "code": storage.getItem('kodeBank'),
      "norek": noRekTujuan.text,
      "nominal": clearStr,
    });

    if (response.statusCode == 200) {
      Navigator.pop(context);
      dataInq = json.decode(response.body);
      print(dataInq);
      int admin = 6500;
      int nominal = dataInq['amount']; // + dataInq['additionalfee'];
      // int cashback = 3000;
      int totalTransfer = admin + nominal;
      showModalBottomSheet<void>(
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          elevation: 10,
          context: context,
          builder: (BuildContext context) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 2),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Warna.warna(biru),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child:
                        NotificationListener<OverscrollIndicatorNotification>(
                      onNotification: (overscroll) {
                        overscroll.disallowGlow();
                      },
                      child: ListView(children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Informasi Transfer',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Warna.warna(kuning),
                                    fontSize: 15)),
                            Icon(Icons.info_outline, color: Warna.warna(kuning))
                          ],
                        ),
                        Divider(
                          thickness: 3,
                          color: Warna.warna(kuning),
                        ),
                        InfoTransfer(
                            judul: "Bank Tujuan", value: dataInq['bankname']),
                        SizedBox(height: 10),
                        InfoTransfer(
                            judul: "Rekening Tujuan",
                            value: dataInq['accountnumber']),
                        SizedBox(height: 10),
                        InfoTransfer(
                            judul: "Nama Tujuan",
                            value: dataInq['accountname']),
                        SizedBox(height: 10),
                        InfoTransferNumber(
                            judul: "Nominal", value: dataInq['amount']),
                        SizedBox(height: 10),
                        InfoTransferNumber(judul: "Admin", value: admin),
                        // SizedBox(height: 10),
                        // InfoTransferNumber(judul: "Cash Back", value: cashback),
                        SizedBox(height: 10),
                        InfoTransferNumber(
                            judul: "Total Biaya", value: totalTransfer),
                      ]),
                    ),
                  )),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => KonfirmasiPin(data: {
                            "kode": "withdraw",
                            "bankcode": "B" + dataInq['bankcode'],
                            "accountnumber": dataInq['accountnumber'],
                            "amount": dataInq['amount'],
                            "partner_reff": dataInq['partner_reff'],
                            "inquiry_reff": dataInq['inquiry_reff'],
                            "remark": "Funmobile"
                          })));
                },
                label: Text(
                  'Transfer',
                  style: TextStyle(color: Warna.warna(biru)),
                ),
                icon: Icon(Icons.send, color: Warna.warna(biru)),
                backgroundColor: Warna.warna(kuning),
              ),
            );
          });
    } else if (response.statusCode == 400) {
      Navigator.pop(context);
      dataInq = json.decode(response.body);
      _response(dataInq['response_desc']);
    } else {
      Navigator.pop(context);
      dataInq = json.decode(response.body);
      print(dataInq);
    }
  }

  @override
  Widget build(BuildContext context) {
    bankTujuan = TextEditingController(text: storage.getItem('namaBank'));
    return new Scaffold(
      // resizeToAvoidBottomInset: true, // biar klo bawah naik ga mentok
      appBar: widget.from != 'kirim'
          ? AppBar(
              elevation: 0,
              centerTitle: true,
              automaticallyImplyLeading: false,
              // backgroundColor: Colors.blue,
              title: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Dashboard()));
                },
                child: Text(
                  'Whitdraw Saldo',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ),
            )
          : null,
      body: ListView(
        children: [
          Form(
            key: _formWithdrawSaldo,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  TextFormField(
                    onTap: () {
                      getDaftarBank();
                    },
                    readOnly: true,
                    controller: bankTujuan,
                    validator: (bankTujuan) {
                      if (bankTujuan.isEmpty) {
                        return 'Bank Harus Diisi';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'Bank Tujuan', border: OutlineInputBorder()),
                  ),
                  Padding(padding: EdgeInsets.all(8)),
                  TextFormField(
                    controller: noRekTujuan,
                    validator: (noRekTujuan) {
                      if (noRekTujuan.isEmpty) {
                        return 'Nomor Rekening Harus Diisi';
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'Nomor Rekening Tujuan',
                        border: OutlineInputBorder()),
                  ),
                  Padding(padding: EdgeInsets.all(8)),
                  TextFormField(
                    onChanged: (nominal) {
                      changeFormat();
                    },
                    controller: nominal,
                    validator: (nominal) {
                      var regex =
                          new RegExp(r'[^0-9]'); // hapus semua kecuali 0-9
                      String clearStr = nominal.replaceAll(regex, '');
                      if (nominal.isEmpty) {
                        return 'Nominal Harus Diisi';
                      } else if (int.parse(clearStr) < 50000) {
                        return 'Nominal Kurang';
                      } else {
                        return null;
                      }
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9]')), //ini juga bisa
                      // FilteringTextInputFormatter.digitsOnly
                    ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        counterText: 'Minimal Withdraw Rp. 50.000',
                        labelText: 'Nominal',
                        border: OutlineInputBorder(),
                        prefixText: 'Rp. '),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
                onPressed: () {
                  if (_formWithdrawSaldo.currentState.validate()) {
                    cek();
                  }

                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => KonfirmasiPin(data: {
                  //           "kode": "withdraw",
                  //           "bank": fixKodeBank,
                  //           "noRek": noRekTujuan.text,
                  //           "nominal": clearStr
                  //         })));
                },
                child: Text('Withdraw')),
          )
        ],
      ),
    );
  }
}

class InfoTransferNumber extends StatelessWidget {
  InfoTransferNumber({this.judul, this.value});
  final String judul;
  final int value;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(judul, style: TextStyle(color: Warna.warna(kuning))),
        Text(
            NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                .format(value),
            style: TextStyle(
                color: Warna.warna(kuning), fontWeight: FontWeight.bold))
      ],
    );
  }
}
