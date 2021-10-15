import 'package:android/main.dart';
import 'package:android/profilerouting/downline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // untuk json.decode
import './wilayahindonesia/provinsi.dart';
import './wilayahindonesia/kabupaten.dart';
import './wilayahindonesia/kecamatan.dart';
import './wilayahindonesia/kelurahan.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

import 'component.dart';
import 'listWarna.dart';

class Register extends StatefulWidget {
  Register({this.kodeReseller});
  final String kodeReseller;
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController name = new TextEditingController();
  TextEditingController notelp = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController provinsi = new TextEditingController();
  TextEditingController kabupaten = new TextEditingController();
  TextEditingController kecamatan = new TextEditingController();
  TextEditingController kelurahan = new TextEditingController();
  TextEditingController kodeReferal = new TextEditingController();
  TextEditingController markup = new TextEditingController();
  final LocalStorage storage = new LocalStorage('localstorage_app');

  final _formRegisterKey = GlobalKey<FormState>(); // untuk validasi setiap form
  Map data;
  bool isChecked = false;
  bool isLoading = false;
  List<dynamic> allProvinsi;
  List<dynamic> allKabupaten;
  List<dynamic> allKecamatan;
  List<dynamic> allKelurahan;

  void initState() {
    super.initState();
    widget.kodeReseller == null ? isChecked = false : isChecked = true;
    name = TextEditingController(
        text: storage.getItem('name') == null
            ? name.text
            : storage.getItem('name'));
    notelp = TextEditingController(
        text: storage.getItem('notelp') == null
            ? notelp.text
            : storage.getItem('notelp'));
    email = TextEditingController(
        text: storage.getItem('email') == null
            ? email.text
            : storage.getItem('email'));
    address = TextEditingController(
        text: storage.getItem('address') == null
            ? address.text
            : storage.getItem('address'));
    provinsi = TextEditingController(text: storage.getItem('provinsi'));
    kabupaten = TextEditingController(text: storage.getItem('kabupaten'));
    kecamatan = TextEditingController(text: storage.getItem('kecamatan'));
    kelurahan = TextEditingController(text: storage.getItem('kelurahan'));
    widget.kodeReseller == null
        ? kodeReferal = TextEditingController(
            text: storage.getItem('kodeReferal') == null
                ? kodeReferal.text
                : storage.getItem('kodeReferal'))
        : kodeReferal = TextEditingController(text: widget.kodeReseller);
  }

  cekData() {
    showDialog(
        useSafeArea: true,
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: Text(
              'Apakah Data Anda Sudah Benar!!!',
              style: TextStyle(fontSize: 15.0),
            ),
            content: Container(
              height: 350,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Nama",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                  ),
                  Text(name.text, style: TextStyle(fontSize: 13.0)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "No. Telp",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                  ),
                  Text(notelp.text, style: TextStyle(fontSize: 13.0)),
                  SizedBox(
                    height: 10,
                  ),
                  // Text(
                  //   "Email",
                  //   style:
                  //       TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                  // ),
                  // Text(email.text, style: TextStyle(fontSize: 13.0)),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  Text(
                    "Address",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                  ),
                  Text(address.text, style: TextStyle(fontSize: 13.0)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Provinsi",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                  ),
                  Text(provinsi.text, style: TextStyle(fontSize: 13.0)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Kabupaten",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                  ),
                  Text(kabupaten.text, style: TextStyle(fontSize: 13.0)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Kecamatan",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                  ),
                  Text(kecamatan.text, style: TextStyle(fontSize: 13.0)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Kelurahan",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                  ),
                  Text(kelurahan.text, style: TextStyle(fontSize: 13.0)),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    // Navigator.pop(context);
                    _register();
                  },
                  child: Text('yes')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('No')),
            ],
          );
        });
  }

  loading() {
    showDialog(
        barrierDismissible: false,
        context: this.context,
        builder: (BuildContext context) {
          return Container(
              height: 100,
              child: Center(
                child: SpinKitWave(
                  color: Warna.warna(biru),
                ),
              ));
        });
  }

  _register() async {
    loading();
    final _baseUrl = DotEnv.env['BASE_URL'];
    final _path = "/inbox/register";
    final _params = null; //{"q": "dart"}; /* untuk query */
    final _uri = Uri.http(_baseUrl, _path, _params);
    debugPrint(_uri.toString());
    String fullAddress =
        '${address.text}_${kelurahan.text}_${kecamatan.text}_${kabupaten.text}_${provinsi.text}';
    print(fullAddress);
    var response = await http.post(_uri, headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "name": name.text,
      "notelp": notelp.text,
      "email": email.text,
      "password": password.text,
      "address": fullAddress,
      "mp": markup.text ?? null,
      "kodeReferal": isChecked ? kodeReferal.text : '0'
    });
    if (response.statusCode == 200) {
      Navigator.pop(context);
      data = json.decode(response.body);
      if (data['kode'] == '00') {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Center(child: Text('Info')),
                  content: Container(
                      height: 100.0,
                      alignment: Alignment.center,
                      child: widget.kodeReseller == null
                          ? Column(
                              children: <Widget>[
                                Text('${name.text} Berhasil Registrasi !!!'),
                                Text('Tunggu SMS dari Funmo Untuk Mendapatkan PIN'),
                                Text('Silahkan Lanjut ke Login')
                              ],
                            )
                          : Text(
                              '${name.text} Berhasil Menjadi Downline Anda !!!')));
            });
        Future.delayed(
            const Duration(milliseconds: 2000),
            () => {
                  storage.deleteItem('name'),
                  storage.deleteItem('notelp'),
                  storage.deleteItem('email'),
                  storage.deleteItem('address'),
                  storage.deleteItem('password'),
                  storage.deleteItem('IdProvinsi'),
                  storage.deleteItem('provinsi'),
                  storage.deleteItem('IdKabupaten'),
                  storage.deleteItem('kabupaten'),
                  storage.deleteItem('kecamatan'),
                  storage.deleteItem('IdKecamatan'),
                  storage.deleteItem('kelurahan'),
                  storage.deleteItem('IdKelurahan'),
                  widget.kodeReseller == null
                      ? Navigator.popAndPushNamed(context, '/login')
                      : Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Downline()))
                });
      } else {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Center(child: Text('Info')),
                  content: Container(
                      height: 100.0,
                      alignment: Alignment.center,
                      child: Text(data['pesan'])));
            });
      }
    } else if (response.statusCode == 500) {
      Navigator.pop(context);
      var data = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(milliseconds: 2000),
          content: Container(
            height: 50.0,
            child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, i) {
                  return Text(
                    '${data[i]}',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                  );
                }),
          )));
    }
  }

  _getAllProvinsi() async {
    final _baseUrl = DotEnv.env['BASE_URL'];
    final _path = '/wilayahIndonesia/provinsi';
    final _params = null;
    final _uri = Uri.http(_baseUrl, _path, _params);
    debugPrint(_uri.toString());

    var response = await http.get(_uri);

    if (response.statusCode == 200) {
      allProvinsi = json.decode(response.body);
      storage.setItem('allProvinsi', allProvinsi);
      String setName = name.text;
      storage.setItem('name', setName);
      String setNotelp = notelp.text;
      storage.setItem('notelp', setNotelp);
      String setEmail = email.text;
      storage.setItem('email', setEmail);
      String setAddress = address.text;
      storage.setItem('address', setAddress);
      String setPassword = password.text;
      storage.setItem('password', setPassword);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Provinsi(kodeReseller: widget.kodeReseller)));
    } else {
      print('gagal');
    }
  }

  _getAllKabupaten() async {
    if (storage.getItem('IdProvinsi') == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(milliseconds: 2000),
          content: Container(
            child: Text('Isi Terlebih Dahulu Field Provinsi'),
          )));
    } else {
      final _baseUrl = DotEnv.env['BASE_URL'];
      final _path = '/wilayahIndonesia/kabupaten';
      final _params = null;
      final _uri = Uri.http(_baseUrl, _path, _params);
      debugPrint(_uri.toString());
      var response = await http.post(_uri,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          body: {"idProvinsi": storage.getItem("IdProvinsi")});
      if (response.statusCode == 200) {
        allKabupaten = json.decode(response.body);
        storage.setItem('allKabupaten', allKabupaten);
        String setName = name.text;
        storage.setItem('name', setName);
        String setNotelp = notelp.text;
        storage.setItem('notelp', setNotelp);
        String setEmail = email.text;
        storage.setItem('email', setEmail);
        String setAddress = address.text;
        storage.setItem('address', setAddress);
        String setPassword = password.text;
        storage.setItem('password', setPassword);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                Kabupaten(kodeReseller: widget.kodeReseller)));
      } else {
        print('gagal');
      }
    }
  }

  _getAllKecamatan() async {
    if (storage.getItem('IdKabupaten') == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(milliseconds: 2000),
          content: Container(
            child: Text('Isi Terlebih Dahulu Field Kabupaten'),
          )));
    } else {
      final _baseUrl = DotEnv.env['BASE_URL'];
      final _path = '/wilayahIndonesia/kecamatan';
      final _params = null;
      final _uri = Uri.http(_baseUrl, _path, _params);
      debugPrint(_uri.toString());
      var response = await http.post(_uri,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          body: {"idKabupaten": storage.getItem("IdKabupaten")});
      if (response.statusCode == 200) {
        allKecamatan = json.decode(response.body);
        storage.setItem('allKecamatan', allKecamatan);
        String setName = name.text;
        storage.setItem('name', setName);
        String setNotelp = notelp.text;
        storage.setItem('notelp', setNotelp);
        String setEmail = email.text;
        storage.setItem('email', setEmail);
        String setAddress = address.text;
        storage.setItem('address', setAddress);
        String setPassword = password.text;
        storage.setItem('password', setPassword);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                Kecamatan(kodeReseller: widget.kodeReseller)));
      } else {
        print('gagal');
      }
    }
  }

  _getAllKelurahan() async {
    if (storage.getItem('IdKecamatan') == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(milliseconds: 2000),
          content: Container(
            child: Text('Isi Terlebih Dahulu Field Kecamatan'),
          )));
    } else {
      final _baseUrl = DotEnv.env['BASE_URL'];
      final _path = '/wilayahIndonesia/kelurahan';
      final _params = null;
      final _uri = Uri.http(_baseUrl, _path, _params);
      debugPrint(_uri.toString());
      var response = await http.post(_uri,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          body: {"idKecamatan": storage.getItem("IdKecamatan")});
      if (response.statusCode == 200) {
        allKelurahan = json.decode(response.body);
        storage.setItem('allKelurahan', allKelurahan);
        String setName = name.text;
        storage.setItem('name', setName);
        String setNotelp = notelp.text;
        storage.setItem('notelp', setNotelp);
        String setEmail = email.text;
        storage.setItem('email', setEmail);
        String setAddress = address.text;
        storage.setItem('address', setAddress);
        String setPassword = password.text;
        storage.setItem('password', setPassword);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                Kelurahan(kodeReseller: widget.kodeReseller)));
      } else {
        print('gagal');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        widget.kodeReseller == null
            ? Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => HomePage()))
            : Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Downline()));
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: widget.kodeReseller == null
              ? Text(
                  'REGISTRASI',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              : Text(
                  'REGISTRASI DOWNLINE',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue[100],
                  Colors.blue[400],
                ]),
          ),
          child: Stack(
            children: [
              Matahari(
                  top: -50,
                  right: -50,
                  height: 200,
                  width: 200,
                  color: Colors.yellow),
              Matahari(
                  bottom: -50,
                  left: -50,
                  height: 200,
                  width: 200,
                  color: Colors.white),
              Matahari(
                  top: 100,
                  left: 50,
                  height: 30,
                  width: 30,
                  color: Colors.white),
              Matahari(
                  top: 250,
                  left: 100,
                  height: 50,
                  width: 50,
                  color: Colors.yellow),
              Matahari(
                  bottom: 200,
                  right: 100,
                  height: 40,
                  width: 40,
                  color: Colors.white),
              Form(
                key: _formRegisterKey,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(19.0),
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: name,
                              onChanged: (name) {
                                storage.deleteItem('name');
                              },
                              validator: (name) {
                                if (name.isEmpty) {
                                  return 'Name Harus Diisi';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                fillColor: Colors.green[500],
                                labelText: 'Nama',
                                labelStyle: TextStyle(
                                  fontSize: 25.0,
                                ),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20.0),
                            ),
                            TextFormField(
                              controller: notelp,
                              validator: (notelp) {
                                if (notelp.isEmpty) {
                                  return 'No Telp Harus Diisi';
                                } else {
                                  return null;
                                }
                              },
                              maxLength: 13,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')), //ini juga bisa
                                // FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  labelText: 'No Telp',
                                  labelStyle: TextStyle(fontSize: 25.0),
                                  border: OutlineInputBorder(),
                                  counterText: ''),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20.0),
                            ),
                            // TextFormField(
                            //   controller: email,
                            //   onChanged: (email) {
                            //     storage.deleteItem('email');
                            //   },
                            //   validator: (email) {
                            //     if (email.isEmpty) {
                            //       return 'Email Harus Diisi';
                            //     } else {
                            //       return null;
                            //     }
                            //   },
                            //   decoration: InputDecoration(
                            //     labelText: 'E-mail',
                            //     labelStyle: TextStyle(fontSize: 25.0),
                            //     border: OutlineInputBorder(),
                            //   ),
                            // ),
                            // Padding(
                            //   padding: EdgeInsets.only(top: 20.0),
                            // ),
                            TextFormField(
                              controller: address,
                              onChanged: (address) {
                                storage.deleteItem('address');
                                var regExp = new RegExp(r'[^a-z,A-Z, ,0-9,]');
                                address = address.replaceAll(regExp, '');
                                print(address);
                              },
                              validator: (address) {
                                if (address.isEmpty) {
                                  return 'Address Harus Diisi';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'Alamat',
                                labelStyle: TextStyle(fontSize: 25.0),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20.0),
                            ),
                            TextFormField(
                              onTap: () {
                                _getAllProvinsi();
                              },
                              readOnly:
                                  true, // mencegah agar keyboar tidak muncul
                              controller: provinsi,
                              validator: (provinsi) {
                                if (provinsi.isEmpty) {
                                  return 'Provinsi Harus Diisi';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'Provinsi',
                                labelStyle: TextStyle(fontSize: 25.0),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20.0),
                            ),
                            TextFormField(
                              onTap: () {
                                _getAllKabupaten();
                              },
                              readOnly:
                                  true, // mencegah agar keyboar tidak muncul
                              controller: kabupaten,
                              validator: (kabupaten) {
                                if (kabupaten.isEmpty) {
                                  return 'Kabupaten/Kota Harus Diisi';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'Kabupaten/Kota',
                                labelStyle: TextStyle(fontSize: 25.0),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20.0),
                            ),
                            TextFormField(
                              onTap: () {
                                _getAllKecamatan();
                              },
                              readOnly:
                                  true, // mencegah agar keyboar tidak muncul
                              controller: kecamatan,
                              validator: (kecamatan) {
                                if (kecamatan.isEmpty) {
                                  return 'Kecamatan Harus Diisi';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'Kecamatan',
                                labelStyle: TextStyle(fontSize: 25.0),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20.0),
                            ),
                            TextFormField(
                              onTap: () {
                                _getAllKelurahan();
                              },
                              readOnly:
                                  true, // mencegah agar keyboar tidak muncul
                              controller: kelurahan,
                              validator: (kelurahan) {
                                if (kelurahan.isEmpty) {
                                  return 'Kelurahan Harus Diisi';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'Kelurahan',
                                labelStyle: TextStyle(fontSize: 25.0),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20.0),
                            ),
                            // TextFormField(
                            //   controller: password,
                            //   validator: (password) {
                            //     if (password.isEmpty) {
                            //       return 'Password Harus Diisi';
                            //     } else {
                            //       return null;
                            //     }
                            //   },
                            //   // obscureText: true,
                            //   // obscuringCharacter: 'X',
                            //   inputFormatters: [
                            //     FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), //ini juga bisa
                            //     // FilteringTextInputFormatter.digitsOnly
                            //   ],
                            //   keyboardType: TextInputType.number,
                            //   decoration: InputDecoration(
                            //     labelText: 'Password',
                            //     labelStyle: TextStyle(fontSize: 25.0),
                            //     border: OutlineInputBorder(),
                            //   ),
                            // ),
                            // Padding(
                            //   padding: EdgeInsets.only(top: 20.0),
                            // ),
                            widget.kodeReseller != null
                                ? Column(
                                    children: <Widget>[
                                      TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: markup,
                                        validator: (markup) {
                                          if (markup.isEmpty) {
                                            return 'Markup Harus Diisi';
                                          } else {
                                            return null;
                                          }
                                        },
                                        inputFormatters: [
                                          // FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), //ini juga bisa
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        decoration: InputDecoration(
                                          labelText: 'Markup',
                                          labelStyle: TextStyle(fontSize: 25.0),
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      Container(
                                          margin: EdgeInsets.all(10),
                                          child: Text(
                                            'Upline Anda ${widget.kodeReseller}',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ))
                                    ],
                                  )
                                : Column(
                                    children: <Widget>[
                                      CheckboxListTile(
                                          activeColor: Warna.warna(kuning),
                                          checkColor: Warna.warna(biru),
                                          title: Text(
                                              'Apakah Anda Memiliki Kode Referal'),
                                          value: isChecked,
                                          onChanged: (bool value) {
                                            if (isChecked == false) {
                                              setState(() {
                                                isChecked = true;
                                              });
                                              print(isChecked);
                                            } else {
                                              setState(() {
                                                isChecked = false;
                                              });
                                              print(isChecked);
                                            }
                                          }),
                                      Padding(
                                        padding: EdgeInsets.only(top: 20.0),
                                      ),
                                      isChecked
                                          ? TextFormField(
                                              controller: kodeReferal,
                                              onChanged: (kodeReferal) {
                                                kodeReferal.toUpperCase();
                                              },
                                              validator: (kodeReferal) {
                                                if (kodeReferal.isEmpty) {
                                                  return 'Kode Referal Harus Diisi';
                                                } else {
                                                  return null;
                                                }
                                              },
                                              decoration: InputDecoration(
                                                labelText:
                                                    'Masukkan Kode Referal Anda',
                                                labelStyle:
                                                    TextStyle(fontSize: 25.0),
                                                border: OutlineInputBorder(),
                                              ),
                                            )
                                          : Container(),
                                      Padding(
                                        padding: EdgeInsets.only(top: 20.0),
                                      ),
                                    ],
                                  ),
                            ElevatedButton(
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.all(20)),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0))),
                                  backgroundColor: MaterialStateProperty.all(
                                      Warna.warna(biru))),
                              child: Center(
                                child: Text('REGISTER',
                                    style: TextStyle(
                                        fontSize: 20.0, color: Colors.white)),
                              ),
                              onPressed: () {
                                if (_formRegisterKey.currentState.validate()) {
                                  cekData();
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
