import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:localstorage/localstorage.dart';
import 'verifikasiotp.dart';

class PilihMethodOtp extends StatefulWidget {
  @override
  _PilihMethodOtpState createState() => _PilihMethodOtpState();
}

class _PilihMethodOtpState extends State<PilihMethodOtp> {
  final LocalStorage storage = new LocalStorage('localstorage_app');

  kirimOtp(String method) async {
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = 'reseller/kirimotp';
    final params = null;
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());
    var response = await http.post(url, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "token": storage.getItem('token')
    }, body: {
      "method": method
    });

    if (response.statusCode == 200) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => VerifikasiOtp(method: method)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Pilih Methode',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Column(
            children: <Widget>[
              Stack(
                children: [
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
                        ]
                        ),
                  ),
                  Container(
                      child: Center(
                    child: Column(
                      children: [
                        Image.asset("image/funmo/pilihMetodefix.png",
                            width: 200)
                      ],
                    ),
                  )),
                  Container(
                    margin: EdgeInsets.only(top: 180),
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      'Kami akan mengirimkan anda 6 digit kode OTP untuk melanjutkan proses masuk, silahkan pilih salah satu metode untuk menerima kode OTP dari kami',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: ElevatedButton(
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(10),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white)),
                    onPressed: () {
                      kirimOtp('SMS');
                    },
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'image/funmo/sms.png',
                              width: 60,
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.all(10),
                              child: Text(
                                'SMS',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ))
                        ],
                      ),
                    )),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: ElevatedButton(
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(10),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white)),
                    onPressed: () {
                      kirimOtp('WA');
                    },
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'image/funmo/wa.png',
                              width: 60,
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.all(10),
                              child: Text(
                                'WA',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ))
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
