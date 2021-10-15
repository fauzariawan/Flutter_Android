import 'package:android/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:http/http.dart' as http;
// import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'detailMutasi.dart';

class TabMutasi extends StatefulWidget {
  @override
  _TabMutasiState createState() => _TabMutasiState();
}

class _TabMutasiState extends State<TabMutasi> {
  // LocalStorage storage = new LocalStorage('localstorage_app');
  List<dynamic> allItem = [];
  bool isLoading = false;
  void initState() {
    super.initState();
    callData();
  }

  callData() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = 'reseller/allmutasi';
    final params = null;
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());

    var response = await http.get(url, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "token": prefs.getString('token')
    });

    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
        allItem = json.decode(response.body);
      });
      print(response.body);
    } else {
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading()
        : allItem.length == 0
            ? Center(child: Text('Anda Belum Memiliki Data Mutasi'))
            : Container(
                child: allItem.length == 0
                    ? Container()
                    : ListView.builder(
                        itemCount: allItem.length,
                        itemBuilder: (context, i) {
                          return GestureDetector(
                              onTap: () {
                                // print(allItem[i]['jumlah']);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => DetailMutasi(data: allItem[i])));
                              },
                              child: CardMutasi(
                                  keterangan: allItem[i]['keterangan'],
                                  tanggal: allItem[i]['tanggal'],
                                  jumlah: allItem[i]['jumlah']));
                        }));
  }
}
