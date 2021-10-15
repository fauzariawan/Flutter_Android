// import 'package:android/menuutama/subPaketData/kuota.dart';
// import 'package:android/menuutama/subTelpDanSms/subTelpDanSms.dart';
import 'package:android/phoneBook.dart';
import 'package:android/routerName.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../component.dart';
import '../listWarna.dart';
import './konfirmasiPembelian.dart';
// import 'operatorPromo.dart';

class ProdukPromo extends StatefulWidget {
  ProdukPromo({this.data, this.dataRouting, this.noTelp, this.logo});
  final dynamic data;
  final dynamic dataRouting;
  final dynamic noTelp; // ini dari phonebook
  final String logo;
  @override
  _ProdukPromoState createState() => _ProdukPromoState();
}

class _ProdukPromoState extends State<ProdukPromo> {
  List<dynamic> dataProdukPromo = [];
  List<dynamic> phonebook = [];
  dynamic selectedProduk;
  TextEditingController noTujuan = TextEditingController();
  LocalStorage storage = new LocalStorage('localstorage_app');
  dynamic backupDataOperatorPromo;
  dynamic dataPelanggan;
  dynamic dataUser;
  dynamic favorit;
  int selectedIndex;
  bool buttonBayar = false;
  bool isLegal = true;
  String selectedNumber = '';
  bool isLoading = false;
  final _formPromo = GlobalKey<FormState>();

  void initState() {
    super.initState();
    print(widget.data);
    getProdukPromo();
    if (widget.noTelp == null) {
      print("blm ambil no HP dari PhoneBook");
    } else {
      print("Sudah ada NO dari PhoneBook");
      print(widget.noTelp);
      var regExp = new RegExp(r'[^0-9]');
      String clrStr = widget.noTelp != null
          ? widget.noTelp['noTelp'].replaceAll(regExp, '')
          : "";
      if (clrStr.contains("62")) {
        clrStr = "0${clrStr.substring(2, clrStr.length)}";
      }
      setState(() {
        selectedNumber = clrStr;
        noTujuan = TextEditingController(text: selectedNumber);
        print(selectedNumber);
      });
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

  getProdukPromo() async {
    // print(widget.data);
    setState(() {
      isLoading = true;
    });
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = 'olahdata/getProduk';
    final params = {"kodeOperator": "${widget.data['kode']}"};
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());

    var response = await http.get(url, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "token": storage.getItem('token')
    });
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
        dataProdukPromo = json.decode(response.body);
      });
      print(dataProdukPromo[0]['kode']);
    } else {
      setState(() {
        isLegal = false;
      });
    }
  }

  getContactList() async {
    phonebook = await ContactList.pickContact();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PhoneBook(
            data: phonebook, routing: produkPromo, dataRouting: widget.data)));
    // phonebook = await ContactList.pickContact();
    //   Navigator.of(context).push(MaterialPageRoute(
    //     builder: (context) => PhoneBook(data: phonebook, routing: kirimSaldo)));
  }

  getFavorit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dataUser = json.decode(prefs.getString('dataUser'));
    favorit = dataUser['reseller_save'];
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PhoneBook(
            data: favorit, routing: produkPromo, dataRouting: widget.data)));
  }

  cekDataPelanggan() async {
    loading();
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = 'reseller/cekPlnPrePaid';
    final params = null;
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());

    var response = await http.post(url, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "token": storage.getItem('token')
    }, body: {
      "noTujuan": noTujuan.text
    });
    if (response.statusCode == 200) {
      Navigator.pop(context);
      dataPelanggan = json.decode(response.body);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => KonfirmasiPembelian(
                nomorTujuan: noTujuan.text,
                selectedItem: selectedProduk,
                dataPelanggan: dataPelanggan,
              )));
    } else {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text('Warning !!!'), content: Text(response.body));
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.data['nama']),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              PangkatPendek(
                height: 80,
              ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Form(
                  key: _formPromo,
                  child: TextFormField(
                    controller: noTujuan,
                    validator: (noTujuan) {
                      if (noTujuan.isEmpty) {
                        return 'Nomor Tujuan Harus Diisi';
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: widget.data['kode'] == "PP"
                            ? 'Nomor Meteran'
                            : 'Nomor Tujuan',
                        border: OutlineInputBorder(),
                        prefixIcon: GestureDetector(
                            onTap: () {
                              getFavorit();
                            },
                            child: Icon(Icons.autorenew_rounded)),
                        suffixIcon: GestureDetector(
                            onTap: () {
                              getContactList();
                            },
                            child: Icon(Icons.contact_mail_rounded))),
                  ),
                ),
              ),
              isLoading
                  ? Expanded(
                      child: Container(
                          height: MediaQuery.of(context).size.height / 2,
                          child: Loading()),
                    )
                  : isLegal
                      ? dataProdukPromo.length == 0
                          ? Container()
                          : Expanded(
                              child: AnimationLimiter(
                                child: NotificationListener<
                                    OverscrollIndicatorNotification>(
                                  // ignore: missing_return
                                  onNotification: (overscroll) {
                                    overscroll.disallowGlow();
                                  },
                                  child: ListView.builder(
                                      // physics:
                                      //     NeverScrollableScrollPhysics(), // kalau mau scroll dibawah text field ini di coment
                                      shrinkWrap: true,
                                      itemCount: dataProdukPromo.length,
                                      itemBuilder: (context, i) {
                                        return AnimationConfiguration
                                            .staggeredList(
                                                position: i,
                                                duration: const Duration(
                                                    milliseconds: 1000),
                                                child: SlideAnimation(
                                                  verticalOffset: 100.0,
                                                  child: FadeInAnimation(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          selectedIndex = i;
                                                          buttonBayar = true;
                                                          selectedProduk =
                                                              dataProdukPromo[
                                                                  i];
                                                        });
                                                      },
                                                      child: Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 10,
                                                                  right: 10,
                                                                  bottom: 10,
                                                                  top: i == 0
                                                                      ? 10
                                                                      : 0),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              color: selectedIndex ==
                                                                      i
                                                                  ? Warna.warna(biru)
                                                                  : Colors.white,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors
                                                                        .grey,
                                                                    offset:
                                                                        Offset(
                                                                            0,
                                                                            5),
                                                                    blurRadius:
                                                                        5)
                                                              ]),

                                                          // elevation: 5,
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: <Widget>[
                                                              // Image.asset('image/indosat.png'),
                                                              // widget.logo == null
                                                              //     ?
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  dataProdukPromo[i]
                                                                              [
                                                                              'catatan'] !=
                                                                          null
                                                                      ? Format.iconNetwork(
                                                                          dataProdukPromo[i]
                                                                              [
                                                                              'catatan'])
                                                                      : widget.data['apk_ikon'] !=
                                                                              null
                                                                          ? Format.iconNetwork(
                                                                              widget.data['apk_ikon'])
                                                                          : Container(),
                                                                  // // : Container(
                                                                  // //     width: 60,
                                                                  // //     height: 60,
                                                                  // //     // child: ClipRRect(
                                                                  // //     //   child: Image.network(widget.logo,
                                                                  // //     //     width: 40,
                                                                  // //     //   ),
                                                                  // //     // ),
                                                                  // //     decoration: BoxDecoration(
                                                                  // //         borderRadius:
                                                                  // //             BorderRadius.circular(
                                                                  // //                 10.0),
                                                                  // //         image: DecorationImage(
                                                                  // //             image:
                                                                  // //                 NetworkImage(widget.logo),
                                                                  // //             fit: BoxFit.cover)),
                                                                  // //   ),
                                                                  Container(
                                                                    // height: MediaQuery.of(context).size.height/15,
                                                                    // width: 200,
                                                                    // color: Colors.yellow,
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: <
                                                                          Widget>[
                                                                        Container(
                                                                            padding:
                                                                                EdgeInsets.all(5),
                                                                            decoration: BoxDecoration(color: Warna.warna(biru), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
                                                                            child: Text(dataProdukPromo[i]['kode'], style: TextStyle(color: Colors.white, fontSize: 12))),
                                                                        SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              MediaQuery.of(context).size.width / 2,
                                                                          child:
                                                                              Text(
                                                                            dataProdukPromo[i]['nama'],
                                                                            style:
                                                                                TextStyle(fontSize: 12, color: selectedIndex == i ? Colors.white : Colors.black),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Container(
                                                                // color: Colors
                                                                //     .amber[200],
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            5),
                                                                // padding: EdgeInsets
                                                                //     .only(
                                                                //         right:
                                                                //             10),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      NumberFormat.currency(
                                                                              locale: 'id',
                                                                              decimalDigits: 0,
                                                                              symbol: 'Rp ')
                                                                          .format(dataProdukPromo[i]['harga_jual']),
                                                                      style: TextStyle(
                                                                          color: selectedIndex == i
                                                                              ? Colors.white
                                                                              : Colors.black),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Text(
                                                                        "${dataProdukPromo[i]['poin'] ?? '0'} Poin",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                10,
                                                                            color: selectedIndex == i
                                                                                ? Colors.white
                                                                                : Colors.black)),
                                                                    SizedBox(
                                                                        height:
                                                                            5),
                                                                    dataProdukPromo[i]['gangguan'] ==
                                                                            0
                                                                        ? Info(
                                                                            text:
                                                                                "Normal",
                                                                            color: Colors
                                                                                .green)
                                                                        : Info(
                                                                            text:
                                                                                "Gangguan",
                                                                            color:
                                                                                Colors.red)
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          )),
                                                    ),
                                                  ),
                                                ));
                                      }),
                                ),
                              ),
                            )
                      : Text('Kamu Customer Ilegal')
            ],
          ),
          buttonBayar
              ? Positioned(
                  bottom: 5.0,
                  right: 5.0,
                  child: Container(
                    child: ElevatedButton(
                        onPressed: () {
                          if (widget.data['kode'] == 'PP') {
                            if (_formPromo.currentState.validate()) {
                              cekDataPelanggan();
                            }
                          } else {
                            if (_formPromo.currentState.validate()) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => KonfirmasiPembelian(
                                        nomorTujuan: noTujuan.text,
                                        selectedItem: selectedProduk,
                                      )));
                            }
                          }
                        },
                        child: Text('Beli')),
                  ))
              : Container()
        ],
      ),
    );
  }
}

class Info extends StatelessWidget {
  Info({this.text, this.color});
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(2),
        width: 60,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10))),
        child: Text(
          text,
          style: TextStyle(fontSize: 10, color: Colors.white),
          textAlign: TextAlign.center,
        ));
  }
}
