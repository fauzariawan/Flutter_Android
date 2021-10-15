import 'dart:async';

import 'package:android/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../component.dart';
import '../listWarna.dart';
import '../register.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/gestures.dart';

class Downline extends StatefulWidget {
  @override
  _DownlineState createState() => _DownlineState();
}

class _DownlineState extends State<Downline> {
  LocalStorage storage = new LocalStorage('localstorage_app');
  List<dynamic> daftarDownline = [];
  List<dynamic> daftarSubDownline;
  dynamic dataUser;
  List<int> jumlahSubDownline = [];
  bool isLoading = false;
  TextEditingController nominalMarkup = new TextEditingController();
  TextEditingController pinReseller = new TextEditingController();
  TextEditingController search = new TextEditingController();
  dynamic res;
  bool isSearch = false;
  final formKey = GlobalKey<FormState>();
  List<dynamic> allFinance = [];
  List<dynamic> cadangan;
  List<dynamic> datamentah;
  // bool searchBy;

  // StreamController<ErrorAnimationType> errorController;

  void initState() {
    super.initState();
    callData();
    // errorController = StreamController<ErrorAnimationType>();
  }

  void dispose() {
    // print("dispose");
    // This is the line that breaks when called inside setState() of onPressed() method
    pinReseller.dispose();
    super.dispose();
  }

  warna(int i) {
    Color putih = Colors.white;
    Color hitam = Colors.black;
    if (i % 2 == 0) {
      return putih;
    } else {
      return hitam;
    }
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

  loading() {
    showDialog(
        // barrierDismissible: false,
        context: this.context,
        builder: (BuildContext context) {
          return Loading();
        });
  }

  callData() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var result = prefs.getString('dataUser');
    dataUser = json.decode(result);
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = 'reseller/downline/${dataUser['kode']}';
    final params = null;
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());

    var response = await http.get(url);
    if (response.statusCode == 200) {
      datamentah = json.decode(response.body);
      // datamentah
      //     .map((e) => e['nama'] = e['nama'].substring(4, e['nama'].length))
      //     .toList();
      setState(() {
        isLoading = false;
        daftarDownline = datamentah;
        cadangan = datamentah;
      });
      // setState(() {
      //   daftarDownline = json.decode(response.body);
      //   print(daftarDownline[0]);
      // });
      // // for (var i = 0; i < daftarDownline.length; i++) {
      // //   subDownline(daftarDownline[i]['kode']);
      // // }
      // setState(() {
      //   isLoading = false;
      // });
    } else {
      print(response.statusCode);
      print(response.body);
    }
  }

  // subDownline(String kodeReseller) async {
  //   final baseUrl = DotEnv.env['BASE_URL'];
  //   final path = 'reseller/downline/$kodeReseller';
  //   final params = null;
  //   final url = Uri.http(baseUrl, path, params);
  //   debugPrint(url.toString());

  //   var response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     daftarSubDownline = json.decode(response.body);
  //     setState(() {
  //       jumlahSubDownline.add(daftarSubDownline.length);
  //       print(jumlahSubDownline);
  //     });
  //   } else {
  //     print(response.statusCode);
  //     print(response.body);
  //   }
  // }

  editMarkup(String kode) async {
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = 'reseller/editMarkup';
    final params = null;
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());

    var response = await http.post(url, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "token": storage.getItem('token')
    }, body: {
      "kode_reseller": kode,
      "markup": nominalMarkup.text
    });

    if (response.statusCode == 200) {
      dynamic res = json.decode(response.body);
      Navigator.pop(context);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(res['pesan']),
            );
          });
      Future.delayed(
          Duration(milliseconds: 3000),
          () => {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Downline()))
              });
    } else {
      print(response.body);
    }
  }

  complete() {
    Navigator.pop(context);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Downline()));
  }

  tambahSaldoDownline(String destiny, String pin) async {
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = "inbox/inboxbalancecross";
    final params = null;
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());

    var response = await http.post(url, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "token": storage.getItem('token')
    }, body: {
      "destiny": destiny,
      "nominal": nominalMarkup.text,
      "pin": pin
    });
    if (response.statusCode == 200) {
      res = json.decode(response.body);
      if (res['rc'] == '01' || res['rc'] == '02') {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(res['pesan']),
        ));
      } else {
        print(res);
        Navigator.pop(context);
        showDialog(
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

  findReseller(String destiny, String pin) async {
    print(destiny);
    loading();
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = "reseller/getReseller";
    final params = null;
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());

    var response = await http.post(url, headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "noTelp": destiny,
    });

    if (response.statusCode == 200) {
      dynamic data = json.decode(response.body);
      print(data);
      if (data['rc'] == '03') {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(data['pesan']),
        ));
      } else {
        tambahSaldoDownline(destiny, pin);
      }
    }
  }

  changeValue() {
    if (isSearch == false) {
      setState(() {
        isSearch = true;
      });
    } else {
      setState(() {
        isSearch = false;
      });
    }
  }

  int id = 1;

  @override
  Widget build(BuildContext context) {
    // final menuItems = [
    //   Text(
    //     'Edit MarkUp',
    //     style: TextStyle(fontWeight: FontWeight.bold),
    //   ),
    //   Text('Tambah Saldo', style: TextStyle(fontWeight: FontWeight.bold)),
    // ];

    // final menuBar = MenuBar(
    //     orientation: MenuOrientation
    //         .vertical, // untuk susunan menunya kebawa atau ke samping
    //     maxThickness: 150, // untuk lebar containernya
    //     itemPadding: EdgeInsets.all(10),
    //     // borderRadius: const BorderRadius.all(Radius.circular(0)),
    //     // borderStyle: MenuBorderStyle.pill,
    //     menuItems: menuItems);

    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Dashboard(
              selected: 3,
            ),
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Daftar Downline'),
          actions: [
            if (isSearch == true)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Row(
                  children: [
                    Theme(
                      data:
                          ThemeData(unselectedWidgetColor: Warna.warna(kuning)),
                      child: Radio(
                        activeColor: Warna.warna(kuning),
                        value: 1,
                        groupValue: id,
                        onChanged: (val) {
                          setState(() {
                            id = val;
                          });
                        },
                      ),
                    ),
                    Text(
                      'Nama',
                      style: new TextStyle(fontSize: 17.0),
                    ),
                    Theme(
                      data: ThemeData(
                          unselectedWidgetColor: Warna.warna(
                              kuning)), // Changing radio button border color when unselected warping with Theme
                      child: Radio(
                        activeColor: Warna.warna(kuning),
                        value: 2,
                        groupValue: id,
                        onChanged: (val) {
                          setState(() {
                            id = val;
                          });
                        },
                      ),
                    ),
                    Text(
                      'Id',
                      style: new TextStyle(
                        fontSize: 17.0,
                      ),
                    ),
                  ],
                ),
              ),
            if (isSearch == true)
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: search,
                    onChanged: (search) {
                      String tes = search.toUpperCase();
                      List<dynamic> filter = id == 1
                          ? cadangan
                              .where((finance) => finance['nama'].contains(tes))
                              .toList()
                          : cadangan
                              .where((finance) => finance['kode'].contains(tes))
                              .toList();
                      setState(() {
                        daftarDownline = filter;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: id == 1 ? "nama reseller" : "kode reseller" ,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 5,
                          color: Warna.warna(kuning),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            IconButton(
                icon: Icon(Icons.search, size: 25.0),
                onPressed: () {
                  changeValue();
                }),
          ],
        ),
        body: isLoading
            ? Center(child: Loading())
            : daftarDownline.length == 0
                ? Center(child: Text('Anda Belum Memiliki Downline'))
                // : jumlahSubDownline.length != daftarDownline.length
                //     ? Center(child: Loading())
                : Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Text(
                            'Total Downline Anda ${daftarDownline.length}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Warna.warna(biru))),
                      ),
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: daftarDownline.length,
                            itemBuilder: (context, i) {
                              return PopupMenuButton(
                                offset: Offset(100, 0),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 1,
                                    child: Text("Edit Markup"),
                                  ),
                                  PopupMenuItem(
                                    value: 2,
                                    child: Text("Tambah Saldo"),
                                  ),
                                ],
                                onSelected: (value) {
                                  if (value == 1) {
                                    showDialog(
                                        // barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                                'Edit Markup ${daftarDownline[i]['kode']}'),
                                            content: Container(
                                              height: 120,
                                              child: Column(children: <Widget>[
                                                TextFormField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  controller: nominalMarkup,
                                                  onChanged: (nominalMarkup) {},
                                                  decoration: InputDecoration(
                                                      prefixText: 'Rp '),
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: <Widget>[
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          editMarkup(
                                                              daftarDownline[i]
                                                                  ['kode']);
                                                        },
                                                        child: Text('Simpan')),
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text('Batal'))
                                                  ],
                                                )
                                              ]),
                                            ),
                                          );
                                        });
                                  } else {
                                    showDialog(
                                        // barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                                'Tambah Saldo Downline ${daftarDownline[i]['kode']}'),
                                            content: Container(
                                              height: 120,
                                              child: Column(children: <Widget>[
                                                TextFormField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  controller: nominalMarkup,
                                                  onChanged: (nominalMarkup) {
                                                    changeFormat();
                                                  },
                                                  decoration: InputDecoration(
                                                      prefixText: 'Rp '),
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: <Widget>[
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          // showModalBottomSheet<
                                                          //         void>(
                                                          //     constraints:
                                                          //         BoxConstraints(
                                                          //       minWidth:
                                                          //           MediaQuery.of(
                                                          //                   context)
                                                          //               .size
                                                          //               .width,
                                                          //       maxWidth:
                                                          //           MediaQuery.of(
                                                          //                   context)
                                                          //               .size
                                                          //               .width,
                                                          //       minHeight: 100,
                                                          //       maxHeight:
                                                          //           MediaQuery.of(
                                                          //                   context)
                                                          //               .size
                                                          //               .height,
                                                          //     ),
                                                          //     isScrollControlled:
                                                          //         true,
                                                          //     backgroundColor:
                                                          //         Colors
                                                          //             .transparent,
                                                          //     shape:
                                                          //         RoundedRectangleBorder(
                                                          //       // side: BorderSide(color: Colors.white, width: 1),
                                                          //       borderRadius: BorderRadius.only(
                                                          //           topLeft: Radius
                                                          //               .circular(
                                                          //                   20),
                                                          //           topRight: Radius
                                                          //               .circular(
                                                          //                   20)),
                                                          //     ),
                                                          //     context: context,
                                                          //     builder:
                                                          //         (BuildContext
                                                          //             context) {
                                                          //       return Form(
                                                          //         key: formKey,
                                                          //         child:
                                                          //             PinCodeTextField(
                                                          //           appContext:
                                                          //               context,
                                                          //           length: 6,
                                                          //           obscureText:
                                                          //               true,
                                                          //           pinTheme: PinTheme(
                                                          //               fieldHeight:
                                                          //                   40,
                                                          //               fieldWidth:
                                                          //                   30,
                                                          //               shape: PinCodeFieldShape
                                                          //                   .circle),
                                                          //           validator:
                                                          //               (variablenyabebas) {
                                                          //             if (variablenyabebas
                                                          //                     .length <
                                                          //                 6) {
                                                          //               return "Must 6 digit";
                                                          //             } else {
                                                          //               return null;
                                                          //             }
                                                          //           },
                                                          //           onChanged:
                                                          //               (value) {},
                                                          //           onCompleted:
                                                          //               (v) {
                                                          //             String
                                                          //                 pin =
                                                          //                 v;
                                                          //             Navigator.pop(
                                                          //                 context);
                                                          //             findReseller(
                                                          //                 daftarDownline[i]['pengirim'][0]
                                                          //                     [
                                                          //                     'pengirim'],
                                                          //                 pin);
                                                          //           },
                                                          //         ),
                                                          //       );
                                                          //     });
                                                          showDialog(
                                                              useSafeArea: true,
                                                              barrierDismissible:
                                                                  false,
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title: Text(
                                                                      'Masukkan Pin Anda'),
                                                                  content: Form(
                                                                    key:
                                                                        formKey,
                                                                    child:
                                                                        PinCodeTextField(
                                                                      appContext:
                                                                          context,
                                                                      // controller: pinReseller,
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .number,
                                                                      length: 6,
                                                                      obscureText:
                                                                          true,
                                                                      obscuringCharacter:
                                                                          '*',
                                                                      cursorColor:
                                                                          Colors
                                                                              .indigo[400],
                                                                      // enableActiveFill: true,
                                                                      pinTheme:
                                                                          PinTheme(
                                                                        fieldHeight:
                                                                            40,
                                                                        fieldWidth:
                                                                            30,
                                                                        shape: PinCodeFieldShape
                                                                            .box,
                                                                        borderRadius:
                                                                            BorderRadius.circular(5),
                                                                        selectedColor:
                                                                            Colors.indigo[400],
                                                                        // activeFillColor: Colors.indigo[700] blm tau untuk apa
                                                                      ),
                                                                      validator:
                                                                          (variablenyabebas) {
                                                                        if (variablenyabebas.length <
                                                                            6) {
                                                                          return "Must 6 digit";
                                                                        } else {
                                                                          return null;
                                                                        }
                                                                      },
                                                                      onChanged:
                                                                          (value) {},
                                                                      onCompleted:
                                                                          (v) {
                                                                        String
                                                                            pin =
                                                                            v;
                                                                        Navigator.pop(
                                                                            context);
                                                                        findReseller(
                                                                            daftarDownline[i]['pengirim'][0]['pengirim'],
                                                                            pin);
                                                                      },
                                                                      // onTap: () {
                                                                      //   print("Pressed");
                                                                      // },
                                                                      // pastedTextStyle: TextStyle(
                                                                      //   color: Colors.yellow,
                                                                      //   fontWeight: FontWeight.bold,
                                                                      // ),
                                                                      // obscuringWidget: FlutterLogo(
                                                                      //   size: 24,
                                                                      // ),
                                                                      // blinkWhenObscuring: true,
                                                                      // animationType: AnimationType.fade,
                                                                      // animationDuration: Duration(milliseconds: 300),
                                                                      // // errorAnimationController: errorController,

                                                                      // boxShadows: [
                                                                      //   BoxShadow(
                                                                      //     offset: Offset(0, 1),
                                                                      //     color: Colors.black12,
                                                                      //     blurRadius: 10,
                                                                      //   )
                                                                      // ],

                                                                      // beforeTextPaste: (text) {
                                                                      //   print("Allowing to paste $text");
                                                                      //   //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                                                      //   //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                                                      //   return true;
                                                                      // },
                                                                    ),
                                                                  ),
                                                                );
                                                              });
                                                        },
                                                        child:
                                                            Text('Lanjutkan')),
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text('Batal'))
                                                  ],
                                                )
                                              ]),
                                            ),
                                          );
                                        });
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.0))),
                                child: Card(
                                  elevation: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: i % 2 == 0
                                            ? Warna.warna(biru)
                                            : Colors.blue[600]),
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                daftarDownline[i]['kode'],
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: warna(i)),
                                              ),
                                              SizedBox(height: 10),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3,
                                                child: Text(
                                                    daftarDownline[i]['nama'],
                                                    style: TextStyle(
                                                        fontSize: 15.0,
                                                        color: warna(i))),
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              Text('Saldo',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: warna(i))),
                                              SizedBox(height: 5),
                                              Text(
                                                  NumberFormat.currency(
                                                          locale: 'id',
                                                          symbol: 'Rp ',
                                                          decimalDigits: 0)
                                                      .format(daftarDownline[i]
                                                          ['saldo']),
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: warna(i))),
                                              SizedBox(height: 5),
                                              Text(
                                                  daftarDownline[i]['aktif'] ==
                                                          1
                                                      ? 'Aktif'
                                                      : 'Blokir',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: daftarDownline[i]
                                                                  ['aktif'] ==
                                                              1
                                                          ? Colors
                                                              .greenAccent[400]
                                                          : Colors.red))
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: <Widget>[
                                                  Text('Mark Up',
                                                      style: TextStyle(
                                                          color: warna(i))),
                                                  Text(
                                                      daftarDownline[i]
                                                              ['markup']
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: warna(i))),
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: <Widget>[
                                                    Text('Downline',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: warna(i))),
                                                    Text(
                                                        daftarDownline[i][
                                                                'jumlahDownline']
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: warna(i)))
                                                  ]),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    Register(kodeReseller: dataUser['kode'])));
          },
          backgroundColor: Warna.warna(biru),
          tooltip: 'Daftarkan Teman Sebagai Downline Anda',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

/// item builder untuk popup menu bisa seperti ini initemBuilder: (context) {
//   return List.generate(2, (ind) {
//     return PopupMenuItem(
//         child: GestureDetector(
//             onTap: () {
//               print(daftarDownline[i]);
//             },
//             child: menuItems[ind]));
//   });
// },

// enum SearchBy { nama, id }
// SearchBy _searchBy = SearchBy.id;
// Row(
//                         children: <Widget>[
//                           RadioListTile(
//                             title: const Text('Name'),
//                             value: SearchBy.nama,
//                             groupValue: _searchBy,
//                             onChanged: (value) {
//                               setState(() {
//                                 _searchBy = value;
//                               });
//                             },
//                           ),
//                           RadioListTile(
//                             title: const Text('Id'),
//                             value: SearchBy.id,
//                             groupValue: _searchBy,
//                             onChanged: (value) {
//                               setState(() {
//                                 _searchBy = value;
//                               });
//                             },
//                           ),
//                         ],
//                       ),