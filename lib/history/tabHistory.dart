import 'dart:async';

import 'package:android/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:localstorage/localstorage.dart';
import 'dart:convert';
import 'detailTransaksi.dart';

class TabHistory extends StatefulWidget {
  TabHistory({this.data});
  final dynamic data;
  @override
  _TabHistoryState createState() => _TabHistoryState();
}

class _TabHistoryState extends State<TabHistory> {
  // LocalStorage storage = new LocalStorage('localstorage_app');
  List<dynamic> allItem = [];
  List<dynamic> result = [];
  bool isLoading = false;
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    callData(1);
  }

  callData(int n) async {
    print(n);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = 'reseller/alltransaksi';
    final params = null;
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());

    var response = await http.get(url, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "token": prefs.getString('token')
    });

    if (response.statusCode == 200) {
      result = json.decode(response.body);
      if (allItem.length == 0) {
        setState(() {
          isLoading = false;
          allItem = result;
        });
        n += 1;
        callData(n);
      } else {
        print('masuk ke sini');
        if (allItem == result) {
          print('data masih sama');
          n += 1;
          n != 30 ? Timer(Duration(seconds: 2), callData(n)) : null;
        } else {
          print('data beda');
          setState(() {
            allItem = result;
          });
          print('data sudah di update');
          n += 1;
          n != 30 ? Timer(Duration(seconds: 2), callData(n)) : null;
        }
      }
      // print(response.body);
    } else {
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading()
        : Container(
            child: allItem.length == 0
                ? Center(
                    child: Text('Anda Belum Memiliki Data Transaksi'),
                  )
                : ListView.builder(
                    itemCount: allItem.length,
                    itemBuilder: (context, i) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  DetailTransaksi(data: allItem[i], kode: 1)));
                          print(allItem[i]);
                        },
                        child: CardHistory(
                            tujuan: allItem[i]['tujuan'],
                            namaProduk: allItem[i]['produk']['nama'],
                            hargaJual: allItem[i]['harga'],
                            status: allItem[i]['status']),
                      );
                    }));
  }
}
