import 'package:android/component.dart';
import 'package:android/menuutama/paketData.dart';
import 'package:android/menuutama/subPaketData/dataVoucher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:localstorage/localstorage.dart';
import 'dart:convert';

import '../produkPromo.dart';
import 'dataInjek.dart';

class Kuota extends StatefulWidget {
  Kuota({this.kode, this.title, this.backupKodeTitle});
  final String kode; // 3
  final String title; // data voucher
  final dynamic backupKodeTitle;

  @override
  _KuotaState createState() => _KuotaState();
}

class _KuotaState extends State<Kuota> {
  LocalStorage storage = new LocalStorage('localstorage_app');
  List<dynamic> data = [];
  List<dynamic> datamentah;
  bool isLoading = false;
  List<String> dataVoucer = ['3a', '3t', '3x', '3h', '3i', '3s'];
  void initState() {
    super.initState();
    print('ini kode nya');
    print(widget.kode);
    getProduk();
  }

  getProduk() async {
    setState(() {
      isLoading = true;
    });
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = 'operator';
    final params = {"kriteria": "${widget.kode}"};
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());

    var response = await http.get(url, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "token": storage.getItem('token')
    });
    if (response.statusCode == 200) {
      datamentah = json.decode(response.body);
      datamentah
          .map((e) => e['nama'] = e['nama'].substring(3, e['nama'].length))
          .toList();
      setState(() {
        isLoading = false;
        data = datamentah;
      });
      print(data[0]['apk_ikon']);
    } else {
      print('gagal');
    }
  }

  Future<bool> _back() {
    if (widget.kode == '3' || widget.kode == 'injek') {
      return Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => PaketData()));
    } else if (dataVoucer.contains(widget.kode)) {
      return Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => dataVoucher()));
    } else {
      return Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => DataInjek()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _back,
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Text(widget.title),
            centerTitle: true,
          ),
          body: Column(
            children: [
              PangkatPendek(height: 100),
              isLoading
                  ? Container(
                      height: MediaQuery.of(context).size.height / 2,
                      child: Loading(),
                    )
                  : Expanded(
                      child: data.length > 0
                          ? AnimationLimiter(
                              child: NotificationListener<
                                  OverscrollIndicatorNotification>(
                                onNotification: (overscroll) {
                                  overscroll.disallowGlow();
                                },
                                child: ListView.builder(
                                    // physics:NeverScrollableScrollPhysics(), // kalau mau scroll dibawah text field ini di coment
                                    shrinkWrap: true,
                                    itemCount: data.length,
                                    itemBuilder: (context, i) {
                                      return AnimationConfiguration
                                          .staggeredList(
                                        position: i,
                                        duration:
                                            const Duration(milliseconds: 1000),
                                        child: SlideAnimation(
                                          verticalOffset: 100.0,
                                          child: FadeInAnimation(
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProdukPromo(
                                                                data: data[i],
                                                                dataRouting: {
                                                                  "kode": widget
                                                                      .kode,
                                                                  "title":
                                                                      widget
                                                                          .title
                                                                },
                                                                logo: data[i][
                                                                    'apk_ikon'])));
                                              },
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    left: 15,
                                                    right: 15,
                                                    top: 10),
                                                child: Card(
                                                  child: Container(
                                                    padding: EdgeInsets.all(10),
                                                    child: Row(
                                                      children: <Widget>[
                                                        data[i]['apk_ikon'] ==
                                                                null
                                                            ? Text('No Picture')
                                                            : Image.network(
                                                                data[i][
                                                                    'apk_ikon'],
                                                                width: 40),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                data[i]['nama'],
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black)),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            data[i]['catatan'] !=
                                                                    null
                                                                ? Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.6,
                                                                    child: Text(
                                                                        data[i][
                                                                            'catatan'],
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.grey,
                                                                            fontSize: 10)),
                                                                  )
                                                                : Container()
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            )
                          : Container())
            ],
          )),
    );
  }
}
