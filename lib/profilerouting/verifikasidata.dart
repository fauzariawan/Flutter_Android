import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:localstorage/localstorage.dart';
// import 'package:jwt_decode/jwt_decode.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../component.dart';
import '../listWarna.dart';
// import '../profile.dart';
import '../routerName.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

class VerifikasiData extends StatefulWidget {
  @override
  _VerifikasiDataState createState() => _VerifikasiDataState();
}

class _VerifikasiDataState extends State<VerifikasiData> {
  final LocalStorage storage = new LocalStorage('localstorage_app');
  final _formVerifikasiDataKey = GlobalKey<FormState>();
  TextEditingController nik = TextEditingController();
  File fotoKtp;
  File fotoSelfie;
  bool haveFotoKtp = false;
  bool haveSelfie = false;
  String token;
  bool isLoading = true;
  bool fokus = false;

  // Dio dio = new Dio(); // untuk upload file
  final picker = ImagePicker();

  Future getFotoKtp() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        fotoKtp = File(pickedFile.path);
        haveFotoKtp = true;
      } else {
        print('No Image Selected!!');
      }
    });
  }

  Future getFotoSelfie() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        fotoSelfie = File(pickedFile.path);
        print(fotoSelfie);
        haveSelfie = true;
      } else {
        print('No Image Selected!!');
      }
    });
  }

  loading() {
    showDialog(
        barrierDismissible: false,
        context: this.context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white.withOpacity(0),
            content: Container(
                height: 100,
                child: Center(
                  child: SpinKitWave(
                    color: Warna.warna(biru),
                  ),
                )),
          );
        });
  }

  upload(File fotoKtp, File fotoSelfie, String nik) async {
    loading();
    if (fotoKtp == null || fotoSelfie == null) {
      ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
        content: Text('Foto KTP dan Foto Selfie Harus diisi '),
      ));
    } else {
      var stream = new http.ByteStream(fotoKtp.openRead());
      stream.cast();
      var stream2 = new http.ByteStream(fotoSelfie.openRead());
      stream2.cast();

      // get file length
      var length = await fotoKtp.length();
      var length2 = await fotoSelfie.length();

      // string to uri
      var uri = Uri.parse(
          "http://${DotEnv.env['BASE_URL']}/reseller/verifikasidata?nik=$nik&token=${storage.getItem('token')}");

      // create multipart request
      var request = new http.MultipartRequest("POST", uri);

      // memasukkan file2 yang mau di kirim
      var foto1 = new http.MultipartFile('files', stream, length,
          filename: basename(fotoKtp.path));
      var foto2 = new http.MultipartFile('files', stream2, length2,
          filename: basename(fotoSelfie.path));

      // add file to multipart
      request.files.add(foto1);
      request.files.add(foto2);

      // send
      debugPrint(uri.toString());
      var response = await request.send();
      if (response.statusCode == 200) {
        response.stream.transform(utf8.decoder).listen((value) {
          print(value);
          if (value == "1") {
            print('Data Berhasil di Update');
            print(value);
            Navigator.pop(this.context);
            ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
                duration: Duration(milliseconds: 2000),
                content: Container(
                  child: Text('Data Berhasil Di Update'),
                )));
            Future.delayed(Duration(seconds: 2),
                () => {Navigator.popAndPushNamed(this.context, profile)});
            // Future.delayed(
            //     Duration(seconds: 2),
            //     () => {

            //           Navigator.of(this.context).push(
            //               MaterialPageRoute(builder: (context) => Profile()))
            //         });
          } else {
            Navigator.pop(this.context);
            ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
              content: Text('NIK Sudah Digunakan'),
            ));
          }
        });
      }
    }
  }

  // cekKtp(File fotoKtp, File fotoSelfie, String nik) async {
  //   loading();
  //   final baseUrl = DotEnv.env['BASE_URL'];
  //   final path = 'reseller/cekKtp';
  //   final params = null;
  //   final url = Uri.http(baseUrl, path, params);
  //   debugPrint(url.toString());

  //   var response = await http.post(url, headers: {
  //     "Content-Type": "application/x-www-form-urlencoded",
  //     "token": storage.getItem('token')
  //   }, body: {
  //     "nomorKtp": nik
  //   });

  //   if (response.statusCode == 200) {
  //     dynamic res = json.decode(response.body);
  //     if (res['status'] == true) {
  //       Navigator.pop(this.context);
  //       ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
  //         content: Text('NIK Sudah Digunakan'),
  //       ));
  //     } else {
  //       print('nik belum ada silahkan lanjut ke upload');
  //       upload(fotoKtp, fotoSelfie, nik);
  //     }
  //   } else {
  //     print("ini response dari server selain status 200");
  //     print(response.statusCode);
  //     print(response.body);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VERIFIKASI IDENTITAS'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
        child: Column(
          children: <Widget>[
            Form(
                key: _formVerifikasiDataKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      keyboardType: TextInputType.number,
                      autofocus: fokus,
                      controller: nik,
                      validator: (nik) {
                        if (nik.isEmpty) {
                          return 'NIK Harus Diisi';
                        } else {
                          if (nik.length < 16) {
                            return ' NIK yang anda masukkan kurang';
                          } else {
                            return null;
                          }
                        }
                      },
                      maxLength: 16,
                      decoration: InputDecoration(
                          labelText: 'NIK',
                          labelStyle: TextStyle(fontSize: 25.0),
                          helperText: 'Isi dengan Nomor KTP',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.verified_user)),
                    ),
                  ],
                )),
            Expanded(
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: () {
                      getFotoKtp();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        height: 300.0,
                        color: Warna.warna(biru),
                        child: Center(
                          child: haveFotoKtp
                              ? Image.file(fotoKtp)
                              : Text('Foto KTP',
                                  style: TextStyle(color: Warna.warna(kuning))),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      getFotoSelfie();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        height: 300.0,
                        color: Warna.warna(biru),
                        child: Center(
                          child: haveSelfie
                              ? Image.file(fotoSelfie)
                              : Text('Foto Selfie dengan KTP',
                                  style: TextStyle(color: Warna.warna(kuning))),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_formVerifikasiDataKey.currentState.validate()) {
                          // upload(fotoKtp, fotoSelfie, nik.text);
                          upload(fotoKtp, fotoSelfie, nik.text);
                        }
                      },
                      child: Text('KIRIM DATA'))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
