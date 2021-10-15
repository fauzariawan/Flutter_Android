import 'package:android/component.dart';
import 'package:android/profilerouting/tukarKomisi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../listWarna.dart';

class Komisi extends StatefulWidget {
  @override
  _KomisiState createState() => _KomisiState();
}

class _KomisiState extends State<Komisi> {
  LocalStorage storage = new LocalStorage('localstorage_app');
  List<dynamic> allItem = [];
  bool isLoading = false;
  int totalKomisi = 0;
  int jumlah;
  void initState() {
    super.initState();
    callData();
  }

  callData() async {
    setState(() {
      isLoading = true;
    });
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = 'reseller/komisi';
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
        allItem.forEach((dynamic item) {
          if (item['tukar'] == 1) {
          } else {
            totalKomisi = totalKomisi + item['jumlah'];
          }
        });
      });
      print(totalKomisi);
      print(allItem.length);
    } else {
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Komisi'),
        centerTitle: true,
      ),
      body: isLoading
          ? Container(
              height: MediaQuery.of(context).size.height, child: Loading())
          : allItem.length == 0
              ? Center(
                  child: Text('Anda Belum Memiliki Komisi'),
                )
              : ListView.builder(
                  itemCount: allItem.length,
                  itemBuilder: (context, i) {
                    return CardKomisi(
                        transaksi: allItem[i]['transaksi'] == null
                            ? 'data hilang'
                            : 'Komisi Dari Transaksi ${allItem[i]['transaksi']['produk']['kode']}.${allItem[i]['transaksi']['tujuan']}',
                        idTransaksi: allItem[i]['transaksi'] == null
                            ? 'data hilang'
                            : allItem[i]['transaksi']['kode'].toString(),
                        komisi: allItem[i]['jumlah'],
                        tanggal: allItem[i]['transaksi'] == null
                            ? null
                            : allItem[i]['transaksi']['tgl_entri'],
                        isTukar: allItem[i]['tukar']);
                  }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => TukarKomisi(jmlKomisi: totalKomisi)));
        },
        label: Text(
          'Tukar Komisi',
          style: TextStyle(color: Warna.warna(kuning)),
        ),
        icon: Icon(Icons.send, color: Warna.warna(kuning)),
        backgroundColor: Warna.warna(biru),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
          child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Warna.warna(biru),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[800],
                blurRadius: 5.0,
              )
            ]),
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Total komisi', style: TextStyle(color: Colors.white)),
            Text(
                NumberFormat.currency(
                        locale: 'id', decimalDigits: 0, symbol: 'Rp. ')
                    .format(totalKomisi),
                style: TextStyle(color: Warna.warna(kuning)))
          ],
        ),
      )),
    );
  }
}
