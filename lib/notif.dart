import 'package:android/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'dart:convert';

import 'dashboard.dart';

class Notif extends StatefulWidget {
  @override
  _NotifState createState() => _NotifState();
}

class _NotifState extends State<Notif> {
  LocalStorage storage = new LocalStorage('localstorage_app');
  List<dynamic> allItem = [];
  bool isDbFailed = false;
  bool isLoading = false;
  void initState() {
    super.initState();
    callData();
  }

  callData() async {
    setState(() {
      isLoading = true;
    });
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = 'reseller/allnotification';
    final params = null;
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());

    var response = await http.get(url, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "token": storage.getItem('token')
    });

    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
        allItem = json.decode(response.body);
      });
      print(allItem);
    } else if (response.statusCode == 500) {
      setState(() {
        isDbFailed = true;
      });
    } else {
      print(response.body);
    }
  }

  Future<bool> _back() {
    return Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Dashboard(selected: 0)));
  }

  Future<void> refreshPage() async {
    await Future.delayed(Duration(milliseconds: 500));
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = 'reseller/allnotification';
    final params = null;
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());

    var response = await http.get(url, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "token": storage.getItem('token')
    });

    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
        allItem = json.decode(response.body);
      });
      print(allItem);
    } else if (response.statusCode == 500) {
      setState(() {
        isDbFailed = true;
      });
    } else {
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _back,
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text('Notification'),
            centerTitle: true,
          ),
          body: isDbFailed
              ? Text('DB Connection Failded')
              : isLoading
                  ? Container(
                      height: MediaQuery.of(context).size.height,
                      child: Loading())
                  : allItem.length > 0
                      ? RefreshIndicator(
                          onRefresh: refreshPage,
                          child: ListView.builder(
                              itemCount: allItem.length,
                              itemBuilder: (context, i) {
                                return GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                                content:
                                                    Text(allItem[i]["pesan"]),
                                                actions: <Widget>[
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("Tutup"))
                                                ]);
                                          });
                                    },
                                    child: CardNotif(
                                        pesan: allItem[i]['pesan'],
                                        tanggal: allItem[i]['tgl_entri']));
                              }),
                        )
                      : Container()),
    );
  }
}
