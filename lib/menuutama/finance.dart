import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'dart:convert';
import '../component.dart';
import 'cekTagihan.dart';
// import 'package:flutter/scheduler.dart';

class Finance extends StatefulWidget {
  Finance({this.data});
  final dynamic data;
  @override
  _FinanceState createState() => _FinanceState();
}

class _FinanceState extends State<Finance> {
  final TextEditingController finance = new TextEditingController();
  LocalStorage storage = new LocalStorage('localstorage_app');
  final _formFinance = GlobalKey<FormState>();

  List<dynamic> allFinance = [];
  List<dynamic> cadangan;
  List<dynamic> datamentah;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // allFinance = storage.getItem("allProvinsi");
    // cadangan = storage.getItem("allProvinsi");
    // print(allProvinsi);
    getAllFinance();
  }

  getAllFinance() async {
    setState(() {
      isLoading = true;
    });
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = 'olahdata/getProduk';
    final params = {
      "kodeOperator": '${widget.data['kode']}',
      "kriteria": 'cek' //'${widget.data['kriteria']}'
    };
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());

    var response = await http.get(url, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "token": storage.getItem('token')
    });
    if (response.statusCode == 200) {
      datamentah = json.decode(response.body);
      datamentah
          .map((e) => e['nama'] = e['nama'].substring(4, e['nama'].length))
          .toList();
      setState(() {
        isLoading = false;
        allFinance = datamentah;
        cadangan = datamentah;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // timeDilation = 2.0;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.data['nama']),
        ),
        body: Column(
          children: [
            if (widget.data['nama'] == 'Pasca Bayar')
              Container(
                margin: EdgeInsets.all(10),
                child: Text(
                  'Provider pasca bayar adalah layanan produk postpaid',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
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
                          .where((finance) => finance['nama'].contains(tes))
                          .toList();
                      setState(() {
                        allFinance = filter;
                      });
                    },
                    decoration: InputDecoration(suffixIcon: Icon(Icons.search)),
                  ),
                ),
              ),
            ),
            isLoading
                ? Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Loading(),
                  )
                : Expanded(
                    // biar listview nya berada dibawah textformfield
                    child: allFinance.length > 0
                        ? NotificationListener<OverscrollIndicatorNotification>(
                            onNotification: (overscroll) {
                              overscroll.disallowGlow();
                            },
                            child: ListView.builder(
                                // physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: allFinance.length,
                                itemBuilder: (context, i) {
                                  return Container(
                                    margin:
                                        EdgeInsets.only(left: 12, right: 12),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CekTagihan(
                                                        data: allFinance[i])));
                                      },
                                      child: Container(
                                          margin: EdgeInsets.only(top: 10),
                                          decoration: decoration,
                                          child: Row(
                                            children: [
                                              allFinance[i]['catatan'] != null
                                                  ? Format.iconNetwork(
                                                      allFinance[i]['catatan'])
                                                  : Container(
                                                      width: 50,
                                                      height: 50,
                                                      child: Center(
                                                          child:
                                                              Text('No Pict'))),
                                              Container(
                                                width: MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2 +
                                                    50,
                                                child: Text(
                                                  allFinance[i]['nama'],
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                      fontSize: 20.0,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                  );
                                }),
                          )
                        : Container()),
          ],
        ));
  }
}
