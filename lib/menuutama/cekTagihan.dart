import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:localstorage/localstorage.dart';
import "package:http/http.dart" as http;
import "package:flutter_dotenv/flutter_dotenv.dart" as DotEnv;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../categoryOperator.dart';
import '../component.dart';
import '../listWarna.dart';
import '../phoneBook.dart';
import '../routerName.dart';
import 'konfirmasiPin.dart';

class CekTagihan extends StatefulWidget {
  CekTagihan({this.data, this.nomor});
  final dynamic data;
  final dynamic nomor;
  @override
  _CekTagihanState createState() => _CekTagihanState();
}

class _CekTagihanState extends State<CekTagihan> {
  LocalStorage storage = new LocalStorage('localstorage_app');
  final _formCekTagihan = GlobalKey<FormState>();
  TextEditingController nomorTujuan = TextEditingController();
  TextEditingController nama = new TextEditingController();
  String type;
  dynamic dataUser;
  dynamic favorit;
  dynamic result;
  bool buttonCek = false;
  bool isLoading = false;
  bool isDataPelanggan = false;
  bool buttonBayar = false;
  dynamic dataPelanggan;
  String pesan;
  List splitPesan;
  List meteran;
  List getBiayaAdmin;
  String jumlahPeserta;
  String cabang;
  String namaPelanggan;
  String jumlahTagihan;
  String biayaAdmin;
  String totalTagihan;
  String standMeteran;
  String periode;
  String biller;
  String jumlahBulan;
  String angsuranKe;
  int getJumlahTagihan;

  void initState() {
    print(widget.data);
    widget.nomor != null ? buttonCek = true : buttonCek = false;
    nomorTujuan = TextEditingController(
        text: widget.nomor != null ? widget.nomor['noTelp'] : nomorTujuan.text);
    super.initState();
  }

  getResponse() async {
    setState(() {
      isLoading = true;
    });
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = 'inbox/inboxinq';
    final params = null;
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());
    return await http.post(url, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'token': storage.getItem('token')
    }, body: {
      'code_product': "${widget.data['kode']}",
      'destiny': nomorTujuan.text // 126100030354
    });
  }

  showRespon(String pesan) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Information'),
            content: Container(
              child: Text(pesan),
            ),
          );
        });
  }

  _cekTagihan() async {
    if (ctelpPascaBayar.contains(widget.data['kode'])) {
      print('ini produk cek telpon PASCA BAYAR');
      var response = await getResponse();
      if (response.statusCode == 200) {
        dataPelanggan = json.decode(response.body);
        pesan = dataPelanggan['pesan'];
        print(pesan);
        if (pesan.contains('RC:00') == true) {
          splitPesan = pesan.split("/");
          print(splitPesan);
          setState(() {
            namaPelanggan = splitPesan[1].substring(5, splitPesan[1].length);
            biller = splitPesan[3].substring(7, splitPesan[3].length);
            jumlahBulan = splitPesan[4].substring(7, splitPesan[4].length);
            biayaAdmin = splitPesan[5].substring(4, 8);
            totalTagihan = splitPesan[2].substring(3, splitPesan[2].length);
            getJumlahTagihan = int.parse(totalTagihan) - int.parse(biayaAdmin);
            jumlahTagihan = getJumlahTagihan.toString();
            isDataPelanggan = true;
            isLoading = false;
            buttonCek = false;
            buttonBayar = true;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          showRespon(pesan);
        }
      } else if (response.statusCode == 400) {
        print(response.body);
        dynamic result = json.decode(response.body);
        setState(() {
          isLoading = false;
        });
        showRespon(result['pesan']);
      }
    } else if (cfinance.contains(widget.data['kode'])) {
      print('ini produk cek FINANCE');
      var response = await getResponse();
      if (response.statusCode == 200) {
        dataPelanggan = json.decode(response.body);
        pesan = dataPelanggan['pesan'];
        print(pesan);
        if (pesan.contains('RC:00') == true) {
          splitPesan = pesan.split("/");
          print(splitPesan);
          setState(() {
            namaPelanggan = splitPesan[1].substring(5, splitPesan[1].length);
            angsuranKe = splitPesan[3].substring(7, splitPesan[3].length);
            periode = splitPesan[4].substring(8, splitPesan[4].length);
            getBiayaAdmin = splitPesan[5].split(",");
            biayaAdmin = getBiayaAdmin[0].substring(6, getBiayaAdmin[0].length);
            totalTagihan = splitPesan[2].substring(3, splitPesan[2].length);
            getJumlahTagihan = int.parse(totalTagihan) - int.parse(biayaAdmin);
            jumlahTagihan = getJumlahTagihan.toString();
            isDataPelanggan = true;
            isLoading = false;
            buttonCek = false;
            buttonBayar = true;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          showRespon(pesan);
        }
      } else {
        dataPelanggan = json.decode(response.body);
        pesan = dataPelanggan['pesan'];
        setState(() {
          isLoading = false;
        });
        showRespon(pesan);
      }
    } else if (cpdam.contains(widget.data['kode'])) {
      print('ini produk cek PDAM');
      var response = await getResponse();
      if (response.statusCode == 200) {
        dataPelanggan = json.decode(response.body);
        pesan = dataPelanggan['pesan'];
        if (pesan.contains('RC:00') == true) {
          splitPesan = pesan.split("/");
          meteran = splitPesan[7].split(".");
          setState(() {
            namaPelanggan = splitPesan[1].substring(5, splitPesan[1].length);
            jumlahTagihan = splitPesan[2].substring(6, splitPesan[2].length);
            biayaAdmin = splitPesan[3].substring(6, splitPesan[3].length);
            totalTagihan = splitPesan[4].substring(9, splitPesan[4].length);
            jumlahBulan = splitPesan[5].substring(7, splitPesan[5].length);
            periode = splitPesan[6].substring(8, splitPesan[6].length);
            standMeteran = meteran[0].substring(6, meteran[0].length);
            isDataPelanggan = true;
            isLoading = false;
            buttonCek = false;
            buttonBayar = true;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          showRespon(pesan);
        }
      } else {
        dataPelanggan = json.decode(response.body);
        pesan = dataPelanggan['pesan'];
        setState(() {
          isLoading = false;
        });
        showRespon(pesan);
      }
    } else if (cpln.contains(widget.data['kode'])) {
      print('ini produk cek PLN');
      var response = await getResponse();
      if (response.statusCode == 200) {
        dataPelanggan = json.decode(response.body);
        pesan = dataPelanggan['pesan'];
        if (pesan.contains('RC:00') == true) {
          splitPesan = pesan.split("/");
          print(splitPesan);
          setState(() {
            namaPelanggan = splitPesan[1].substring(5, splitPesan[1].length);
            jumlahTagihan = splitPesan[6].substring(3, splitPesan[6].length);
            biayaAdmin = splitPesan[8].substring(6, splitPesan[8].length);
            totalTagihan = splitPesan[9].substring(9, splitPesan[9].length);
            standMeteran = splitPesan[10].substring(6, 17);
            periode = splitPesan[5].substring(8, splitPesan[5].length);
            print(periode);
            isDataPelanggan = true;
            isLoading = false;
            buttonCek = false;
            buttonBayar = true;
          });
        } else {
          dataPelanggan = json.decode(response.body);
          setState(() {
            isLoading = false;
            isDataPelanggan = false;
          });
          showRespon(dataPelanggan['pesan']);
        }
      } else {
        print('ini response status nya');
        print(response.statusCode);
        dataPelanggan = json.decode(response.body);
        setState(() {
          isLoading = false;
          isDataPelanggan = false;
        });
        showRespon(dataPelanggan['pesan']);
      }
    } else if (ctelkom.contains(widget.data['kode'])) {
      print('ini produk ${widget.data['nama']}');
      var response = await getResponse();
      if (response.statusCode == 200) {
        dataPelanggan = json.decode(response.body);
        pesan = dataPelanggan['pesan'];
        print(pesan);
        if (pesan.contains('RC:00') == true) {
          splitPesan = pesan.split("/");
          print(splitPesan);
          List totalBayar;
          setState(() {
            namaPelanggan = splitPesan[1].substring(5, splitPesan[1].length);
            biller = splitPesan[3].substring(7, splitPesan[3].length);
            jumlahBulan = splitPesan[5].substring(7, splitPesan[5].length);
            periode = splitPesan[4].substring(8, splitPesan[4].length);
            biayaAdmin = splitPesan[6].substring(4, splitPesan[6].length);
            totalBayar = splitPesan[7].split("."); // untuk mendapatkan nilai totalTagihan 
            totalTagihan = splitPesan[2].substring(3, splitPesan[2].length);
            // getJumlahTagihan = int.parse(totalTagihan) - int.parse(biayaAdmin);
            jumlahTagihan = totalBayar[0].substring(4, totalBayar[0].length); //getJumlahTagihan.toString();
            print(namaPelanggan);
            print(biller);
            print(jumlahBulan);
            print(jumlahTagihan);
            print(biayaAdmin);
            print(totalTagihan);
            isDataPelanggan = true;
            isLoading = false;
            buttonCek = false;
            buttonBayar = true;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          showRespon(pesan);
        }
      } else {
        dataPelanggan = json.decode(response.body);
        pesan = dataPelanggan['pesan'];
        setState(() {
          isLoading = false;
        });
        showRespon(pesan);
      }
    } else if (cgas.contains(widget.data['kode'])) {
      print('ini produk ${widget.data['nama']}');
      var response = await getResponse();
      if (response.statusCode == 200) {
        dataPelanggan = json.decode(response.body);
        pesan = dataPelanggan['pesan'];
        print(pesan);
        if (pesan.contains('RC:00') == true) {
          splitPesan = pesan.split("/");
          print(splitPesan);
          setState(() {
            namaPelanggan = splitPesan[1].substring(5, splitPesan[1].length);
            jumlahBulan = splitPesan[4].substring(7, splitPesan[4].length);
            periode = splitPesan[3].substring(8, splitPesan[3].length);
            getBiayaAdmin = splitPesan[5].split(",");
            biayaAdmin = getBiayaAdmin[0].substring(6, getBiayaAdmin[0].length);
            totalTagihan = splitPesan[2].substring(3, splitPesan[2].length);
            getJumlahTagihan = int.parse(totalTagihan) - int.parse(biayaAdmin);
            jumlahTagihan = getJumlahTagihan.toString();
            isDataPelanggan = true;
            isLoading = false;
            buttonCek = false;
            buttonBayar = true;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          showRespon(pesan);
        }
      } else {
        dataPelanggan = json.decode(response.body);
        pesan = dataPelanggan['pesan'];
        setState(() {
          isLoading = false;
        });
        showRespon(pesan);
      }
    } else if (cinternet.contains(widget.data['kode'])) {
      print('ini produk ${widget.data['nama']}');
      var response = await getResponse();
      if (response.statusCode == 200) {
        dataPelanggan = json.decode(response.body);
        pesan = dataPelanggan['pesan'];
        print(pesan);
        if (pesan.contains('RC:00') == true) {
          splitPesan = pesan.split("/");
          print(splitPesan);
          setState(() {
            namaPelanggan = splitPesan[1].substring(5, splitPesan[1].length);
            jumlahBulan = splitPesan[4].substring(7, splitPesan[4].length);
            periode = splitPesan[3].substring(8, splitPesan[3].length);
            getBiayaAdmin = splitPesan[5].split(".");
            biayaAdmin = getBiayaAdmin[0].substring(6, getBiayaAdmin[0].length);
            totalTagihan = splitPesan[2].substring(3, splitPesan[2].length);
            getJumlahTagihan = int.parse(totalTagihan) - int.parse(biayaAdmin);
            jumlahTagihan = getJumlahTagihan.toString();
            isDataPelanggan = true;
            isLoading = false;
            buttonCek = false;
            buttonBayar = true;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          showRespon(pesan);
        }
      } else {
        dataPelanggan = json.decode(response.body);
        pesan = dataPelanggan['pesan'];
        setState(() {
          isLoading = false;
        });
        showRespon(pesan);
      }
    } else if (cpbb.contains(widget.data['kode'])) {
      print('ini cek produk ${widget.data['nama']}');
    } else if (widget.data['kode'] == 'CBPJS') {
      print('ini produk bpjs');
      var response = await getResponse();
      if (response.statusCode == 200) {
        dataPelanggan = json.decode(response.body);
        pesan = dataPelanggan['pesan'];
        if (pesan.contains('RC:00') == true) {
          splitPesan = pesan.split("/");
          print(splitPesan);
          setState(() {
            namaPelanggan = splitPesan[1].substring(5, splitPesan[1].length);
            jumlahTagihan = splitPesan[2].substring(3, splitPesan[2].length);
            jumlahPeserta = splitPesan[3].substring(8, splitPesan[3].length);
            cabang = splitPesan[4].substring(7, splitPesan[4].length);
            jumlahBulan = splitPesan[5].substring(7, splitPesan[5].length);
            biayaAdmin = splitPesan[6].substring(4, 8);
            // print(namaPelanggan);
            isDataPelanggan = true;
            isLoading = false;
            buttonCek = false;
            buttonBayar = true;
          });
        } else {
          dataPelanggan = json.decode(response.body);
          setState(() {
            isLoading = false;
          });
          showRespon(dataPelanggan['pesan']);
        }
      } else {
        dataPelanggan = json.decode(response.body);
        pesan = dataPelanggan['pesan'];
        setState(() {
          isLoading = false;
        });
        showRespon(pesan);
      }
    } else {
      print('untuk CEK PRODUK ${widget.data['nama']} belum terdaftar');
    }
  }

  bayarTagihan() async {
    String kode =
        "B${widget.data['kode'].substring(1, widget.data['kode'].length)}";
    print(kode);
    String toTag =
        widget.data['kode'] != 'CBPJS' ? totalTagihan : jumlahTagihan;
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => KonfirmasiPin(data: {
              "kode": "bayarTagihan",
              "code_product": "$kode",
              "destiny": nomorTujuan.text,
              "totalTagihan": toTag
            })));
  }

  simpanNomor() async {
    // setState(() {
    //   isLoading = true;
    // });
    // if (hpFavorit.contains(widget.selectedItem['kode_operator'])) {
    //   type = 1;
    // } else if (widget.selectedItem['kode_operator'] == 'PP') {
    //   type = 2;
    // }
    if (widget.data['nama'].contains('PLN')) {
      type = '2';
    } else {
      type = 'bukan PLN';
    }
    print(widget.data['nama']);
    print(type);
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // final baseUrl = DotEnv.env['BASE_URL'];
    // final path = "lib/sn";
    // final params = null;
    // final url = Uri.http(baseUrl, path, params);
    // debugPrint(url.toString());

    // var response = await http.post(url, headers: {
    //   "Content-Type": "application/x-www-form-urlencoded",
    //   "token": prefs.getString('token')
    // }, body: {
    //   "number": nomorTujuan.text,
    //   "nama": nama.text,
    //   "type": type
    // });

    // if (response.statusCode == 200) {
    //   setState(() {
    //     isLoading = false;
    //   });
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       content: Text('Nomor Berhasil Disimpan'),
    //       duration: Duration(milliseconds: 500)));
    // } else if (response.statusCode == 400) {
    //   setState(() {
    //     isLoading = false;
    //   });
    //   result = json.decode(response.body);
    //   if (result['rc'] == '01') {
    //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //         content: Text('Gagal Menyimpan Nomor'),
    //         duration: Duration(milliseconds: 500)));
    //   } else if (result['rc'] == '02') {
    //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //         content: Text('Nomor Sudah Ada'),
    //         duration: Duration(milliseconds: 500)));
    //   }
    // } else {
    //   setState(() {
    //     isLoading = false;
    //   });
    //   print(response.body);
    // }
  }

  simpan(String nomor, String nama, String type) async {
    print(nomor);
    print(type);
    print(nama);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = "reseller/saveNumber";
    final params = null;
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());

    var response = await http.post(url, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "token": prefs.getString('token')
    }, body: {
      "number": nomor,
      "nama": nama,
      "type": type
    });

    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Nomor Berhasil Disimpan'),
          duration: Duration(milliseconds: 500)));
    } else if (response.statusCode == 400) {
      setState(() {
        isLoading = false;
      });
      result = json.decode(response.body);
      if (result['rc'] == '01') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Gagal Menyimpan Nomor'),
            duration: Duration(milliseconds: 500)));
      } else if (result['rc'] == '02') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Nomor Sudah Ada'),
            duration: Duration(milliseconds: 500)));
      }
    } else {
      setState(() {
        isLoading = false;
      });
      print(response.body);
    }
  }

  getFavorit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dataUser = json.decode(prefs.getString('dataUser'));
    favorit = dataUser['reseller_save'];
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PhoneBook(
              data: favorit,
              routing: cekTagihan,
              dataRouting: widget.data,
            )));
  }

  @override
  Widget build(BuildContext context) {
    // membuat widget yang bisa di panggil secara dinamis
    GestureDetector tutup = GestureDetector(
        onTap: () {
          setState(() {
            isDataPelanggan = false;
            nomorTujuan.text = '';
            buttonCek = true;
            buttonBayar = false;
          });
        },
        child: ClipOval(
          child: Container(
              padding: EdgeInsets.all(2),
              color: Warna.warna(kuning),
              child: Icon(Icons.close_rounded,
                  color: Warna.warna(biru), size: 20)),
        ));
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data['nama']),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowGlow();
            },
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    children: <Widget>[
                      Form(
                        key: _formCekTagihan,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: nomorTujuan,
                              keyboardType: TextInputType.number,
                              onChanged: (nomorTujuan) {
                                setState(() {
                                  buttonCek = true;
                                });
                              },
                              validator: (nomorTujuan) {
                                if (nomorTujuan.isEmpty) {
                                  return 'Nomor Tujuan Harus Diisi';
                                } else {
                                  return null;
                                }
                              },
                              // maxLength: 13,
                              decoration: InputDecoration(
                                  prefixIcon: GestureDetector(
                                      onTap: () {
                                        getFavorit();
                                      },
                                      child: Icon(Icons.autorenew_rounded)),
                                  labelText: widget.data['kode'] == 'CPLN' ||
                                          widget.data['kode'].contains('CPAM')
                                      ? 'Nomor ID Meter'
                                      : 'Nomor Tujuan',
                                  border: OutlineInputBorder()),
                            ),
                            if (isLoading) Loading(),
                            ctelpPascaBayar.contains(widget.data['kode'])
                                ? isDataPelanggan
                                    ? Column(
                                        children: [
                                          DetailTagihanPascaBayar(
                                            namaPelanggan: namaPelanggan,
                                            biller: biller,
                                            jumlahBulan: jumlahBulan,
                                            biayaAdmin: biayaAdmin,
                                            totalTagihan: totalTagihan,
                                            jumlahTagihan: jumlahTagihan,
                                            actions: tutup,
                                          ),
                                          formSimpanNomor(nomorTujuan.text, '1')
                                        ],
                                      )
                                    : Container()
                                : cpdam.contains(widget.data['kode'])
                                    ? isDataPelanggan
                                        ? Column(
                                            children: [
                                              DetailTagihanPascaBayar(
                                                namaPelanggan: namaPelanggan,
                                                jumlahTagihan: jumlahTagihan,
                                                biayaAdmin: biayaAdmin,
                                                totalTagihan: totalTagihan,
                                                jumlahBulan: jumlahBulan,
                                                periode: periode,
                                                standMeteran: standMeteran,
                                                actions: tutup,
                                              ),
                                              formSimpanNomor(
                                                  nomorTujuan.text, '3')
                                            ],
                                          )
                                        : Container()
                                    : cpln.contains(widget.data['kode'])
                                        ? isDataPelanggan
                                            ? Column(
                                                children: [
                                                  DetailTagihanPascaBayar(
                                                    namaPelanggan:
                                                        namaPelanggan,
                                                    jumlahTagihan:
                                                        jumlahTagihan,
                                                    biayaAdmin: biayaAdmin,
                                                    totalTagihan: totalTagihan,
                                                    periode: periode,
                                                    standMeteran: standMeteran,
                                                    actions: tutup,
                                                  ),
                                                  formSimpanNomor(
                                                      nomorTujuan.text, '2')
                                                ],
                                              )
                                            : Container()
                                        : cfinance.contains(widget.data['kode'])
                                            ? isDataPelanggan
                                                ? Column(
                                                    children: [
                                                      DetailTagihanPascaBayar(
                                                        namaPelanggan:
                                                            namaPelanggan,
                                                        angsuranKe: angsuranKe,
                                                        periode: periode,
                                                        jumlahTagihan:
                                                            jumlahTagihan,
                                                        biayaAdmin: biayaAdmin,
                                                        totalTagihan:
                                                            totalTagihan,
                                                        actions: tutup,
                                                      ),
                                                      formSimpanNomor(
                                                          nomorTujuan.text, '5')
                                                    ],
                                                  )
                                                : Container()
                                            : ctelkom.contains(
                                                    widget.data['kode'])
                                                ? isDataPelanggan
                                                    ? Column(
                                                        children: [
                                                          DetailTagihanPascaBayar(
                                                            periode: periode,
                                                            namaPelanggan:
                                                                namaPelanggan,
                                                            biller: biller,
                                                            jumlahBulan:
                                                                jumlahBulan,
                                                            biayaAdmin:
                                                                biayaAdmin,
                                                            totalTagihan:
                                                                totalTagihan,
                                                            jumlahTagihan:
                                                                jumlahTagihan,
                                                            actions: tutup,
                                                          ),
                                                          formSimpanNomor(
                                                              nomorTujuan.text,
                                                              '4')
                                                        ],
                                                      )
                                                    : Container()
                                                : cgas.contains(
                                                        widget.data['kode'])
                                                    ? isDataPelanggan
                                                        ? Column(
                                                            children: [
                                                              DetailTagihanPascaBayar(
                                                                namaPelanggan:
                                                                    namaPelanggan,
                                                                jumlahBulan:
                                                                    jumlahBulan,
                                                                periode:
                                                                    periode,
                                                                jumlahTagihan:
                                                                    jumlahTagihan,
                                                                biayaAdmin:
                                                                    biayaAdmin,
                                                                totalTagihan:
                                                                    totalTagihan,
                                                                actions: tutup,
                                                              ),
                                                              formSimpanNomor(
                                                                  nomorTujuan
                                                                      .text,
                                                                  '6')
                                                            ],
                                                          )
                                                        : Container()
                                                    : cinternet.contains(
                                                            widget.data['kode'])
                                                        ? isDataPelanggan
                                                            ? Column(
                                                                children: [
                                                                  DetailTagihanPascaBayar(
                                                                    namaPelanggan:
                                                                        namaPelanggan,
                                                                    jumlahBulan:
                                                                        jumlahBulan,
                                                                    periode:
                                                                        periode,
                                                                    jumlahTagihan:
                                                                        jumlahTagihan,
                                                                    biayaAdmin:
                                                                        biayaAdmin,
                                                                    totalTagihan:
                                                                        totalTagihan,
                                                                    actions:
                                                                        tutup,
                                                                  ),
                                                                  formSimpanNomor(
                                                                      nomorTujuan
                                                                          .text,
                                                                      '4')
                                                                ],
                                                              )
                                                            : Container()
                                                        : widget.data['kode'] ==
                                                                'CBPJS'
                                                            ? isDataPelanggan
                                                                ? Column(
                                                                    children: [
                                                                      DetailTagihanPascaBayar(
                                                                        namaPelanggan:
                                                                            namaPelanggan,
                                                                        jumlahTagihan:
                                                                            jumlahTagihan,
                                                                        jumlahPeserta:
                                                                            jumlahPeserta,
                                                                        cabang:
                                                                            cabang,
                                                                        jumlahBulan:
                                                                            jumlahBulan,
                                                                        biayaAdmin:
                                                                            biayaAdmin,
                                                                        actions:
                                                                            tutup,
                                                                      ),
                                                                      formSimpanNomor(
                                                                          nomorTujuan
                                                                              .text,
                                                                          '8')
                                                                    ],
                                                                  )
                                                                : Container()
                                                            : Container()
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          buttonCek
              ? Positioned(
                  bottom: 10.0,
                  right: 10.0,
                  child: Container(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formCekTagihan.currentState.validate()) {
                          _cekTagihan();
                        }
                      },
                      child: Text('Cek Tagihan'),
                    ),
                  ))
              : Container(),
          buttonBayar
              ? Positioned(
                  bottom: 10.0,
                  right: 10.0,
                  child: Container(
                    child: ElevatedButton(
                      onPressed: () {
                        bayarTagihan();
                      },
                      child: Text('Bayar Tagihan'),
                    ),
                  ))
              : Container()
        ],
      ),
    );
  }

  Widget formSimpanNomor(String nomor, String type) {
    TextEditingController nomorTujuan = new TextEditingController();
    TextEditingController nama = new TextEditingController();
    final _formSaveNumber = GlobalKey<FormState>();
    nomorTujuan = TextEditingController(text: nomor ?? '');
    return Container(
      padding: EdgeInsets.all(10),
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(1.0, 8.0), //(x,y)
              blurRadius: 10.0,
            )
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Simpan Nomor',
                  style: TextStyle(
                      color: Warna.warna(biru),
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0)),
              Icon(Icons.save_alt_rounded, color: Warna.warna(biru))
            ],
          ),
          const Divider(
            color: Colors.grey,
            height: 0,
            thickness: 0.5,
            indent: 0,
            endIndent: 0,
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
          ),
          TextFormField(
            controller: nomorTujuan,
            readOnly: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: 'Nomor Tujuan',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.contact_phone)),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
          ),
          Form(
            key: _formSaveNumber,
            child: TextFormField(
              controller: nama,
              validator: (nama) {
                if (nama.isEmpty) {
                  return 'Nama Tidak Boleh Kosong';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person)),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                if (_formSaveNumber.currentState.validate()) {
                  simpan(nomor, nama.text, type);
                }
              },
              child: Text('Simpan'))
        ],
      ),
    );
  }
}
