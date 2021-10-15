// import 'package:android/loadingloginpage.dart';
import 'package:android/main.dart';
import 'package:android/profilerouting/customerservice.dart';
import 'package:android/register.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_udid/flutter_udid.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:localstorage/localstorage.dart'; // untuk menyimpan data dilocalstorage
// import 'package:minimize_app/minimize_app.dart';
import 'component.dart';
import 'listWarna.dart';
import 'lupaPin.dart';
// import 'menuutama/paketData.dart';
// import 'menuutama/subPaketData/dataInjek.dart';
// import 'menuutama/telpDanSms.dart';
// import 'register.dart';
// import 'dashboard.dart';
import 'pilihMethodOtp.dart';
// import './profilerouting/rewards.dart';
// import './profilerouting/customerservice.dart';
// import './profilerouting/gantipin.dart';
// import './profilerouting/ubahtoko.dart';
// import './profilerouting/tentangaplikasi.dart';
// import './profilerouting/perbaruikonten.dart';
// import './profilerouting/keluar.dart';
// import './profilerouting/withdrawsaldo.dart';
// import './menuutama/operatorPromo.dart';
// import './menuutama/pln.dart';
// import 'router.dart';
import 'package:permission_handler/permission_handler.dart'; // untuk access phone contact
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  Login({this.countdown});
  final bool countdown;
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    _askPermissions(null); // untuk access phone contact
    isCountdown = widget.countdown ?? false;
    initPlatformState();
    super.initState();
  }

  // untuk access phone contact
  Future<void> _askPermissions(String routeName) async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      if (routeName != null) {
        Navigator.of(context).pushNamed(routeName);
      }
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  // untuk access phone contact
  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  // // untuk access phone contact
  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      final snackBar = SnackBar(content: Text('Access to contact data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      final snackBar =
          SnackBar(content: Text('Contact data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  final LocalStorage storage = new LocalStorage('localstorage_app');
  TextEditingController notelp = new TextEditingController();
  TextEditingController password = new TextEditingController();
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 10;
  bool isChecked = false;
  bool _obscureText = true;
  bool isLoading = false;
  bool isCountdown = false;
  String _udid = 'Unknown';

  void onEnd() {
    setState(() {
      isCountdown = false;
    });
  }

  Future<void> initPlatformState() async {
    String udid;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      udid = await FlutterUdid.udid;
    } on PlatformException {
      udid = 'Failed to get UDID.';
    }
    if (!mounted) return;
    setState(() {
      _udid = udid;
      prefs.setString("device_id", _udid);
    });
  }

  _login() async {
    final _baseUrl = DotEnv.env['BASE_URL'];
    final _path = "reseller/signin";
    final _params = null; // {"key":"value"}
    final _uri = Uri.http(_baseUrl, _path, _params);
    debugPrint(
        _uri.toString()); // untuk ngecek url nya udah pas sesuai tujuan ato blm

    var response = await http.post(_uri,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {"notelp": notelp.text, "pin": password.text, "deviceId": _udid});
    if (response.statusCode == 200) {
      print(response.body);
      dynamic data = json.decode(response.body);
      if (data['rc'] == '03') {
        setState(() {
          isLoading = false;
        });
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Akun Anda Diblokir'),
                actions: <Widget>[
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CustomerService()));
                      },
                      child: Text('Hubungi CS')),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('No'))
                ],
              );
            });
      } else if (data['rc'] == '04') {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Login(countdown: true)));
      } else {
        storage.setItem(
            'token',
            response
                .body); // menyimpan data agar bisa diakses diseluruh halaman
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => PilihMethodOtp()));
        setState(() {
          isLoading = false;
        });
      }
    } else if (response.statusCode == 500) {
      setState(() {
        isLoading = false;
      });
      dynamic data = json.decode(response.body);
      if (data['rc'] == '05') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(milliseconds: 2000),
            content: Container(
              child: Text(data['pesan']),
            )));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(milliseconds: 2000),
            content: Container(
              child: Text(data['pesan'][0]),
            )));
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

  Future<bool> _back() {
    if (isCountdown == true) {
      return null;
    } else {
      return Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  final _formLoginKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _back,
      child: new Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //       begin: Alignment.topCenter,
          //       end: Alignment.bottomCenter,
          //       colors: [
          //         Warna.warna(kuning),
          //         Warna.warna(biru),
          //       ]),
          // ),
          child: Stack(
            children: [
              Container(
                height: 300,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('image/wellcome.png'),
                    fit: BoxFit.fill,
                  ),
                  // shape: BoxShape.circle,
                ),
              ),
              Positioned(
                top: 200,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: Container(
                      width: MediaQuery.of(context).size.width - 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 5,
                                offset: Offset(0, 5))
                          ]),
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 20, bottom: 10),
                        child: Form(
                          key: _formLoginKey,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                controller: notelp,
                                validator: (notelp) {
                                  if (notelp.isEmpty) {
                                    return 'Nomor Telp Harus Diisi';
                                  } else {
                                    return null;
                                  }
                                },
                                maxLength: 13,
                                style: TextStyle(fontSize: 20),
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    labelText: 'Nomer Handphone',
                                    fillColor: Colors.grey,
                                    border: OutlineInputBorder(
                                        gapPadding: 0,
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    counterText: ''),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                controller: password,
                                validator: (password) {
                                  if (password.isEmpty) {
                                    return 'Password Harus Diisi';
                                  } else {
                                    return null;
                                  }
                                },
                                obscureText: _obscureText,
                                style: TextStyle(fontSize: 20),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  labelText: 'Pin',
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      _showHidePass();
                                    },
                                    child: Icon(
                                      _obscureText
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      semanticLabel: _obscureText
                                          ? 'show password'
                                          : 'hide password',
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              isCountdown
                                  ? Container(
                                      padding: EdgeInsets.all(10),
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        children: [
                                          Text('Ingat-ingat dulu akunnya OM..'),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          CountdownTimer(
                                            endTime: endTime,
                                            onEnd: onEnd,
                                            textStyle: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                color: Warna.warna(biru)),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: isLoading
                                          ? Center(
                                              child: SpinKitWave(
                                                color: Warna.warna(biru),
                                                size: 20,
                                              ),
                                            )
                                          : ElevatedButton(
                                              style: ButtonStyle(
                                                elevation:
                                                    MaterialStateProperty.all(
                                                        10),
                                                padding:
                                                    MaterialStateProperty.all(
                                                        EdgeInsets.all(0)),
                                                shape:
                                                    MaterialStateProperty.all(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30.0))),
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Warna.warna(biru),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  // gradient: LinearGradient(
                                                  //     begin: Alignment.topLeft,
                                                  //     end: Alignment.bottomRight,
                                                  //     colors: [
                                                  //       Warna.warna(biru),
                                                  //       Warna.warna(kuning),
                                                  //       // Colors.yellow,
                                                  //     ])
                                                ),
                                                height: 60.0,
                                                child: Center(
                                                  child: Text('LOGIN',
                                                      style: TextStyle(
                                                          fontSize: 20.0,
                                                          color: Colors.white)),
                                                ),
                                              ),
                                              onPressed: () {
                                                if (_formLoginKey.currentState
                                                    .validate()) {
                                                  setState(() {
                                                    isLoading = true;
                                                  });
                                                  _login();
                                                }
                                              }),
                                    ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => LupaPin()));
                                  },
                                  child: Text('Lupa Pin ?',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('Tidak Punya Akun ? ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) => Register(
                                                      kodeReseller: null,
                                                    )));
                                      },
                                      child: Text('Daftar',
                                          style: TextStyle(
                                              color: Warna.warna(biru),
                                              fontWeight: FontWeight.bold)),
                                    )
                                  ],
                                ),
                              )
                              // ElevatedButton(
                              //     onPressed: () {},
                              //     style: ButtonStyle(
                              //         elevation: MaterialStateProperty.all(10),
                              //         backgroundColor: MaterialStateProperty.all(
                              //             Warna.warna(biru))),
                              //     child: Text('Lupa Pin ?',
                              //         style: TextStyle(color: Colors.white))),
                            ],
                          ),
                        ),
                      ),
                    ))),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// keterangan respon
// rc:05 koneksi database gagal

// tombol login
// isCountdown
//                       ? Container(
//                           padding: EdgeInsets.all(10),
//                           width: MediaQuery.of(context).size.width,
//                           child: Column(
//                             children: [
//                               Text('Ingat-ingat dulu akunnya OM..'),
//                               SizedBox(
//                                 height: 10,
//                               ),
//                               CountdownTimer(
//                                 endTime: endTime,
//                                 onEnd: onEnd,
//                                 textStyle: TextStyle(
//                                     fontSize: 25,
//                                     fontWeight: FontWeight.bold,
//                                     color: Warna.warna(kuning)),
//                               ),
//                             ],
//                           ),
//                         )
//                       : Padding(
//                           padding: const EdgeInsets.all(20.0),
//                           child: isLoading
//                               ? Container(
//                                   height: 100,
//                                   child: Center(
//                                     child: SpinKitWave(
//                                       color: Warna.warna(kuning),
//                                       size: 20,
//                                     ),
//                                   ))
//                               : ElevatedButton(
//                                   style: ButtonStyle(
//                                     elevation: MaterialStateProperty.all(10),
//                                     padding: MaterialStateProperty.all(
//                                         EdgeInsets.all(0)),
//                                     shape: MaterialStateProperty.all(
//                                         RoundedRectangleBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(18.0))),
//                                   ),
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(10),
//                                         gradient: LinearGradient(
//                                             begin: Alignment.topLeft,
//                                             end: Alignment.bottomRight,
//                                             colors: [
//                                               Warna.warna(biru),
//                                               Warna.warna(kuning),
//                                               // Colors.yellow,
//                                             ])),
//                                     height: 60.0,
//                                     child: Center(
//                                       child: Text('LOGIN',
//                                           style: TextStyle(
//                                               fontSize: 20.0,
//                                               color: Colors.white)),
//                                     ),
//                                   ),
//                                   onPressed: () {
//                                     if (_formLoginKey.currentState.validate()) {
//                                       setState(() {
//                                         isLoading = true;
//                                       });
//                                       _login();
//                                     }
//                                   }),
//                         ),

// tombol register
// ElevatedButton(
//                           onPressed: () {
//                             storage.clear();
//                             isChecked
//                                 ? Navigator.of(context).pushNamed('/register')
//                                 : ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                         content: Text(
//                                             'Ceklist Term Use Apabila Anda Sudah Membaca dan Memahaminya untuk melanjutkan registrasi')));
//                           },
//                           style: ButtonStyle(
//                               elevation: MaterialStateProperty.all(10),
//                               backgroundColor: MaterialStateProperty.all(
//                                   Warna.warna(kuning))),
//                           child: Text('Register Here !!',
//                               style: TextStyle(color: Colors.white))),

// term use
// SizedBox(height: 20),
//               CheckboxListTile(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(50)),
//                   activeColor: Warna.warna(0xFFffc947),
//                   tileColor: Colors.indigo[300],
//                   title: Column(
//                     children: [
//                       Text('Saya Sudah Membaca dan Memahami'),
//                       GestureDetector(
//                           onTap: () {},
//                           child: Text('Term Use',
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold)))
//                     ],
//                   ),
//                   value: isChecked,
//                   onChanged: (bool value) {
//                     if (isChecked == false) {
//                       setState(() {
//                         isChecked = true;
//                       });
//                       print(isChecked);
//                     } else {
//                       setState(() {
//                         isChecked = false;
//                       });
//                       print(isChecked);
//                     }
//                   }),