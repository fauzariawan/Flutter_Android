import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'dart:convert';
import '../../component.dart';
import '../../routerName.dart';

class Driver extends StatefulWidget {
  Driver({this.data});
  final dynamic data;
  @override
  _DriverState createState() => _DriverState();
}

class _DriverState extends State<Driver> {
  LocalStorage storage = new LocalStorage('localstorage_app');
  List<dynamic> dataOperator = [];
  List<dynamic> datamentah;
  bool isLoading = false;

  void initState() {
    super.initState();
    callOperator();
  }

  callOperator() async {
    setState(() {
      isLoading = true;
    });
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = 'operator';
    final params = {"kriteria": widget.data['kriteria']};
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
        dataOperator = datamentah;
      });
    } else {
      print('gagal');
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(child: Loading())
        : dataOperator.length == 0
            ? Container()
            : NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowGlow();
                },
                child: ListView.builder(
                    itemCount: dataOperator.length,
                    itemBuilder: (context, i) {
                      return CardMenu(
                        data: dataOperator[i],
                        title: dataOperator[i]['kode'],
                        description: dataOperator[i]['nama'],
                        route: produkPromo,
                      );
                    }),
              );
  }
}
