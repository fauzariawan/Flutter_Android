import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import '../component.dart';
import '../dashboard.dart';
import '../listWarna.dart';
import './produkPromo.dart';

class OperatorPromo extends StatefulWidget {
  @override
  _OperatorPromoState createState() => _OperatorPromoState();
}

class _OperatorPromoState extends State<OperatorPromo> {
  List<dynamic> operatorPromo = [];
  dynamic selectedItem;
  bool isLoading = false;
  void initState() {
    super.initState();
    _operatorPromo();
  }

  _operatorPromo() async {
    setState(() {
      isLoading = true;
    });
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = 'operator';
    final params = {"kriteria": "Promo"};
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());

    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
        operatorPromo = json.decode(response.body);
      });
    } else {
      print('gagal');
    }
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
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Text('Operator Promo'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            PangkatPendek(
              height: 80,
            ),
            isLoading
                ? Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Loading(),
                  )
                : operatorPromo.length == 0
                    ? Container()
                    : Expanded(
                        child: AnimationLimiter(
                          child: NotificationListener<
                              OverscrollIndicatorNotification>(
                            onNotification: (overscroll) {
                              overscroll.disallowGlow();
                            },
                            child: ListView.builder(
                                shrinkWrap: true,
                                // physics: NeverScrollableScrollPhysics(),
                                itemCount: operatorPromo.length,
                                itemBuilder: (context, i) {
                                  return AnimationConfiguration.staggeredList(
                                    position: i,
                                    duration:
                                        const Duration(milliseconds: 1000),
                                    child: SlideAnimation(
                                      verticalOffset: 200.0,
                                      child: FadeInAnimation(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedItem = operatorPromo[i];
                                              print(selectedItem);
                                            });
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProdukPromo(
                                                            data: selectedItem,
                                                            dataRouting:
                                                                null)));
                                          },
                                          child: Container(
                                            height: 70,
                                            padding: EdgeInsets.only(
                                                left: 10, right: 10, top: 10),
                                            child: Container(
                                              margin: EdgeInsets.all(0),
                                              decoration: BoxDecoration(
                                                  color: Warna.warna(biru),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color:
                                                            Warna.warna(kuning),
                                                        offset: Offset(0, 5))
                                                  ]),
                                              // ini untuk card()
                                              // shape: RoundedRectangleBorder(
                                              //   side: BorderSide(color: Colors.grey, width: 0),
                                              //   borderRadius: BorderRadius.circular(10),
                                              // ),
                                              child: Row(
                                                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: <Widget>[
                                                  // SizedBox(
                                                  //   width: 10,
                                                  // ),
                                                  operatorPromo[i]
                                                              ['apk_ikon'] !=
                                                          null
                                                      ? Format.iconNetwork(
                                                          operatorPromo[i]
                                                              ['apk_ikon'])
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: Icon(
                                                              Icons
                                                                  .access_alarm_outlined,
                                                              color:
                                                                  Warna.warna(
                                                                      kuning)),
                                                        ),
                                                  // SizedBox(
                                                  //   width: 10,
                                                  // ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        operatorPromo[i]
                                                            ['nama'],
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        operatorPromo[i]
                                                            ['catatan'],
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white60,
                                                            fontSize: 10),
                                                      )
                                                    ],
                                                  ),
                                                  // Text(operatorPromo[i]['kode'])
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                      )
          ],
        ),
      ),
    );
  }
}
