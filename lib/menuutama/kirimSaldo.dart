// import 'dart:async';
import 'dart:convert';

// import 'package:contacts_service/contacts_service.dart';
import "package:flutter/material.dart";
// import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:localstorage/localstorage.dart';
// import 'package:http/http.dart' as http;

import '../component.dart';
// import '../dashboard.dart';
// import '../main.dart';
// import '../phoneBook.dart';
import '../dashboard.dart';
import '../phoneBook.dart';
import '../routerName.dart';
import 'konfirmasiPin.dart';
import '../listWarna.dart';

// ini perlu

class KirimSaldo extends StatefulWidget {
  KirimSaldo({this.data, this.noTelp, this.from});
  final dynamic data;
  final dynamic noTelp;
  final String from;
  @override
  _KirimSaldoState createState() => _KirimSaldoState();
}

class _KirimSaldoState extends State<KirimSaldo> {
  TextEditingController nomorTujuan = new TextEditingController();
  TextEditingController nominalMarkup = new TextEditingController();
  LocalStorage storage = new LocalStorage('localstorage_app');
  dynamic res;
  String strNoTelp;
  String strPin;
  // List<Contact> _contact;
  List<dynamic> phonebook = [];
  // ignore: unused_field
  // Contact _contact;
  final _formKirimSaldo = GlobalKey<FormState>();

  void initState() {
    super.initState();
    print(widget.data);
  }

  changeFormat() {
    String fix = FormatUang.formatUang(nominalMarkup);
    final val = TextSelection.collapsed(
        offset: fix.length); // to set cursor position at the end of the value
    setState(() {
      nominalMarkup.text = fix;
      nominalMarkup.selection =
          val; // to set cursor position at the end of the value
    });
  }

  Future<void> _pickContact() async {
    try {
      phonebook = await ContactList.pickContact();
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PhoneBook(data: phonebook, routing: kirim)));
    } catch (e) {
      print(e.toString());
    }
  }

  loading() {
    showDialog(
        // barrierDismissible: false,
        context: this.context,
        builder: (BuildContext context) {
          return Loading();
        });
  }

  findReseller(
      /*String destiny,*/
      ) async {
    loading();
    // final baseUrl = DotEnv.env['BASE_URL'];
    // final path = "reseller/getReseller";
    // final params = null;
    // final url = Uri.http(baseUrl, path, params);
    // debugPrint(url.toString());

    // var response = await http.post(url, headers: {
    //   "Content-Type": "application/x-www-form-urlencoded"
    // }, body: {
    //   "noTelp": nomorTujuan.text,
    // });
    var response = await Reseller.getReseller(nomorTujuan.text);

    if (response.statusCode == 200) {
      dynamic data = json.decode(response.body);
      print(data);
      Navigator.pop(context);
      if (data['rc'] == '03') {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(data['pesan']),
        ));
      } else {
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
                            judul: "Nomor Tujuan", value: nomorTujuan.text),
                        SizedBox(height: 10),
                        InfoTransfer(
                            judul: "Kode Reseller",
                            value: data['reseller']['kode']),
                        SizedBox(height: 10),
                        InfoTransfer(
                            judul: "Nama Pengguna",
                            value: data['reseller']['nama']),
                        SizedBox(height: 10),
                        InfoTransfer(
                            judul: "Nominal",
                            value: "Rp. ${nominalMarkup.text}"),
                      ]),
                    )),
                floatingActionButton: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => KonfirmasiPin(data: {
                              "kode": "KirimSaldo",
                              "nomorTujuan": nomorTujuan.text,
                              "nominal": nominalMarkup.text
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
      }
    } else {
      res = json.decode(response.body);
      Navigator.pop(context);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(res['pesan']),
      ));
    }
  }

  // masukkanPin() {
  //   showModalBottomSheet<void>(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Container(
  //           child: Column(
  //             children: <Widget>[
  //               Text('Masukkan PIN Anda',
  //                   style: TextStyle(fontWeight: FontWeight.bold)),
  //               Padding(
  //                   padding: const EdgeInsets.symmetric(
  //                       vertical: 8.0, horizontal: 30),
  //                   child: PinCodeTextField(
  //                     backgroundColor: Colors.white,
  //                     appContext: context,
  //                     keyboardType: TextInputType.number,
  //                     length: 6,
  //                     obscureText: true,
  //                     obscuringCharacter: '*',
  //                     cursorColor: Warna.warna(biru),
  //                     pinTheme: PinTheme(
  //                       fieldHeight: 40,
  //                       fieldWidth: 30,
  //                       shape: PinCodeFieldShape.box,
  //                       borderRadius: BorderRadius.circular(5),
  //                       selectedColor: Warna.warna(biru),
  //                     ),
  //                     validator: (variablenyabebas) {
  //                       if (variablenyabebas.length < 6) {
  //                         return "Must 6 digit";
  //                       } else {
  //                         return null;
  //                       }
  //                     },
  //                     onSubmitted: (v) {
  //                       strPin = v;
  //                       print(strNoTelp);
  //                     },
  //                     onChanged: (v) {
  //                       strPin = v;
  //                       print(strNoTelp);
  //                     },
  //                     onCompleted: (strPin) {
  //                       if (strNoTelp.length < 11) {
  //                         print('nomor anda kurang');
  //                         Navigator.pop(context);
  //                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //                           content: Text('NoTelp Kurang'),
  //                         ));
  //                       } else {
  //                         findReseller();
  //                       }
  //                     },
  //                   ))
  //             ],
  //           ),
  //         );
  //       });
  // }

  Future<bool> _back() {
    return Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Dashboard(
              selected: 0,
            )));
  }

  @override
  Widget build(BuildContext context) {
    var regExp = new RegExp(r'[^0-9]');
    String clrStr =
        widget.data != null ? widget.data['noTelp'].replaceAll(regExp, '') : "";
    if (clrStr.contains("62")) {
      clrStr = "0${clrStr.substring(2, clrStr.length)}";
    }
    nomorTujuan =
        TextEditingController(text: clrStr != '' ? clrStr : nomorTujuan.text);
    return WillPopScope(
      onWillPop: _back,
      child: Scaffold(
        appBar: widget.from != 'kirim' ? AppBar(
          automaticallyImplyLeading: false,
          // flexibleSpace: Container(
          //   // height: 30,
          //   color: Colors.orange,
          //   child: Column(
          //     children: [
          //       Text('1'),
          //       Text('2'),
          //       Text('3'),
          //       Text('4'),
          //     ],
          //   ),
          // ),
          title: Text("Kirim Saldo"),
          centerTitle: true,
        ):null,
        body: ListView(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: Form(
                key: _formKirimSaldo,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: nomorTujuan,
                      keyboardType: TextInputType.number,
                      maxLength: 12,
                      validator: (nomorTujuan) {
                        if (nomorTujuan.isEmpty) {
                          return 'Nomor Tujuan Harus diisi';
                        } else if (nomorTujuan.length < 11) {
                          return 'Nomor Yang Anda Masukkan Kurang';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          labelText: "Nomor Tujuan",
                          labelStyle: TextStyle(color: Warna.warna(biru)),
                          border: OutlineInputBorder(),
                          counterText: "",
                          prefixIcon:
                              Icon(Icons.phone), // untuk icon sebelah kiri
                          suffixIcon: GestureDetector(
                              onTap: () {
                                _pickContact();
                              },
                              child: Icon(Icons.contact_mail))),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        controller: nominalMarkup,
                        keyboardType: TextInputType.number,
                        validator: (nominalMarkup) {
                          if (nominalMarkup.isEmpty) {
                            return 'Nominal Harus diisi';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (nominalMarkup) {
                          changeFormat();
                        },
                        decoration: InputDecoration(
                          prefixText: 'Rp. ',
                          prefixStyle: TextStyle(color: Warna.warna(biru)),
                          labelText: "Nominal",
                          labelStyle: TextStyle(color: Warna.warna(biru)),
                          border: OutlineInputBorder(),
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (_formKirimSaldo.currentState.validate()) {
              findReseller();
            }
          },
          label: Text('Kirim'),
          icon: Icon(Icons.send),
          backgroundColor: Warna.warna(biru),
        ),
      ),
    );
  }
}

class InfoTransfer extends StatelessWidget {
  InfoTransfer({this.judul, this.value});
  final String judul;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(judul, style: TextStyle(color: Warna.warna(kuning))),
        Text(value,
            style: TextStyle(
                color: Warna.warna(kuning), fontWeight: FontWeight.bold))
      ],
    );
  }
}
