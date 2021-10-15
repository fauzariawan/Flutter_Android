import 'package:android/component.dart';
import 'package:android/menuutama/QrImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:http/http.dart' as http;
// import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

import 'detailAlfamart.dart';
import 'detailDeposit.dart';

class TabDeposit extends StatefulWidget {
  @override
  _TabDepositState createState() => _TabDepositState();
}

class _TabDepositState extends State<TabDeposit> {
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
    final path = 'reseller/alldeposit';
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

  cekUrl(String url, dynamic data) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => DetailDeposit(data: data)));
      // print('Could not launch ${jawaban['data']['spi_status_url']}');
    }
    // launch(allItem[i]["wrkirim"]);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading()
        : Container(
            child: allItem.length == 0
                ? Center(
                    child: Text('Anda Belum Memiliki Data Deposit'),
                  )
                : ListView.builder(
                    itemCount: allItem.length,
                    itemBuilder: (context, i) {
                      return GestureDetector(
                          onTap: () {
                            print(allItem[i]);
                            print(allItem[i]["kode_pembayaran"]);
                            allItem[i]["kode_pembayaran"] == 'ALFAMART' ||
                                    allItem[i]["kode_pembayaran"] ==
                                        'VIRTUAL ACCOUNT' || allItem[i]["kode_pembayaran"] == 'QRIS'
                                ? Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        DetailAlfamart(data: allItem[i])))
                                : allItem[i]["kode_pembayaran"] == 'QRISPAY'
                                    ? Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                QrImage(image: allItem[i]['wrkirim'])))
                                    : Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => DetailDeposit(
                                                data: allItem[i])));
                            // print(allItem[i]["kode_pembayaran"]);
                            // if (allItem[i]["kode_pembayaran"] == 'QRISPAY')
                            //   Navigator.of(context).push(MaterialPageRoute(
                            //       builder: (context) =>
                            //           QrImage(image: allItem[i]['wrkirim'])));
                            // if (allItem[i]["kode_pembayaran"] == 'ALFAMART' ||
                            //     allItem[i]["kode_pembayaran"] ==
                            //         'VIRTUAL ACCOUNT')
                            //   Navigator.of(context).push(MaterialPageRoute(
                            //       builder: (context) =>
                            //           DetailAlfamart(data: allItem[i])));
                            // allItem[i]["wrkirim"] == null &&
                            //         allItem[i]["kode_pembayaran"] != 'ALFAMART'
                            //     ? Navigator.of(context).push(MaterialPageRoute(
                            //         builder: (context) =>
                            //             DetailDeposit(data: allItem[i])))
                            //     : allItem[i]["kode_pembayaran"] != 'QRISPAY'
                            //         ? cekUrl(allItem[i]['wrkirim'], allItem[i])
                            //         // ignore: unnecessary_statements
                            //         : null;
                          },
                          child: CardDeposit(data: allItem[i]));
                    }));
  }
}
