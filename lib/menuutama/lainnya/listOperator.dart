import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

import '../../component.dart';

class ListOperator extends StatefulWidget {
  ListOperator({this.data});
  final dynamic data;
  @override
  _ListOperatorState createState() => _ListOperatorState();
}

class _ListOperatorState extends State<ListOperator> {
  TextEditingController finance = new TextEditingController();
  final _formFinance = GlobalKey<FormState>();
  List<dynamic> listOperator = [];
  List<dynamic> datamentah;
  bool isLoading = false;
  List<dynamic> allFinance = [];
  List<dynamic> cadangan;

  void initState() {
    print(widget.data);
    super.initState();
    _listOperator();
  }

  _listOperator() async {
    setState(() {
      isLoading = true;
    });
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = 'operator';
    final params = {"kriteria": "${widget.data['kode']}"};
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());

    var response = await http.get(url);
    datamentah = json.decode(response.body);
    datamentah
        .map((e) => e['nama'] = e['nama'].substring(2, e['nama'].length))
        .toList();
    for (var i = 0; i < datamentah.length; i++) {
      datamentah[i]['nama'] = datamentah[i]['nama'].toUpperCase();
    }
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
        cadangan = datamentah;
        listOperator = datamentah;
      });
      print(listOperator);
    } else {
      print('gagal');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(widget.data['nama']),
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          stretchModes: const <StretchMode>[
            StretchMode.zoomBackground,
            StretchMode.blurBackground,
            StretchMode.fadeTitle,
          ],
        ),
      ),
      body: Column(
        children: [
          PangkatPendek(
            height: 100,
          ),
          // Container(
          //   height: 170.0,
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //         begin: Alignment.topCenter,
          //         end: Alignment.bottomCenter,
          //         colors: [
          //           Colors.teal[800],
          //           Colors.white,
          //         ]),
          //   ),
          // ),
          if (widget.data['nama'] == 'Games')
            Form(
              key: _formFinance,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  child: TextFormField(
                    controller: finance,
                    onChanged: (finance) {
                      String tes = finance.toUpperCase();
                      List<dynamic> filter = cadangan
                          .where((operator) => operator['nama'].contains(tes))
                          .toList();
                      setState(() {
                        listOperator = filter;
                      });
                      // print(filter);
                    },
                    decoration: InputDecoration(suffixIcon: Icon(Icons.search)),
                  ),
                ),
              ),
            ),
          isLoading
              ? Container(
                  height: MediaQuery.of(context).size.height / 2,
                  child: Loading())
              : Expanded(
                  child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (overscroll) {
                    overscroll.disallowGlow();
                  },
                  child: ListView.builder(
                      // physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: listOperator.length,
                      itemBuilder: (context, i) {
                        return CardMenu(
                            route: widget.data['routing'],
                            data: listOperator[i],
                            title: listOperator[i]['nama'],
                            description: listOperator[i]['nama'],
                            catatan:listOperator[i]['catatan']);
                      }),
                ))
        ],
      ),
    );
  }
}
