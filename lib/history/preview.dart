import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:android/categoryOperator.dart';
import 'package:android/history/formatPrint.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
// import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../component.dart';
import 'choosePrinter.dart';
import 'package:path_provider/path_provider.dart';

class Preview extends StatefulWidget {
  Preview({this.data});
  final dynamic data;
  @override
  _PreviewState createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  TextEditingController biayaAdmin = TextEditingController();
  TextEditingController biayaCetak = TextEditingController();
  TextEditingController tagihan = TextEditingController();
  LocalStorage storage = new LocalStorage('localstorage_app');
  dynamic dataUser;
  bool isLoading = false;
  bool sn;
  int admin = 0;
  int cetak = 0;
  int denda = 0;
  int biaya;
  List ket;
  String header;
  dynamic keterangan = {"value": null};
  bool _connected;
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  FormatPrint testPrint;
  String pathImage;

  void initState() {
    cekPrinter();
    testPrint = FormatPrint();
    sn = widget.data['sn'].contains('/');
    print(sn);
    callDataUser();
    print('ini sn <<<<<<<');
    print(widget.data['sn']);
    print(widget.data['produk']['kode_operator']);
    if (keterangan['value'] == null) {
      print('keterangan = {}');
    } else {
      print('keterangan tidak bisa di bandingan dengan {}');
    }
    // TELP, BPJS
    if (widget.data['produk']['kode_operator'] == 'PP' &&
        widget.data['sn'] != null) {
      print('kriteria terpenuhi');
      ket = widget.data['sn'].split('/');
      if (ket.length > 0) {
        String string = widget.data['produk']['nominal'].toString() + '000';
        setState(() {
          keterangan = {
            "token": "${ket[0]}",
            "nama": "${ket[1]}",
            "golongan": "${ket[2]}",
            "daya": "${ket[3]}",
            "kwh": "${ket[4]}",
            "tagihan": "$string"
          };
          admin = 0;
          biaya = int.parse(string);
          print(keterangan['kwh']);
        });
      }
    } else if (widget.data['produk']['kode_operator'] == 'PPLN' &&
        widget.data['sn'] != null) {
      ket = widget.data['sn'].split('/');
      String tarif = ket[1].substring(10, ket[1].length);
      String jmlBln = ket[3].substring(7, ket[3].length);
      String periode = ket[4].substring(8, ket[4].length);
      String tagihan = ket[5].substring(3, ket[5].length);
      String den = ket[6].substring(6, ket[6].length);
      String adm = ket[7].substring(6, ket[7].length);
      String totalTagihan = ket[8].substring(9, ket[8].length);
      String stand = ket[9].substring(6, ket[9].length);
      if (ket.length > 0) {
        setState(() {
          keterangan = {
            "nama": "${ket[0]}",
            "tarifDaya": "$tarif / ${ket[2]}",
            "jumlahBulan": "$jmlBln",
            "periode": "$periode",
            "tagihan": "$tagihan",
            "denda": "$den",
            "admin": "$adm",
            "totalTagihan": "$totalTagihan",
            "stand": "$stand"
          };
          admin = int.parse(adm);
          denda = int.parse(den);
          biaya = int.parse(tagihan);
          print(keterangan);
        });
      }
    } else if (widget.data['produk']['kode_operator'] == 'TELP' &&
        widget.data['sn'] != null) {
      if (widget.data['sn'] != null) {
        ket = widget.data['sn'].split('/');
        print(ket);
        String totalTagihan = ket[1].substring(3, ket[1].length);
        print(totalTagihan);
        String biller = ket[2].substring(7, ket[2].length);
        print(biller);
        String jumlahBulan = ket[3].substring(7, ket[3].length);
        print(jumlahBulan);
        String adm = ket[4].substring(4, ket[4].length);
        print(adm);
        String reff = ket[5].substring(5, ket[5].length);
        print('ini reff nya <<<<<<<<<<');
        print(reff);
        int tagihan = int.parse(totalTagihan) - int.parse(adm);
        if (ket.length > 0) {
          setState(() {
            keterangan = {
              "nama": "${ket[0]}",
              "totalTagihan": "$totalTagihan",
              "biller": "$biller",
              "jumlahBulan": "$jumlahBulan",
              "admin": "$adm",
              "tagihan": "$tagihan",
              "reff": "$reff"
            };
            admin = int.parse(adm);
            biaya = tagihan;
            print(keterangan);
          });
        }
      }
    } else if (widget.data['produk']['kode_operator'] == 'BPJS' &&
        widget.data['sn'] != null) {
      ket = widget.data['sn'].split('/');
      String totalTagihan = ket[1].substring(3, ket[1].length);
      print(totalTagihan);
      String jumlahPeserta = ket[2].substring(8, ket[2].length);
      print(jumlahPeserta);
      String cabang = ket[3].substring(7, ket[3].length);
      print(cabang);
      String jumlahBulan = ket[4].substring(7, ket[4].length);
      print(jumlahBulan);
      String adm = ket[5].substring(4, ket[5].length);
      print(adm);
      String reff = ket[6].substring(5, ket[6].length);
      print('ini reff nya <<<<<<<<<<');
      print(reff);
      int tagihan = int.parse(totalTagihan) - int.parse(adm);
      if (ket.length > 0) {
        setState(() {
          keterangan = {
            "nama": "${ket[0]}",
            "jumlahPeserta": "$jumlahPeserta",
            "cabang": "$cabang",
            "jumlahBulan": "$jumlahBulan",
            "admin": "$adm",
            "totalTagihan": "$totalTagihan",
            "tagihan": "$tagihan",
            "reff": "$reff"
          };
          admin = int.parse(adm);
          biaya = tagihan;
          print(keterangan);
        });
      }
    } else if (widget.data['produk']['kode_operator'] == 'PAM' &&
        widget.data['sn'] != null) {
      ket = widget.data['sn'].split('/');
      String tagihan = ket[1].substring(6, ket[1].length);
      String adm = ket[2].substring(6, ket[2].length);
      String totalTagihan = ket[3].substring(9, ket[3].length);
      String jmlBln = ket[4].substring(7, ket[4].length);
      String periode = ket[5].substring(8, ket[5].length);
      String stand = ket[6].substring(6, ket[6].length);
      String reff = ket[7].substring(5, ket[7].length);
      print('ini reff nya <<<<<<<<<<');
      print(reff);
      if (ket.length > 0) {
        setState(() {
          keterangan = {
            "nama": "${ket[0]}",
            "periode": "$periode",
            "jumlahBulan": "$jmlBln",
            "stand": "$stand",
            "tagihan": "$tagihan",
            "admin": "$adm",
            "totalTagihan": "$totalTagihan",
            "reff": "$reff"
          };
          admin = int.parse(adm);
          biaya = int.parse(tagihan);
          print(keterangan);
        });
      }
    } else if (widget.data['produk']['kode_operator'] == 'TELKOM' &&
        widget.data['sn'] != null) {
      ket = widget.data['sn'].split('/');
      String totalTagihan = ket[1].substring(3, ket[1].length);
      print(totalTagihan);
      // String biller = ket[2].substring(8, ket[2].length);
      // print(biller);
      String periode = ket[2].substring(8, ket[2].length);
      print(periode);
      String jumlahBulan = ket[5].substring(7, ket[5].length);
      print(jumlahBulan);
      String adm = ket[6].substring(4, ket[6].length);
      print(adm);
      int tagihan = int.parse(totalTagihan) - int.parse(adm);
      print(tagihan);
      String reff = ket[7].substring(5, ket[7].length);
      print('ini reff nya <<<<<<<<<<');
      print(reff);
      if (ket.length > 0) {
        setState(() {
          keterangan = {
            "nama": "${ket[0]}",
            "totalTagihan": "$totalTagihan",
            // "biller": "$biller",
            "periode": "$periode",
            "jumlahBulan": "$jumlahBulan",
            "admin": "$adm",
            "tagihan": "$tagihan",
            "reff": "$reff"
          };
          admin = int.parse(adm);
          biaya = tagihan;
          print(keterangan);
        });
      }
    } else if (widget.data['produk']['kode_operator'] == 'PGN' &&
        widget.data['sn'] != null) {
      ket = widget.data['sn'].split('/');
      if (ket[ket.length - 1].contains('TAG')) {
        String totalTagihan = ket[1].substring(3, ket[1].length);
        String periode = ket[2].substring(8, ket[2].length);
        String jumlahBulan = ket[3].substring(7, ket[3].length);
        String adm = ket[4].substring(6, ket[4].length);
        String tagihan = ket[5].substring(4, ket[5].length);
        if (ket.length > 0) {
          setState(() {
            keterangan = {
              "nama": "${ket[0]}",
              "totalTagihan": "$totalTagihan",
              "periode": "$periode",
              "jumlahBulan": "$jumlahBulan",
              "admin": "$adm",
              "tagihan": "$tagihan"
            };
            admin = int.parse(adm);
            biaya = int.parse(tagihan);
            print(keterangan);
          });
        }
      } else {
        String totalTagihan = ket[1].substring(3, ket[1].length);
        String periode = ket[2].substring(8, ket[2].length);
        String jumlahBulan = ket[3].substring(7, ket[3].length);
        String adm = ket[4].substring(6, ket[4].length);
        int tagihan = int.parse(totalTagihan) - int.parse(adm);
        if (ket.length > 0) {
          setState(() {
            keterangan = {
              "nama": "${ket[0]}",
              "totalTagihan": "$totalTagihan",
              "periode": "$periode",
              "jumlahBulan": "$jumlahBulan",
              "admin": "$adm",
              "tagihan": "$tagihan"
            };
            admin = int.parse(adm);
            biaya = tagihan;
            print(keterangan);
          });
        }
      }
    } else if (widget.data['produk']['kode_operator'] ==
            'SHOP' && // tagihan masih ambil manual
        widget.data['sn'] != null) {
      ket = widget.data['sn'].split('/');
      String nama = ket[1];
      String billReff = ket[3].substring(9, ket[3].length);
      String tagihan = ket[2];
      if (ket.length > 0) {
        setState(() {
          keterangan = {
            "nama": "$nama",
            "BillReff": "$billReff",
            "tagihan": "$tagihan",
          };
          biaya = int.parse(tagihan);
          print(keterangan);
        });
      }
    } else if (widget.data['produk']['kode_operator'] ==
            'ZWD' && // tagihan masih ambil manual
        widget.data['sn'] != null) {
      ket = widget.data['sn'].split('/');
      var regex = new RegExp(r'[^0-9]'); // hapus semua kecuali 0-9
      print(ket);
      String bank = ket[1].substring(5, ket[1].length);
      print(bank);
      String noTujuan = ket[2];
      print(noTujuan);
      String nominal = ket[3].substring(3, ket[3].length);
      print(nominal);
      String adm = ket[4].substring(6, ket[4].length);
      print(adm);
      String totalTagihan =
          ket[5].substring(10, ket[5].length).replaceAll(regex, '');
      print(totalTagihan);
      String reff = ket[6].substring(5, ket[6].length);
      print(reff);
      if (ket.length > 0) {
        setState(() {
          keterangan = {
            "nama": "${ket[0]}",
            "bank": "$bank",
            "noTujuan": "$noTujuan",
            "tagihan": "$nominal",
            "admin": "$adm",
            "totalTagihan": "$totalTagihan",
            "reff": "$reff"
          };
          admin = int.parse(adm);
          biaya = int.parse(nominal);
          print(keterangan);
        });
      }
    } else if (widget.data['produk']['kode_operator'] ==
            'GOJEK' && // tagihan masih ambil manual
        widget.data['sn'] != null) {
      ket = widget.data['sn'].split('/');
      if (ket.length > 0) {
        String string = widget.data['produk']['nama']
            .substring(30, widget.data['produk']['nama'].length);
        String tagihan = string.split(',').join('');
        print('<<<<<<<<<<>>>>>>>>>>');
        print(tagihan);
        setState(() {
          keterangan = {"tagihan": "$tagihan"};
          admin = 0;
        });
        biaya = int.parse(tagihan);
      }
    } else {
      print('produk blm di daftarkan');
      if (keterangan == null) {
        print('keterangan NULL');
        String string = widget.data['produk']['nominal'].toString() + '000';
        keterangan = {"tagihan": "$string"};
        biaya = int.parse(string);
      } else {
        print('keterangan TIDAK null');
        String string = widget.data['produk']['nominal'].toString() + '000';
        print(string);
        keterangan = {"tagihan": "$string"};
        biaya = int.parse(string);
      }
    }
    super.initState();
  }

  initSavetoPath() async {
    //read and write
    //image max 300px X 300px
    final filename = 'myLogo.jpg';
    var bytes = await rootBundle.load("image/funmo/myLogo.jpg");
    String dir = (await getApplicationDocumentsDirectory()).path;
    writeToFile(bytes, '$dir/$filename');
    setState(() {
      pathImage = '$dir/$filename';
    });
  }

  cekPrinter() async {
    _connected = await bluetooth.isConnected;
  }

  cetakStruk() async {
      testPrint.sample(
          pathImage,
          widget.data,
          keterangan,
          biaya,
          admin,
          denda,
          cetak,
          header,
          dataUser["alamat"] ?? 'unknown',
          dataUser['reseller_toko']);
  }

  callDataUser() async {
    print('data user <<<<<<<<<<<<<');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dataUser = json.decode(prefs.getString("dataUser"));
    print(dataUser);
    setState(() {
      dataUser = json.decode(prefs.getString("dataUser"));
      dataUser["reseller_toko"] != null
          ? header = dataUser["reseller_toko"]['nama_toko']
          : header = dataUser["nama"];
      print('ini header <<<<<<<<<<<<<');
      print(header);
      // print(dataUser['reseller_toko']['nama_toko']);
    });
  }

  changeFormatBiayaAdmin() {
    setState(() {
      admin = int.parse(biayaAdmin.text);
    });
    // String fix = FormatUang.formatUang(biayaAdmin);
    // final val = TextSelection.collapsed(
    //     offset: fix.length); // to set cursor position at the end of the value
    // setState(() {
    //   biayaAdmin.text = fix;
    //   biayaAdmin.selection =
    //       val; // to set cursor position at the end of the value
    // });
  }

  changeFormatBiayaTagihan() {
    setState(() {
      biaya = int.parse(tagihan.text);
    });
    // String fix = FormatUang.formatUang(biayaAdmin);
    // final val = TextSelection.collapsed(
    //     offset: fix.length); // to set cursor position at the end of the value
    // setState(() {
    //   biayaAdmin.text = fix;
    //   biayaAdmin.selection =
    //       val; // to set cursor position at the end of the value
    // });
  }

  changeFormatBiayaCetak() {
    setState(() {
      cetak = int.parse(biayaCetak.text);
    });
    // String fix = FormatUang.formatUang(biayaCetak);
    // final val = TextSelection.collapsed(
    //     offset: fix.length); // to set cursor position at the end of the value
    // setState(() {
    //   biayaCetak.text = fix;
    //   biayaCetak.selection =
    //       val; // to set cursor position at the end of the value
    // });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(fontFamily: 'Thermal', fontSize: 12);
    return Scaffold(
        appBar: AppBar(
          title: Text('Preview'),
          centerTitle: true,
        ),
        body: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey, offset: Offset(0, 5), blurRadius: 5)
                  ]),
              child: Column(
                children: [
                  TextFormField(
                    // inputFormatters: [DecimalTextInputFormatter()],
                    keyboardType: TextInputType.number,
                    controller: tagihan,
                    onChanged: (tagihan) {
                      changeFormatBiayaTagihan();
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Edit Tagihan',
                        prefixText: 'Rp. '),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    // inputFormatters: [DecimalTextInputFormatter()],
                    keyboardType: TextInputType.number,
                    controller: biayaAdmin,
                    onChanged: (biayaAdim) {
                      changeFormatBiayaAdmin();
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Biaya Admin',
                        prefixText: 'Rp. '),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    // inputFormatters: [DecimalTextInputFormatter()],
                    keyboardType: TextInputType.number,
                    controller: biayaCetak,
                    onChanged: (biayaCetak) {
                      changeFormatBiayaCetak();
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Biaya Cetak',
                        prefixText: 'Rp. '),
                  ),
                ],
              ),
            ),
            isLoading
                ? Loading()
                : dataUser == null
                    ? Text("data User tidak ditemukan")
                    : Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(20),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0, 5),
                                  blurRadius: 5)
                            ]),
                        // color: Colors.yellow,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: <Widget>[
                                  Text(header,
                                      style: TextStyle(
                                          fontFamily: 'Thermal',
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 10),
                                  Text(
                                    dataUser["reseller_toko"] != null
                                        ? dataUser["reseller_toko"]
                                            ['alamat_toko']
                                        : dataUser['alamat'],
                                    style: TextStyle(
                                        fontFamily: 'Thermal', fontSize: 12),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    DateFormat("dd MMMM yyyy HH:mm:ss")
                                        .format(DateTime.now()),
                                    style: style),
                                if (keterangan['value'] == null && sn == false)
                                  Column(
                                    children: [
                                      SizedBox(height: 5),
                                      Text(
                                        'Trx ID : ${widget.data['ref_id']}',
                                        style: style,
                                      ),
                                    ],
                                  )
                              ],
                            ),
                            Divider(
                              thickness: 3,
                            ),
                            Text("Transaksi :",
                                style: TextStyle(
                                    fontFamily: 'Thermal',
                                    fontSize: 12,
                                    decoration: TextDecoration.underline)),
                            SizedBox(height: 10),
                            DetailTransaksi(
                                title: "Nama Produk",
                                value: widget.data['produk']['nama']),
                            DetailTransaksi(
                                title: "Tujuan", value: widget.data['tujuan']),
                            if (keterangan['nama'] != null)
                              DetailTransaksi(
                                  title: "Nama", value: keterangan['nama']),
                            if (keterangan['reff'] != null)
                              DetailTransaksi(
                                  title: 'Reff', value: keterangan['reff']),
                            if (keterangan['tarifDaya'] != null)
                              DetailTransaksi(
                                  title: "Tarif Daya",
                                  value: keterangan['tarifDaya']),
                            if (keterangan['golongan'] != null)
                              DetailTransaksi(
                                  title: "Golongan",
                                  value: keterangan['golongan']),
                            if (keterangan['daya'] != null)
                              DetailTransaksi(
                                  title: "Daya", value: keterangan['daya']),
                            if (keterangan['kwh'] != null)
                              DetailTransaksi(
                                  title: "KWH", value: keterangan['kwh']),
                            if (keterangan['biller'] != null)
                              DetailTransaksi(
                                  title: "Biller", value: keterangan['biller']),
                            if (keterangan['periode'] != null)
                              DetailTransaksi(
                                  title: "Periode",
                                  value: keterangan['periode']),
                            if (keterangan['jumlahPeserta'] != null)
                              DetailTransaksi(
                                  title: "Jumlah Peserta",
                                  value: keterangan['jumlahPeserta']),
                            if (keterangan['cabang'] != null)
                              DetailTransaksi(
                                  title: "Cabang", value: keterangan['cabang']),
                            if (keterangan['jumlahBulan'] != null)
                              DetailTransaksi(
                                  title: "Jumlah Bulan",
                                  value: keterangan['jumlahBulan']),
                            if (keterangan['stand'] != null)
                              DetailTransaksi(
                                  title: "Stand", value: keterangan['stand']),
                            if (widget.data['sn'].contains('/') == false)
                              DetailTransaksi(
                                  title: "SN", value: widget.data['sn']),
                            if (keterangan['tagihan'] != null)
                              DetailTransaksi(
                                  title: widget.data['produk']
                                              ['kode_operator'] ==
                                          'ZWD'
                                      ? 'Nominal'
                                      : produkPpob.contains(widget
                                              .data['produk']['kode_operator'])
                                          ? "Tagihan"
                                          : "Harga",
                                  value: NumberFormat.currency(
                                          locale: 'id',
                                          symbol: 'Rp. ',
                                          decimalDigits: 0)
                                      .format(biaya)),
                            if (admin != null)
                              DetailTransaksi(
                                  title: "Admin",
                                  value: NumberFormat.currency(
                                          locale: 'id',
                                          symbol: 'Rp. ',
                                          decimalDigits: 0)
                                      .format(admin)),
                            if (keterangan['denda'] != null)
                              DetailTransaksi(
                                  title: "Denda",
                                  value: NumberFormat.currency(
                                          locale: 'id',
                                          symbol: 'Rp. ',
                                          decimalDigits: 0)
                                      .format(int.parse(keterangan['denda']))),
                            DetailTransaksi(
                                title: "Biaya Cetak",
                                value: NumberFormat.currency(
                                        locale: 'id',
                                        symbol: 'Rp. ',
                                        decimalDigits: 0)
                                    .format(cetak)),
                            Divider(
                              thickness: 3,
                            ),
                            widget.data['produk']['kode'].contains('PP')
                                ? Column(
                                    children: [
                                      DetailTransaksi(
                                          title: "Total",
                                          value: NumberFormat.currency(
                                                  locale: 'id',
                                                  symbol: 'Rp. ',
                                                  decimalDigits: 0)
                                              .format(int.parse(
                                                      keterangan['tagihan']) +
                                                  admin +
                                                  cetak +
                                                  denda)),
                                      DetailTransaksi(
                                          title: "Token",
                                          value: keterangan['token']),
                                    ],
                                  )
                                : keterangan['tagihan'] != null
                                    ? DetailTransaksi(
                                        title: "Total Semua",
                                        value: NumberFormat.currency(
                                                locale: 'id',
                                                symbol: 'Rp. ',
                                                decimalDigits: 0)
                                            .format(
                                                biaya + admin + cetak + denda))
                                    : DetailTransaksi(
                                        title: "Total",
                                        value: NumberFormat.currency(
                                                locale: 'id',
                                                symbol: 'Rp ',
                                                decimalDigits: 0)
                                            .format(widget.data['harga'] +
                                                cetak +
                                                admin)),
                            Divider(
                              thickness: 3,
                            ),
                            Text(
                                "STRUK INI MERUPAKAN BUKTI PEMBAYARAN YANG SAH",
                                style: style,
                                textAlign: TextAlign.center),
                            Text(
                                "TERSEDIA PULSA, KUOTA ALL OPERATOR, TOKEN PLN, BAYAR LISTRIK, PDAM, TELKOM, ITEM GAME, DAN MULTI PEMBAYARAN LAINNYA",
                                textAlign: TextAlign.center,
                                style: style)
                          ],
                        ),
                      )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _connected ? cetakStruk() :
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ChoosePrinter(
                    type: 'transaksi',
                    dataToko: dataUser['reseller_toko'],
                    data: widget.data,
                    ket: keterangan,
                    biaya: biaya,
                    admin: admin,
                    denda: denda,
                    cetak: cetak,
                    header: header,
                    alamat: dataUser["alamat"] ?? 'unknown')));
          },
          child: Icon(Icons.print),
        ));
  }
}

class DetailTransaksi extends StatelessWidget {
  DetailTransaksi({this.title, this.value});
  final String title;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(title, style: TextStyle(fontFamily: "Thermal", fontSize: 12)),
            Container(
              width: MediaQuery.of(context).size.width / 2,
              child: Text(value,
                  style: TextStyle(
                      fontFamily: "Thermal",
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right),
            )
          ],
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}

Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }