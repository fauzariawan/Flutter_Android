import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../component.dart';
import '../listWarna.dart';

class DetailDeposit extends StatefulWidget {
  DetailDeposit({this.data});
  final dynamic data;
  @override
  _DetailDepositState createState() => _DetailDepositState();
}

class _DetailDepositState extends State<DetailDeposit> {
  DateTime now = DateTime.now();
  DateTime tanggal = DateTime.now();

  // var now = DateTime.now();
  void initState() {
    var secondsToAdd = Duration(hours: 2);
    tanggal = DateTime.parse(widget.data["waktu"]).add(secondsToAdd);
    // DateTime output = DateTime.parse((DateFormat("dd/MMMM/yyyy HH:mm:ss").format(tanggal)));
    print(widget.data);
    waktuKadaluarsa();
    super.initState();
    // print(output);
    print(now.isAfter(tanggal));
  }

  waktuKadaluarsa() {
    var secondsToAdd = Duration(hours: 2);
    var tanggal = DateTime.parse(widget.data["waktu"]).add(secondsToAdd);
    var output = DateFormat("dd/MMMM/yyyy HH:mm:ss").format(tanggal);
    widget.data["waktu_kadaluarsa"] = output;
    print(widget.data["waktu"]);
    print(widget.data["waktu_kadaluarsa"]);
    // DateTime parseDate =
    //     new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(widget.data["waktu"]);
    // var dateForComparison = DateTime.now().add(secondsToAdd);
    // var moment = Moment.now();
    // print(dateForComparison);
    // print(moment);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Detail Deposit'),
          centerTitle: true,
          elevation: 0,
        ),
        body: ListView(
          children: [
            Container(
              alignment: Alignment.center,
              height: 170.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Warna.warna(biru),
                      Colors.white,
                    ]),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        NumberFormat.currency(
                                locale: 'id', decimalDigits: 2, symbol: 'Rp ')
                            .format(widget.data['jumlah']),
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ]),
            ),
            if (widget.data['wrkirim'] != null)
              Container(
                margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                child: Text(
                  widget.data['wrkirim'],
                  style: TextStyle(
                      color: Warna.warna(biru),
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
              ),
            if (widget.data["status"] == "O")
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: <Widget>[
                    Text('Daftar Rekening'),
                    Divider(),
                    DaftarRekening(namaBank: 'BRI', noRek: '109201000130'),
                    SizedBox(
                      height: 5,
                    ),
                    DaftarRekening(namaBank: 'BCA', noRek: '8375666444'),
                    SizedBox(
                      height: 5,
                    ),
                    DaftarRekening(namaBank: 'MANDIRI', noRek: '1060044447202'),
                    SizedBox(
                      height: 5,
                    ),
                    DaftarRekening(namaBank: 'BNI', noRek: '4240044444'),
                    // CardRekening(
                    //     namaBank: 'BRI',
                    //     noRek: '109201000130560',
                    //     pemilikRek: 'a.n PT. LANGIT MULTI CHIP',
                    //     status: 'TERSEDIA'),
                    // CardRekening(
                    //     namaBank: 'BCA',
                    //     noRek: '8375666444',
                    //     pemilikRek: 'a.n PT. LANGIT MULTI CHIP',
                    //     status: 'TERSEDIA'),
                    // CardRekening(
                    //     namaBank: 'MANDIRI',
                    //     noRek: '1060044447202',
                    //     pemilikRek: 'a.n PT. LANGIT MULTI CHIP',
                    //     status: 'TERSEDIA'),
                    // CardRekening(
                    //     namaBank: 'BNI',
                    //     noRek: '4240044444',
                    //     pemilikRek: 'a.n PT. LANGIT MULTI CHIP',
                    //     status: 'TERSEDIA')
                  ],
                ),
              ),
            Container(
              margin: EdgeInsets.only(top: 30, left: 20, right: 20),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey, offset: Offset(0, 5), blurRadius: 5)
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Informasi Deposit'),
                      Icon(Icons.info, color: Colors.indigo[300])
                    ],
                  ),
                  Divider(),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Title(title: 'Nominal'),
                      Format.formatUang(widget.data["jumlah"])
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Title(title: "Biaya Admin"),
                        Text("Rp. 0",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                      ]),
                  widget.data["status"] == "C"
                      ? Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Title(title: "Keterangan"),
                              Text("Expired - Masa Transfer Berakhir",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14))
                            ],
                          ),
                        )
                      : SizedBox(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Title(title: "Waktu Deposit"),
                        Text(Format.formatTanggal(widget.data["waktu"]),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                      ]),
                  SizedBox(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Title(title: "Waktu Kadaluarsa"),
                        Text(widget.data["waktu_kadaluarsa"],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                      ]),
                  SizedBox(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Title(title: "Status"),
                        widget.data["status"] == "C" || now.isAfter(tanggal)
                            ? Text("Gagal",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.red))
                            : widget.data["status"] == "O"
                                ? Text("Pending",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14))
                                : Text("Berhasil",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14))
                      ])
                ],
              ),
            )
          ],
        ));
  }
}

class DaftarRekening extends StatelessWidget {
  const DaftarRekening({Key key, this.namaBank, this.noRek}) : super(key: key);
  final String namaBank;
  final String noRek;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(namaBank),
        Text(noRek,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}

class Title extends StatelessWidget {
  Title({this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(title, style: TextStyle(color: Colors.grey[400], fontSize: 10));
  }
}
