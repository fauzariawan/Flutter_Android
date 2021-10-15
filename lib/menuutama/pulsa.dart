import 'package:android/component.dart';
import 'package:android/dashboard.dart';
import 'package:android/menuutama/produkPromo.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../listWarna.dart';
import '../phoneBook.dart';
import '../routerName.dart';
import './konfirmasiPembelian.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'kirimSaldo.dart';

class Pulsa extends StatefulWidget {
  Pulsa({this.data});
  final dynamic data;
  @override
  _PulsaState createState() => _PulsaState();
}

class _PulsaState extends State<Pulsa> {
  TextEditingController nomorTujuan = new TextEditingController();
  LocalStorage storage = new LocalStorage('localstorage_app');
  List<dynamic> productPulsa = [];
  List<dynamic> phonebook = [];
  int selectedIndex;
  dynamic selectedItem;
  bool buttonBayar = false;
  bool isLoading = false;
  bool isDbFailed = false;
  String gambar;
  int indexGambar;
  String selectedNumber = '';
  dynamic dataUser;
  dynamic favorit;
  // final PagingController<int, CharacterSummary> _pagingController =
  //     PagingController(firstPageKey: 0);

  void initState() {
    super.initState();
    if (widget.data == null) {
      print("widget data tidak ada");
    } else {
      print("ada widget data");
      print(widget.data);
      var regExp = new RegExp(r'[^0-9]');
      String clrStr = widget.data['noTelp'] != null
          ? widget.data['noTelp'].replaceAll(regExp, '')
          : "";
      if (clrStr.contains("62")) {
        clrStr = "0${clrStr.substring(2, clrStr.length)}";
      }
      setState(() {
        selectedNumber = clrStr;
        nomorTujuan = TextEditingController(text: selectedNumber);
        _cariProduct(selectedNumber);
        print(selectedNumber);
      });
    }
  }

  _cariProduct(nomorTujuan) async {
    setState(() {
      isLoading = true;
    });
    selectedIndex = null;
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = 'olahdata/pulsaperreseller';
    final params = null;
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.post(url, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'token': prefs.getString('token')
    }, body: {
      "prefix_tujuan": nomorTujuan
    });
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
        productPulsa = json.decode(response.body);
      });
      print(productPulsa[productPulsa.length - 1]['gambar']);
    } else {
      setState(() {
        isLoading = false;
      });
      print('gagal tersambung');
    }
  }

  getContactList() async {
    phonebook = await ContactList.pickContact();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PhoneBook(data: phonebook, routing: pulsa)));
    // phonebook = await ContactList.pickContact();
    //   Navigator.of(context).push(MaterialPageRoute(
    //     builder: (context) => PhoneBook(data: phonebook, routing: kirimSaldo)));
  }

  getFavorit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dataUser = json.decode(prefs.getString('dataUser'));
    favorit = dataUser['reseller_save'];
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PhoneBook(data: favorit, routing: pulsa)));
  }

  Future<bool> _back() {
    return Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Dashboard(
              selected: 0,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _back,
      child: Scaffold(
        resizeToAvoidBottomInset:
            false, // agar keyboard timbul tidak bottom overload
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text('Pulsa'),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                PangkatPendek(
                  height: 80,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    maxLength: 13,
                    controller: nomorTujuan,
                    onChanged: (nomorTujuan) {
                      print(nomorTujuan);
                      if (nomorTujuan.length <= 3) {
                        setState(() {
                          productPulsa.clear();
                        });
                      } else if (nomorTujuan.length > 3 &&
                              nomorTujuan.length < 7 ||
                          nomorTujuan.length == 12) {
                        _cariProduct(nomorTujuan);
                      }
                    },
                    decoration: InputDecoration(
                        counterText:
                            '', // untuk menghilangkan hint maxLength 0/12
                        border: OutlineInputBorder(),
                        labelText: 'Nomor Tujuan',
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
                isLoading
                    ? Container(
                        height: MediaQuery.of(context).size.height / 2,
                        child: Loading())
                    : productPulsa.length == 0
                        ? Container()
                        : Expanded(
                            // kalau mau scroll dibawah text field ini di ganti sama expanded
                            // margin: EdgeInsets.only(left: 20, right: 20),
                            child: Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              child: AnimationLimiter(
                                child: ListView.builder(
                                    // physics:
                                    //     NeverScrollableScrollPhysics(), // kalau mau scroll dibawah text field ini di coment
                                    shrinkWrap: true,
                                    itemCount: productPulsa.length - 1,
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
                                                        selectedItem =
                                                            productPulsa[i];
                                                      });
                                                    },
                                                    child: Container(
                                                        margin: EdgeInsets.only(
                                                            bottom: 10,
                                                            top: i == 0
                                                                ? 10
                                                                : 0),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            color:
                                                                selectedIndex ==
                                                                        i
                                                                    ? Warna
                                                                        .warna(
                                                                            biru)
                                                                    : Colors.white,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors
                                                                      .grey,
                                                                  offset:
                                                                      Offset(
                                                                          0, 5),
                                                                  blurRadius: 5)
                                                            ]),

                                                        // elevation: 5,
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: <Widget>[
                                                            // Image.asset('image/indosat.png'),
                                                            Container(
                                                              // width: 60,
                                                              height: 60,
                                                              child: ClipRRect(
                                                                child: Image
                                                                    .network(
                                                                  productPulsa[
                                                                          i][
                                                                      'catatan'],
                                                                  width: 40,
                                                                ),
                                                              ),
                                                              // decoration: BoxDecoration(
                                                              //     borderRadius:
                                                              //         BorderRadius.circular(
                                                              //             10.0),
                                                              //     image: DecorationImage(
                                                              //         image: NetworkImage(
                                                              //             productPulsa[productPulsa
                                                              //                     .length -
                                                              //                 1]['gambar']),
                                                              //         fit: BoxFit.cover)),
                                                            ),
                                                            Container(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height /
                                                                  15,
                                                              // color: Colors.yellow,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Row(
                                                                    children: <
                                                                        Widget>[
                                                                      Container(
                                                                          padding: EdgeInsets.all(
                                                                              5),
                                                                          decoration: BoxDecoration(
                                                                              color: Warna.warna(biru),
                                                                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
                                                                          child: Text(productPulsa[i]['kode'], style: TextStyle(color: Colors.white))),
                                                                    ],
                                                                  ),
                                                                  Text(
                                                                    productPulsa[
                                                                            i][
                                                                        'nama'],
                                                                    style: TextStyle(
                                                                        color: selectedIndex ==
                                                                                i
                                                                            ? Colors.white
                                                                            : Colors.black),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  NumberFormat.currency(
                                                                          locale:
                                                                              'id',
                                                                          decimalDigits:
                                                                              0,
                                                                          symbol:
                                                                              'Rp ')
                                                                      .format(productPulsa[
                                                                              i]
                                                                          [
                                                                          'harga_jual']),
                                                                  style: TextStyle(
                                                                      color: selectedIndex == i
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .black),
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text(
                                                                    "${productPulsa[i]['poin'] ?? '0'} Poin",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        color: selectedIndex ==
                                                                                i
                                                                            ? Colors.white
                                                                            : Colors.black)),
                                                                SizedBox(
                                                                    height: 5),
                                                                productPulsa[i][
                                                                            'gangguan'] ==
                                                                        0
                                                                    ? Info(
                                                                        text:
                                                                            "Normal",
                                                                        color: Colors
                                                                            .green)
                                                                    : Info(
                                                                        text:
                                                                            "Gangguan",
                                                                        color: Colors
                                                                            .red)
                                                              ],
                                                            )
                                                          ],
                                                        )),
                                                  ),
                                                ),
                                              ));
                                    }),
                              ),
                            ),
                          ),
              ],
            ),
            buttonBayar
                ? Positioned(
                    bottom: 5.0,
                    right: 5.0,
                    child: Container(
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => KonfirmasiPembelian(
                                    nomorTujuan: nomorTujuan.text,
                                    selectedItem: selectedItem,
                                    dataPelanggan: null)));
                          },
                          child: Text('Beli')),
                    ))
                : Container()
          ],
        ),
      ),
    );
  }
}
