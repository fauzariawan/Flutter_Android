import 'dart:async';
import 'dart:ui';
// import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../component.dart';
import '../dashboard.dart';
import '../listWarna.dart';
import './verifikasidata.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;

class ProfileDetail extends StatefulWidget {
  ProfileDetail({this.data});
  final dynamic data;

  @override
  _ProfileDetailState createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  LocalStorage storage = new LocalStorage('localstorage_app');
  TextEditingController namaPemilik = new TextEditingController();
  List data;
  String alamat;
  String kelurahan;
  String kecamatan;
  String kabupaten;
  String provinsi;
  int totalKomisi = 0;
  List<dynamic> allItem;
  void initState() {
    super.initState();
    // print(widget.data['alamat']);
    // print(widget.data['komisi']);
    print('ini reseller toko');
    print(widget.data['reseller_toko']);
    data = widget.data['alamat'].split('_');
    _totalKomisi();
  }

  _response(String pesan) {
    showDialog(
        barrierDismissible: false,
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

  _totalKomisi() {
    setState(() {
      allItem = widget.data['komisi'];
      allItem.forEach((dynamic item) {
        if (item['tukar'] == 1 && item['jumlah'] != null) {
        } else {
          totalKomisi = totalKomisi + item['jumlah'];
          // print(item['jumlah']);
        }
      });
    });
  }

  loading() {
    showDialog(
        // barrierDismissible: false,
        context: this.context,
        builder: (BuildContext context) {
          return Loading();
        });
  }

  complete() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Dashboard(selected: 0)));
  }

  editPemilik() async {
    loading();
    final _baseUrl = DotEnv.env['BASE_URL'];
    final _path = "/reseller/editPemilik";
    final _params = null; //{"q": "dart"}; /* untuk query */
    final _uri = Uri.http(_baseUrl, _path, _params);
    debugPrint(_uri.toString());

    var response = await http.post(_uri, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "token": storage.getItem('token')
    }, body: {
      "namaPemilik": namaPemilik.text,
    });
    if (response.statusCode == 200) {
      Navigator.pop(context);
      _response('Nama Pemilik BERHASIL Diupdate');
      Timer(Duration(seconds: 2), complete);
    } else {
      Navigator.pop(context);
      _response('GAGAL Update Nama Pemilik');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          // backgroundColor: Colors.blue,
          title: Text('Detail Profil'),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Stack(
                children: [
                  PangkatPendek(height: 80),
                  Center(
                      child: Icon(Icons.person,
                          size: 70, color: Warna.warna(kuning)))
                ],
              ),
              // Container(
              //   height: 100.0,
              //   margin: EdgeInsets.only(bottom: 20.0),
              //   decoration: BoxDecoration(
              //     gradient: LinearGradient(
              //         begin: Alignment.topCenter,
              //         end: Alignment.bottomCenter,
              //         colors: [
              //           Colors.blue,
              //           Colors.white,
              //         ]),
              //   ),
              //   child: Center(
              //     child: Icon(Icons.person, size: 100, color: Colors.white),
              //   ),
              // ),
              //
              Expanded(
                // biar bisa scroll
                child: ListView(children: <Widget>[
                  widget.data['oid'] == '02'
                      ? Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Text(
                            'Data Anda Sedang Kami Proses...',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : widget.data['oid'] == '00'
                          ? SizedBox()
                          : widget.data['oid'] == '01'
                              ? Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20.0),
                                      child: Text(
                                          'Data yang dikirim tidak sesuai!!!!'),
                                    ),
                                    TombolVerifikasi()
                                  ],
                                )
                              : widget.data['oid'] == null
                                  ? TombolVerifikasi()
                                  : TombolVerifikasi(),
                  Container(
                      padding: EdgeInsets.all(10.0),
                      margin:
                          EdgeInsets.only(right: 20.0, left: 20.0, top: 15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 3.0), //(x,y)
                            blurRadius: 10.0,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Informasi Pengguna',
                                    style: TextStyle(
                                        color: Colors.blue[900],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0),
                                  ),
                                  Row(children: <Widget>[
                                    Icon(Icons.person),
                                    if (widget.data['oid'] == '00')
                                      Icon(Icons.verified_user,
                                          size: 20,
                                          color: Colors.greenAccent[400])
                                  ])
                                ],
                              ),
                            ),
                            const Divider(
                              color: Colors.grey,
                              height: 0,
                              thickness: 0.3,
                              indent: 0,
                              endIndent: 0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InfoUser(
                                    infouser: 'Nama Pemilik',
                                    teks: widget.data['nama_pemilik'] ?? '-'),
                                GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          // barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  Text('Masukkan Nama Pemilik'),
                                              content: Container(
                                                height: 120,
                                                child:
                                                    Column(children: <Widget>[
                                                  TextFormField(
                                                    controller: namaPemilik,
                                                  ),
                                                  SizedBox(height: 10),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: <Widget>[
                                                      ElevatedButton(
                                                          onPressed: () {
                                                            editPemilik();
                                                          },
                                                          child: Text('Edit')),
                                                      ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text('Batal'))
                                                    ],
                                                  )
                                                ]),
                                              ),
                                            );
                                          });
                                    },
                                    child: Icon(Icons.edit,
                                        color: Warna.warna(biru)))
                              ],
                            ),
                            InfoUser(
                                infouser: 'Nama Toko',
                                teks: widget.data['reseller_toko'] != null
                                        ? widget.data['reseller_toko']
                                        ['nama_toko'] :
                                    widget.data['nama']),
                            InfoUser(
                                infouser: 'Nomor Telepon',
                                teks: widget.data['pengirim'][0]['pengirim']),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 5.0, bottom: 5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Saldo'),
                                  Text(
                                      NumberFormat.currency(
                                              locale: 'id',
                                              decimalDigits: 0,
                                              symbol: 'Rp. ')
                                          .format(widget.data['saldo']),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0))
                                ],
                              ),
                            ),
                            InfoUser(
                              infouser: 'Komisi',
                              teks: totalKomisi == null
                                  ? '0'
                                  : totalKomisi.toString(),
                            ),
                            InfoUser(
                                infouser: 'Poin',
                                teks: widget.data['poin'] == null
                                    ? '0'
                                    : widget.data['poin'].toString()),
                            InfoUser(
                                infouser: 'Alamat',
                                teks: data[0] ?? widget.data['alamat']),
                            data.length > 1
                                ? InfoUser(infouser: 'Kelurahan', teks: data[1])
                                : InfoUser(infouser: 'Kelurahan', teks: '-'),
                            data.length > 2
                                ? InfoUser(infouser: 'Kecamatan', teks: data[2])
                                : InfoUser(infouser: 'Kecamatan', teks: '-'),
                            data.length > 3
                                ? InfoUser(infouser: 'Kabupaten / Kota', teks: data[3])
                                : InfoUser(infouser: 'Kabupaten / Kota', teks: '-'),
                            data.length > 4
                                ? InfoUser(infouser: 'Provinsi', teks: data[4])
                                : InfoUser(infouser: 'Provinsi', teks: '-'),
                          ],
                        ),
                      ))
                ]),
              )
            ],
          ),
        ));
  }
}

class InfoUser extends StatelessWidget {
  InfoUser({this.infouser, this.teks});

  final String infouser;
  final String teks;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(infouser),
          Text(teks,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0))
        ],
      ),
    );
  }
}

class TombolVerifikasi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => VerifikasiData()));
          },
          child: Text('VERIFIKASI IDENTITAS')),
    );
  }
}
