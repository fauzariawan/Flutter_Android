import 'package:android/component.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'dart:convert';
import 'package:localstorage/localstorage.dart';
import '../dashboard.dart';

class GantiPin extends StatefulWidget {
  @override
  _GantiPinState createState() => _GantiPinState();
}

class _GantiPinState extends State<GantiPin> {
  LocalStorage storage = new LocalStorage('localstorage_app');
  TextEditingController pinLama = new TextEditingController();
  TextEditingController pinBaru = new TextEditingController();
  TextEditingController ulangiPinBaru = new TextEditingController();
  bool _obscureText = true;
  dynamic respon;
  List listRespon;
  final _formInput = GlobalKey<FormState>();

  _simpan() async {
    LoadingShowDialog.loading(context);
    if (pinBaru.text != ulangiPinBaru.text) {
      ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
        content: Text('Cek Password Baru Anda'),
      ));
    } else {
      final baseUrl = DotEnv.env['BASE_URL'];
      final path = 'inbox/resetpin';
      final params = null;
      final url = Uri.http(baseUrl, path, params);
      debugPrint(url.toString());

      var response = await http.post(url, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "token": storage.getItem('token')
      }, body: {
        "oldpin": pinLama.text,
        "newpin": pinBaru.text,
        "ulangipinbaru": ulangiPinBaru.text
      });

      if (response.statusCode == 200) {
        Navigator.pop(context);
        respon = json.decode(response.body);
        listRespon = respon['pesan'].split('.');
        ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
          content: Text(listRespon[0]),
        ));
        pinLama.text = '';
        pinBaru.text = '';
        ulangiPinBaru.text = '';
      } else {
        Navigator.pop(context);
        respon = json.decode(response.body);
        listRespon = respon['pesan'].split('.');
        ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
          content: Text(listRespon[0]),
        ));
      }
    }
  }

  _showHidePass() {
    setState(() {
      if (_obscureText) {
        _obscureText = false;
      } else {
        _obscureText = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Dashboard()));
                },
                child: Center(
                  child: Center(
                    child: Text(
                      'Ganti Pin',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Form(
              key: _formInput,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Input(
                      title: 'PIN Lama',
                      controller: pinLama,
                      scureText: _obscureText,
                    ),
                    SizedBox(height: 10),
                    Input(
                      title: 'PIN Baru',
                      controller: pinBaru,
                      scureText: _obscureText,
                    ),
                    SizedBox(height: 10),
                    Input(
                      title: 'Ulangi PIN Baru',
                      controller: ulangiPinBaru,
                      scureText: _obscureText,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          _showHidePass();
                        },
                        child: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          semanticLabel:
                              _obscureText ? 'show password' : 'hide password',
                        ))
                  ],
                ),
              ),
            ),
            Positioned(
                bottom: 10,
                right: 10,
                child: ElevatedButton(
                    onPressed: () {
                      if (_formInput.currentState.validate()) {
                        _simpan();
                      }
                    },
                    child: Text('Simpan')))
          ],
        ));
  }
}

class Input extends StatelessWidget {
  Input({this.title, this.controller, this.showHide, this.scureText});
  final String title;
  final TextEditingController controller;
  final Function showHide;
  final bool scureText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: (controller) {
        print(controller);
      },
      validator: (controller) {
        if (controller.length < 6) {
          return 'Harus Enam Angka';
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.number,
      obscureText: scureText,
      maxLength: 6,
      decoration: InputDecoration(
        labelText: title,
        border: OutlineInputBorder(),
        // suffixIcon: GestureDetector(
        //   onTap: () {
        //     showHide();
        //   },
        //   child: Icon(
        //     scureText ? Icons.visibility_off : Icons.visibility,
        //     semanticLabel: scureText ? 'show password' : 'hide password',
        //   ),
        // ),
      ),
    );
  }
}
