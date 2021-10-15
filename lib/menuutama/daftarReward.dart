import 'package:android/menuutama/riwayatPenukaran.dart';
import "package:flutter/material.dart";
import 'dart:convert';
import 'package:localstorage/localstorage.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import '../component.dart';
import '../listWarna.dart';

class DaftarReward extends StatefulWidget {
  @override
  _DaftarRewardState createState() => _DaftarRewardState();
}

class _DaftarRewardState extends State<DaftarReward> {
  LocalStorage storage = new LocalStorage('localstorage_app');
  List<dynamic> menu = [];
  bool isLoading = false;

  void initState() {
    callData();
    super.initState();
  }

  callData() async {
    setState(() {
      isLoading = true;
    });
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    var tesMenu = storage.getItem('reward');
    setState(() {
      menu = json.decode(tesMenu);
      print(menu);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Daftar Reward"),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RiwayatPenukaranHadiah()));
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Icon(Icons.history),
              ),
            )
          ],
        ),
        body: isLoading
            ? Loading()
            : menu.length == 0
                ? Container()
                : Container(
                    padding: EdgeInsets.only(top: 20),
                    margin: EdgeInsets.all(0),
                    child: GridView.builder(
                        // addRepaintBoundaries: false,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 0,
                            childAspectRatio: 1),
                        itemCount: menu.length,
                        itemBuilder: (BuildContext context, i) {
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Tukar Reward',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Warna.warna(biru),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      content: Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                    2 -
                                                100,
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text('Nama',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          Warna.warna(kuning))),
                                              Text(menu[i]["nama"],
                                                  style: TextStyle(
                                                      color:
                                                          Warna.warna(biru))),
                                              SizedBox(height: 10),
                                              Text('Deskripsi',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          Warna.warna(kuning))),
                                              Text(
                                                  menu[i]["hadiah_desc"]
                                                      ["h_desc"],
                                                  style: TextStyle(
                                                      color:
                                                          Warna.warna(biru))),
                                              SizedBox(height: 10),
                                              Text("Poin Dibutuhkan",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          Warna.warna(kuning))),
                                              Text(
                                                  menu[i]["jml_poin"]
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Warna.warna(biru),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20))
                                            ]),
                                      ),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          onPressed: () {},
                                          child: Text('Tukarkan'),
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Tutup'))
                                      ],
                                    );
                                  });
                            },
                            child: Container(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(
                                      menu[i]['hadiah_desc']['h_img'],
                                      fit: BoxFit.fill,
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ));
  }
}
