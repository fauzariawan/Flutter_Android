import 'package:android/component.dart';
import 'package:android/history/detailAlfamart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // untuk TextInputFormater agar tidak bisa di masukkan special caracter
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'QrImage.dart';
import 'daftarRekening.dart';

class TesPembayaran extends StatefulWidget {
  TesPembayaran({this.data});
  final dynamic data;
  @override
  _TesPembayaranState createState() => _TesPembayaranState();
}

class _TesPembayaranState extends State<TesPembayaran> {
  TextEditingController nominal = TextEditingController();
  List<dynamic> virtualAccount = [];
  dynamic data;
  final LocalStorage storage = LocalStorage('localstorage_app');
  int panjang;
  dynamic dataUser;
  dynamic jawaban;
  bool isLoading = false;
  final _formPembayaran = GlobalKey<FormState>();

  void initState() {
    super.initState();
    print(widget.data['title']);
    if (widget.data['title'] == 'VIRTUAL ACCOUNT') {
      callData();
    }
  }

  callData() async {
    setState(() {
      isLoading = true;
    });
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = 'winpay/paymentChannel';
    final params = null; // {'key':'value'}
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());

    var response = await http.get(url);
    if (response.statusCode == 200) {
      data = json.decode(response.body);
      setState(() {
        isLoading = false;
        virtualAccount = data['data']['products']['virtual account'];
      });
      print(virtualAccount);
    } else {
      print(response.body);
    }
  }

  changeFormat() {
    String fix = FormatUang.formatUang(nominal);
    final val = TextSelection.collapsed(
        offset: fix.length); // to set cursor position at the end of the value
    setState(() {
      nominal.text = fix;
      nominal.selection = val; // to set cursor position at the end of the value
    });
  }

  loading() {
    showDialog(
        barrierDismissible: false,
        context: this.context,
        builder: (BuildContext context) {
          return Loading();
        });
  }

  topUp(dynamic data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loading();
    if (widget.data['title'] == 'BANK') {
      // dataUser = storage.getItem('dataUser');
      var regExp = new RegExp(r'[^0-9]');
      String clrStr = nominal.text.replaceAll(regExp, '');
      final baseUrl = DotEnv.env['BASE_URL'];
      final path = 'inbox/inboxdeposit';
      final params = null; // {'key':'value'}
      final url = Uri.http(baseUrl, path, params);
      debugPrint(url.toString());

      var response = await http.post(url, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "token": prefs.getString('token')
      }, body: {
        "price": clrStr
      });
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        print(result);
        if (result['error'] == null) {
          print(result['rc']);
          if (result['rc'] == '02') {
            Navigator.pop(context);
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Transaksi Sama'),
                    content: Text(result['pesan']),
                  );
                });
          } else {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DaftarRekening(data: result)));
          }
        } else {
          Navigator.pop(context);
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Warning !!!'),
                  content: Text(result['error']),
                );
              });
        }
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('No Response From Server'),
        ));
      }
    } else if (widget.data['title'] == 'E-WALLET') {
      print('METODE PEMBAYARAN ${widget.data['title']}');
    } else if (widget.data['title'] == 'VIRTUAL ACCOUNT') {
      print('METODE PEMBAYARAN ${widget.data['title']}');
      var regExp = new RegExp(r'[^0-9]');
      String clrStr = nominal.text.replaceAll(regExp, '');
      final baseUrl = DotEnv.env['BASE_URL'];
      final path = 'winpay/topup';
      final params = null; // {'key':'value'}
      final url = Uri.http(baseUrl, path, params);
      debugPrint(url.toString());

      var response = await http.post(url, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "token": prefs.getString('token')
      }, body: {
        "paymentChannelUrl": data['payment_url_v2'],
        "unitPrice": clrStr,
        "pembayaranVia": widget.data['title']
      });

      if (response.statusCode == 200) {
        print(response.body);
        jawaban = json.decode(response.body);
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailAlfamart(data: jawaban)));
        // Navigator.pop(context);
        // if (await canLaunch(jawaban['data']['spi_status_url'])) {
        //   await launch(jawaban['data']['spi_status_url']);
        // } else {
        //   print('Could not launch ${jawaban['data']['spi_status_url']}');
        // }
      } else {
        Navigator.pop(context);
        print('GET PAYMENT CODE FAILED');
        print(response.body);
      }
    } else if (widget.data['title'] == 'ALFAMART') {
      print('METODE PEMBAYARAN ${widget.data['title']}');
      var regExp = new RegExp(r'[^0-9]');
      String clrStr = nominal.text.replaceAll(regExp, '');
      final baseUrl = DotEnv.env['BASE_URL'];
      final path = 'winpay/topup';
      final params = null; // {'key':'value'}
      final url = Uri.http(baseUrl, path, params);
      debugPrint(url.toString());

      var response = await http.post(url, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "token": prefs.getString('token')
      }, body: {
        "paymentChannelUrl": widget.data['paymentChannelUrl'],
        "unitPrice": clrStr,
        "pembayaranVia": widget.data['title']
      });

      if (response.statusCode == 200) {
        print(response.body);
        jawaban = json.decode(response.body);
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailAlfamart(data: jawaban)));
        // Navigator.pop(context);
        // showDialog(
        //     barrierDismissible: false,
        //     context: context,
        //     builder: (BuildContext context) {
        //       return AlertDialog(
        //         title: Text('Information'),
        //         content: Container(
        //           child: Text(jawaban['rd']),
        //         ),
        //       );
        //     });
        // if (await canLaunch(jawaban['data']['spi_status_url'])) {
        //   await launch(jawaban['data']['spi_status_url']);
        // } else {
        //   print('Could not launch ${jawaban['data']['spi_status_url']}');
        // }
      } else {
        Navigator.pop(context);
        print('GET PAYMENT CODE FAILED');
        print(response.body);
      }
    } else if (widget.data['title'] == 'INDOMARET') {
      print('METODE PEMBAYARAN ${widget.data['title']}');
    } else if (widget.data['title'] == 'QR CODE') {
      print('METODE PEMBAYARAN ${widget.data['title']}');
      var regExp = new RegExp(r'[^0-9]');
      String clrStr = nominal.text.replaceAll(regExp, '');
      final baseUrl = DotEnv.env['BASE_URL'];
      final path = 'winpay/topupQr';
      final params = null; // {'key':'value'}
      final url = Uri.http(baseUrl, path, params);
      debugPrint(url.toString());

      var response = await http.post(url, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "token": prefs.getString('token')
      }, body: {
        "paymentChannelUrl": widget.data['paymentChannelUrl'],
        "unitPrice": clrStr,
        "pembayaranVia": 'QRIS'
      });

      if (response.statusCode == 200) {
        print(response.body);
        jawaban = json.decode(response.body);
        Navigator.pop(context);
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => QrImage(image: jawaban['data']['image_qr'])));
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailAlfamart(data: jawaban)));
        // if (await canLaunch(jawaban['data']['image_qr'])) {
        //   await launch(jawaban['data']['image_qr']);
        // } else {
        //   print('Could not launch ${jawaban['data']['image_qr']}');
        // }
      } else {
        Navigator.pop(context);
        print('GET PAYMENT CODE FAILED');
        print(response.body);
      }
    } else {
      print('METODE PEMBAYARAN TIDAK TERSEDIA');
    }
  }

  @override
  Widget build(BuildContext context) {
    // nominal = TextEditingController(text: hasil);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.data['title']),
        ),
        body: widget.data['title'] != 'VIRTUAL ACCOUNT'
            ? Container(
                padding: EdgeInsets.all(10.0),
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    ListView(
                      children: [
                        Form(
                          key: _formPembayaran,
                          child: TextFormField(
                            // inputFormatters: [DecimalTextInputFormatter()],
                            keyboardType: TextInputType.number,
                            controller: nominal,
                            onChanged: (nominal) {
                              changeFormat();
                            },
                            validator: (nominal) {
                              var regex = new RegExp(
                                  r'[^0-9]'); // hapus semua kecuali 0-9
                              String clearStr = nominal.replaceAll(regex, '');
                              if (nominal.isEmpty) {
                                return 'Nominal Harus Diisi';
                              } else if (int.parse(clearStr) < 10000) {
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
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Nominal',
                                prefixText: 'Rp. ',
                                counterText: widget.data['title'] == 'BANK'
                                    ? 'Minimal Topup Rp. 50.000'
                                    : 'Minimal Topup Rp. 10.000'),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              if (_formPembayaran.currentState.validate()) {
                                topUp({});
                                // print('boleh topup');
                              }
                            },
                            child: Text('Proses'))
                      ],
                    ),
                    if (widget.data['title'] == 'BANK' &&
                        MediaQuery.of(context).size.height > 500)
                      Positioned(
                          bottom: 10,
                          child: Container(
                            width: MediaQuery.of(context).size.width - 20,
                            child: Column(
                              children: [
                                Text('Note !!!',
                                    style: TextStyle(color: Colors.grey)),
                                Text(
                                  'Deposit via bank hanya buka di jam 01:00 s/d 22:00, bila ingin melakukan deposit 24 jam, silahkan menggunakan topup Virtual Account ',
                                  style: TextStyle(color: Colors.grey),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ))
                  ],
                ))
            : Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Form(
                      key: _formPembayaran,
                      child: TextFormField(
                        // inputFormatters: [DecimalTextInputFormatter()],
                        keyboardType: TextInputType.number,
                        controller: nominal,
                        onChanged: (nominal) {
                          changeFormat();
                        },
                        validator: (nominal) {
                          var regex =
                              new RegExp(r'[^0-9]'); // hapus semua kecuali 0-9
                          String clearStr = nominal.replaceAll(regex, '');
                          if (nominal.isEmpty) {
                            return 'Nominal Harus Diisi';
                          } else if (int.parse(clearStr) < 10000) {
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
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Nominal',
                            prefixText: 'Rp. ',
                            counterText: 'Minimal Topup Rp. 50.000'),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    isLoading
                        ? Loading()
                        : virtualAccount.length == 0
                            ? ElevatedButton(
                                onPressed: () {
                                  if (_formPembayaran.currentState.validate()) {
                                    topUp({});
                                    // print('boleh topup');
                                  }
                                },
                                child: Text('Proses'))
                            : Expanded(
                                child: ListView.builder(
                                    itemCount: virtualAccount.length,
                                    itemBuilder: (context, i) {
                                      return GestureDetector(
                                          onTap: () {
                                            if (_formPembayaran.currentState
                                                .validate()) {
                                              topUp(virtualAccount[i]);
                                            }
                                          },
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: Row(
                                                children: <Widget>[
                                                  Image.network(
                                                    virtualAccount[i]
                                                        ['payment_logo'],
                                                    height: 40,
                                                  ),
                                                  // Text(virtualAccount[i]['payment_name']),
                                                ],
                                              ),
                                            ),
                                          ));
                                    }),
                              )
                  ],
                )));
  }
}

// agar tidak bisa di masukkan special carakter
// class DecimalTextInputFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     final regEx = RegExp(r"^\d*\#?\d*");
//     String newString = regEx.stringMatch(newValue.text) ?? "";
//     return newString == newValue.text ? newValue : oldValue;
//   }
// }
