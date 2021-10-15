import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'component.dart';
import 'listWarna.dart';
import 'loadingloginpage.dart';
import 'main.dart';

class VerifikasiOtp extends StatefulWidget {
  VerifikasiOtp({this.method, this.kode});
  final String method;
  final int kode;
  @override
  _VerifikasiOtpState createState() => _VerifikasiOtpState();
}

class _VerifikasiOtpState extends State<VerifikasiOtp> {
  LocalStorage storage = new LocalStorage('localstorage_app');
  TextEditingController pin = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _response(String pesan) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Information'),
            content: Container(
              height: 100,
              child: Text(pesan),
            ),
          );
        });
  }

  complete() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => HomePage()));
  }

  confirmOtp(String otp) async {
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = 'reseller/confirmotp';
    final params = null;
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());

    var response = await http.post(url, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "token": storage.getItem('token')
    }, body: {
      "kode_otp": otp
    });

    if (response.statusCode == 200) {
      dynamic data = json.decode(response.body);
      storage.setItem('token', data['token']);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', data['token']);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoadingLoginPage()));
    } else if (response.statusCode == 500) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Information'),
              content: Text('YOU ARE NOT AUTHORIZED!!!'),
              actions: <Widget>[
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('try again')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    child: Text('exit'))
              ],
            );
          });
    } else if (response.statusCode == 401) {
      _response('Akun dan Device tidak sesuai hubungi CS Funmo');
      Timer(Duration(seconds: 3), complete);
    }
  }

  resetPin(String otp) async {
    LoadingShowDialog.loading(context);
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = 'inbox/forgetpin';
    final params = null;
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());

    var response = await http.post(url, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "token": storage.getItem('token')
    }, body: {
      "kode_otp": otp
    });

    if (response.statusCode == 200) {
      Navigator.pop(context);
      _response(
          'Pin Anda Berhasil di Reset, Kami Akan Mengirimkan PIN Baru melaui WA atau SMS');
      Timer(Duration(seconds: 3), complete);
    } else {
      Navigator.pop(context);
      _response('GAGAL Reset PIN');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            'Verifikasi OTP',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: Warna.warna(biru)),
          child: ListView(
            children: [
              Column(children: <Widget>[
                Stack(children: [
                  Container(
                    height: 300.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(150),
                            bottomLeft: Radius.circular(150)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.yellow[400],
                            offset: Offset(0, 5), //(x,y)
                            blurRadius: 10,
                          ),
                        ]),
                  ),
                  Container(
                      child: Center(
                    child: Column(
                      children: [
                        Image.asset("image/funmo/verifikasiOtp.png", width: 200)
                      ],
                    ),
                  )),
                  Container(
                    margin: EdgeInsets.only(top: 220),
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width < 300 ? 25 : 60,
                        right:
                            MediaQuery.of(context).size.width < 300 ? 25 : 60),
                    child: Text(
                      'Kami telah mengirimkan anda pesan ${widget.method} berupa kode OTP, silahkan masukkan 4 digit kode OTP untuk melanjutkan proses masuk',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 70),
                  child: PinCodeTextField(
                    pinTheme: PinTheme(
                      activeColor: Warna.warna(biru),
                      selectedColor: Warna.warna(
                          biru), // garis bawah untuk yang di selected
                      inactiveColor: Warna.warna(
                          biru), //  garis bawah untuk yang TIDAK di selected
                      disabledColor: Colors.black,
                      activeFillColor: Warna.warna(kuning),
                      selectedFillColor: Colors.white,
                      inactiveFillColor: Colors.grey,
                      // shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    cursorColor: Warna.warna(biru),
                    enableActiveFill: true,
                    keyboardType: TextInputType.number,
                    appContext: context,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    backgroundColor: Colors.transparent,
                    autoFocus: true,
                    controller: pin,
                    length: 4,
                    textStyle: const TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    onCompleted: (pin) {
                      widget.kode == null ? confirmOtp(pin) : resetPin(pin);
                    },
                    onChanged: (String value) {},
                  ),
                )
              ]),
            ],
          ),
        ));
  }
}
