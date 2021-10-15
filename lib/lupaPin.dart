import 'dart:convert';

import 'package:android/verifikasiotp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

import 'component.dart';

class LupaPin extends StatefulWidget {
  @override
  _LupaPinState createState() => _LupaPinState();
}

class _LupaPinState extends State<LupaPin> {
  TextEditingController noTelp = new TextEditingController();
  LocalStorage storage = new LocalStorage('localstorage_app');
  dynamic dataUser;

  lupaPin() async {
    LoadingShowDialog.loading(context);
    final _baseUrl = DotEnv.env['BASE_URL'];
    final _path = "reseller/lupaPin";
    final _params = null; // {"key":"value"}
    final _uri = Uri.http(_baseUrl, _path, _params);
    debugPrint(
        _uri.toString()); // untuk ngecek url nya udah pas sesuai tujuan ato blm

    var response = await http.post(_uri,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {"noTelp": noTelp.text});

    if (response.statusCode == 200) {
      dataUser = json.decode(response.body);
      if (dataUser['rc'] == '03') {
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(dataUser['pesan'])));
      } else {
        Navigator.pop(context);
        storage.setItem(
            'token',
            response
                .body); // menyimpan data agar bisa diakses diseluruh halaman
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => VerifikasiOtp(kode: 1)));
      }
    } else {
      dataUser = json.decode(response.body);
      Navigator.pop(context);
      if (dataUser['rc'] == "05") {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(dataUser['pesan'])));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lupa PIN'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          margin: EdgeInsets.only(top: 50),
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Text(
                  'Kami akan mengirim kode verifikasi untuk memastikan bahwa nomor yang anda gunakan untuk login adalah milik anda',
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              TextFormField(
                controller: noTelp,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Nomor Hp', border: OutlineInputBorder()),
              ),
              ElevatedButton(
                  onPressed: () {
                    lupaPin();
                  },
                  child: Container(
                      height: 50,
                      child: Center(
                          child: Text('Kirim Kode',
                              style: TextStyle(fontSize: 20)))))
            ],
          ),
        ),
      ),
    );
  }
}
