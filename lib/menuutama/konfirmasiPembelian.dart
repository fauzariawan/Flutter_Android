import 'package:android/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import '../categoryOperator.dart';
import '../listWarna.dart';
import '../routerName.dart';
// import 'konfirmasiPin.dart';

class KonfirmasiPembelian extends StatefulWidget {
  KonfirmasiPembelian(
      {this.nomorTujuan, this.selectedItem, this.dataPelanggan});
  final String nomorTujuan;
  final dynamic selectedItem;
  final dynamic dataPelanggan;
  @override
  _KonfirmasiPembelianState createState() => _KonfirmasiPembelianState();
}

class _KonfirmasiPembelianState extends State<KonfirmasiPembelian> {
  TextEditingController nomorTujuan = new TextEditingController();
  TextEditingController nama = new TextEditingController();
  LocalStorage storage = new LocalStorage('localstorage_app');
  bool isLoading = false;
  dynamic result;
  String pesan;
  int type;
  final _formSaveNumber = GlobalKey<FormState>();
  void initState() {
    super.initState();
    print(widget.selectedItem);
  }

  loading() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return SpinKitWave(
            color: Warna.warna(biru),
          );
        });
  }

  simpanNomor() async {
    // setState(() {
    //   isLoading = true;
    // });
    // if (hpFavorit.contains(widget.selectedItem['kode_operator'])) {
    //   type = 1;
    // } else if (widget.selectedItem['kode_operator'] == 'PP') {
    //   type = 2;
    // }
    if (widget.selectedItem['kode_operator'] != 'PP') {
      type = 1;
    } else {
      type = 2;
    }
    print(widget.selectedItem['kode_operator']);
    print(type);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = "reseller/saveNumber";
    final params = null;
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());

    var response = await http.post(url, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "token": prefs.getString('token')
    }, body: {
      "number": nomorTujuan.text,
      "nama": nama.text,
      "type": type.toString()
    });

    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Nomor Berhasil Disimpan'),
          duration: Duration(milliseconds: 500)));
    } else if (response.statusCode == 400) {
      setState(() {
        isLoading = false;
      });
      result = json.decode(response.body);
      if (result['rc'] == '01') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Gagal Menyimpan Nomor'),
            duration: Duration(milliseconds: 500)));
      } else if (result['rc'] == '02') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Nomor Sudah Ada'),
            duration: Duration(milliseconds: 500)));
      }
    } else {
      setState(() {
        isLoading = false;
      });
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    nomorTujuan = TextEditingController(text: widget.nomorTujuan);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Konfirmasi Pembelian'),
      ),
      body: Stack(
        children: [
          AnimationLimiter(
            child: ListView(
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 1500),
                childAnimationBuilder: (widget) => SlideAnimation(
                  horizontalOffset: MediaQuery.of(context).size.width / 2,
                  child: FadeInAnimation(child: widget),
                ),
                children: [
                  Column(
                    children: [
                      Column(
                        children: <Widget>[
                          Container(
                            height: 170.0,
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(
                                top: 10.0, left: 10.0, right: 10.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(1.0, 8.0), //(x,y)
                                    blurRadius: 10.0,
                                  )
                                ]),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('Detail Pembelian',
                                        style: TextStyle(
                                            color: Warna.warna(biru),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0)),
                                    Icon(Icons.event_note_rounded,
                                        color: Warna.warna(biru))
                                  ],
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  height: 0,
                                  thickness: 0.5,
                                  indent: 0,
                                  endIndent: 0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    SubTitle(str: 'Nama Produk'),
                                    ValueSubTitle(
                                        str: widget.selectedItem['nama'])
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    SubTitle(str: 'Nomor Tujuan'),
                                    ValueSubTitle(str: widget.nomorTujuan)
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    SubTitle(str: 'Pengisian Ke'),
                                    ValueSubTitle(str: '1')
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    SubTitle(str: 'Poin'),
                                    ValueSubTitle(
                                        str: widget.selectedItem['poin'] == null
                                            ? '0'
                                            : widget.selectedItem['poin']
                                                .toString())
                                  ],
                                ),
                                widget.dataPelanggan != null
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          SubTitle(str: 'Nama'),
                                          ValueSubTitle(
                                              str: widget.dataPelanggan[
                                                  'CUSTOMER_NAME'])
                                        ],
                                      )
                                    : Container(),
                                widget.dataPelanggan != null
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          SubTitle(str: 'No. Pelanggan'),
                                          ValueSubTitle(
                                              str: widget.dataPelanggan[
                                                  'METER_NUMBER'])
                                        ],
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                          //////// DETAIL HARGA ////////
                          Container(
                            height: 170.0,
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(
                                top: 10.0, left: 10.0, right: 10.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(1.0, 8.0), //(x,y)
                                    blurRadius: 10.0,
                                  )
                                ]),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('Detail Harga',
                                        style: TextStyle(
                                            color: Warna.warna(biru),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0)),
                                    Icon(Icons.event_note,
                                        color: Warna.warna(biru))
                                  ],
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  height: 0,
                                  thickness: 0.5,
                                  indent: 0,
                                  endIndent: 0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    SubTitle(str: 'Harga Awal'),
                                    Text(
                                        NumberFormat.currency(
                                                locale: 'id',
                                                decimalDigits: 0,
                                                symbol: 'Rp. ')
                                            .format(widget
                                                .selectedItem['harga_jual']),
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Warna.warna(biru)))
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    SubTitle(str: 'Diskon'),
                                    ValueSubTitle(str: 'Rp. 0')
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    SubTitle(str: 'Cash Back'),
                                    ValueSubTitle(str: 'Rp. 0')
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    SubTitle(str: 'Total Bayar'),
                                    Text(
                                      NumberFormat.currency(
                                              locale: 'id',
                                              decimalDigits: 0,
                                              symbol: 'Rp. ')
                                          .format(widget
                                              .selectedItem['harga_jual']),
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Warna.warna(biru)),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          ////////// SIMPAN NOMOR ///////////
                          // SimpanNomor(nomorBawaan: widget.nomorTujuan)
                          Container(
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(
                                top: 10.0, left: 10.0, right: 10.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(1.0, 8.0), //(x,y)
                                    blurRadius: 10.0,
                                  )
                                ]),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('Simpan Nomor',
                                        style: TextStyle(
                                            color: Warna.warna(biru),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0)),
                                    Icon(Icons.save_alt_rounded,
                                        color: Warna.warna(biru))
                                  ],
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  height: 0,
                                  thickness: 0.5,
                                  indent: 0,
                                  endIndent: 0,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                ),
                                TextFormField(
                                  controller: nomorTujuan,
                                  readOnly: true,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      labelText: 'Nomor Tujuan',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.contact_phone)),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                ),
                                Form(
                                  key: _formSaveNumber,
                                  child: TextFormField(
                                    controller: nama,
                                    validator: (nama) {
                                      if (nama.isEmpty) {
                                        return 'Nama Tidak Boleh Kosong';
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration(
                                        labelText: 'Nama',
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.person)),
                                  ),
                                ),
                                isLoading
                                    ? Loading()
                                    : ElevatedButton(
                                        onPressed: () {
                                          if (_formSaveNumber.currentState
                                              .validate()) {
                                            simpanNomor();
                                          }
                                        },
                                        child: Text('Simpan'))
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 10.0,
              right: 10.0,
              child: Container(
                child: ElevatedButton(
                    onPressed: () {
                      if (widget.dataPelanggan == null) {
                        dynamic data = {
                          "kode": "transaksiProduk",
                          "harga_produk":
                              "${widget.selectedItem['harga_jual']}",
                          "code_product": "${widget.selectedItem['kode']}",
                          "destiny": nomorTujuan.text
                        };
                        Navigator.popAndPushNamed(context, konfirmasiPin,
                            arguments: data);
                        // Navigator.of(context).push(MaterialPageRoute(
                        //   builder: (context) => KonfirmasiPin(data: {
                        //         "kode": "transaksiProduk",
                        //         "harga_produk":
                        //             "${widget.selectedItem['harga_jual']}",
                        //         "code_product":
                        //             "${widget.selectedItem['kode']}",
                        //         "destiny": nomorTujuan.text
                        //       })));
                      } else {
                        dynamic data = {
                          "kode": "listrikToken",
                          "harga_produk":
                              "${widget.selectedItem['harga_jual']}",
                          "code_product": "${widget.selectedItem['kode']}",
                          "destiny": nomorTujuan.text
                        };
                        Navigator.popAndPushNamed(context, konfirmasiPin,
                            arguments: data);
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) => KonfirmasiPin(data: {
                        //           "kode": "listrikToken",
                        //           "harga_produk":
                        //               "${widget.selectedItem['harga_jual']}",
                        //           "code_product":
                        //               "${widget.selectedItem['kode']}",
                        //           "destiny": nomorTujuan.text
                        //         })));
                      }
                    },
                    child: Text('Bayar')),
              ))
        ],
      ),
    );
  }
}

class SubTitle extends StatelessWidget {
  SubTitle({this.str});
  final String str;
  @override
  Widget build(BuildContext context) {
    return Text(str,
        style: TextStyle(color: Warna.warna(kuning), fontSize: 10.0));
  }
}

class ValueSubTitle extends StatelessWidget {
  ValueSubTitle({this.str});
  final String str;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      child: Text(str,
          textAlign: TextAlign.right,
          style: TextStyle(
              color: Warna.warna(biru),
              fontSize: 14.0,
              fontWeight: FontWeight.bold)),
    );
  }
}
