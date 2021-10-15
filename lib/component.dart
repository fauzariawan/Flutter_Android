import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:http/http.dart' as http;
import 'listWarna.dart';
import 'main.dart';

class Token {
  static getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    return token;
  }
}

class GreenBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class CardMenu extends StatelessWidget {
  CardMenu({this.route, this.data, this.title, this.description, this.catatan});
  final String route;
  final String title;
  final String description;
  final dynamic data;
  final String catatan;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(data['catatan']);
        if (data['title'] == 'Paket Nelpon' || data['title'] == 'Paket SMS') {
          print(data['kode']);
          Navigator.pushNamed(context, route, arguments: data);
        } else {
          print(data['kode']);
          Navigator.pushNamed(context, route, arguments: [null, data]);
        }
      },
      child: Container(
        margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
        decoration: decoration,
        // elevation: 5,
        // // shadowColor: Colors.blue,
        // semanticContainer: false,
        // margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
        // shape: RoundedRectangleBorder(
        //   side: BorderSide(color: Colors.white, width: 1),
        //   borderRadius: BorderRadius.circular(10),
        // ),
        child: Row(
          children: <Widget>[
            data['kode'] != null
                ? data['kode'] == 'pn' || data['kode'] == 'ps'
                    ? Format.iconNetwork(data['apk_ikon'])
                    : data['apk_ikon'] == null
                        ? Text('no pic')
                        : Format.iconNetwork(data['apk_ikon'])
                : Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(Icons.access_alarm_outlined,
                        color: Warna.warna(kuning)),
                  ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(
                  height: 5,
                ),
                if (data['catatan'] != null)
                  Text(data['catatan'],
                      style: TextStyle(fontSize: 10, color: Colors.white60))
                // Container(
                //   // width: MediaQuery.of(context).size.width,
                //   child: Text(
                //     description,
                //     textAlign: TextAlign.justify,
                //     style: TextStyle(fontSize: 10, color: Colors.white),
                //   ),
                // )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CardRekening extends StatelessWidget {
  CardRekening({this.namaBank, this.noRek, this.pemilikRek, this.status});
  final String namaBank;
  final String noRek;
  final String pemilikRek;
  final String status;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(new ClipboardData(text: noRek));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('No Rekening Berhasil di Copy'),
        ));
      },
      child: Card(
        elevation: 10,
        // shadowColor: Colors.blue,
        semanticContainer: false,
        margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(namaBank,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    Text(noRek,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(pemilikRek,
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text(status,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[300]))
                    ])
              ],
            )),
      ),
    );
  }
}

class CardHistory extends StatelessWidget {
  CardHistory({this.tujuan, this.namaProduk, this.hargaJual, this.status});
  final String tujuan;
  final String namaProduk;
  final int hargaJual;
  final int status;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      // shadowColor: Colors.blue,
      semanticContainer: false,
      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Row(children: <Widget>[
                  status == 20
                      ? Icon(
                          Icons.done_all,
                          color: Colors.green[600],
                        )
                      : status == 40
                          ? Icon(Icons.close, color: Colors.red[600])
                          : status == 55
                              ? Icon(Icons.timer, color: Colors.red[600])
                              : status == 43
                                  ? Icon(Icons.money_off,
                                      color: Colors.yellow[600])
                                  : Icon(Icons.question_answer),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(tujuan),
                      SizedBox(height: 10),
                      Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: Text(namaProduk))
                    ],
                  ),
                ]),
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(NumberFormat.currency(
                            locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                        .format(hargaJual)),
                    SizedBox(height: 10),
                    status == 20
                        ? Text('Berhasil',
                            style: TextStyle(
                                color: Colors.green[600],
                                fontWeight: FontWeight.bold))
                        : status == 40
                            ? Text('Gagal',
                                style: TextStyle(
                                    color: Colors.red[600],
                                    fontWeight: FontWeight.bold))
                            : status == 2 || status == 3
                                ? Text('Dalam Proses',
                                    style: TextStyle(
                                        color: Warna.warna(kuning),
                                        fontWeight: FontWeight.bold))
                                : status == 55
                                    ? Text('Time Out',
                                        style: TextStyle(
                                            color: Colors.red[600],
                                            fontWeight: FontWeight.bold))
                                    : status == 43
                                        ? Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4,
                                            child: Text('Saldo Tidak Cukup',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    color: Warna.warna(kuning),
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          )
                                        : Text(status.toString())
                  ])
            ],
          )),
    );
  }
}

// ignore: must_be_immutable
class CardDeposit extends StatelessWidget {
  // status
  CardDeposit({this.data});
  final dynamic data;
  String tanggal;
  DateTime now = DateTime.now();
  // DateTime tanggal = DateTime.now();
  var secondsToAdd = Duration(hours: 2);

//   bool isAfterToday(Timestamp timestamp) {
//     return DateTime.now().toUtc().isAfter(
//         DateTime.fromMillisecondsSinceEpoch(
//             timestamp.millisecondsSinceEpoch,
//             isUtc: false,
//         ).toUtc(),
//     );
// }

  // nominal: allItem[i]['jumlah'], tanggal: allItem[i]['waktu'], status: allItem[i]['status']
  @override
  Widget build(BuildContext context) {
    DateTime parseDate =
        new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(data['waktu']);
    var tanggalKadaluarsa = DateTime.parse(data["waktu"]).add(secondsToAdd);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd/MMMM/yyyy hh:mm a');
    var outputDate = outputFormat.format(inputDate);
    tanggal = outputDate;
    return Card(
      elevation: 10,
      // shadowColor: Colors.blue,
      semanticContainer: false,
      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Row(children: <Widget>[
                  data['status'] == 'B'
                      ? Icon(
                          Icons.done_all,
                          color: Colors.green[600],
                        )
                      : data['status'] == 'C'
                          ? Icon(Icons.close, color: Colors.red[600])
                          : data['status'] == 'O'
                              ? Icon(Icons.pending)
                              : Icon(Icons.question_answer),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(NumberFormat.currency(
                              locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                          .format(data['jumlah'])),
                      SizedBox(height: 10),
                      Text(tanggal)
                    ],
                  ),
                ]),
              ),
              Column(children: <Widget>[
                data['status'] == 'B' || data['status'] == 'S'
                    ? Text('Berhasil',
                        style: TextStyle(
                            color: Colors.green[600],
                            fontWeight: FontWeight.bold))
                    : data['status'] == 'C' || now.isAfter(tanggalKadaluarsa)
                        ? Text('Gagal',
                            style: TextStyle(
                                color: Colors.red[600],
                                fontWeight: FontWeight.bold))
                        : data['status'] == 'O'
                            ? Text('Pending',
                                style: TextStyle(
                                    color: Colors.yellow[600],
                                    fontWeight: FontWeight.bold))
                            : Text(data['status']),
              ])
            ],
          )),
    );
  }
}

// ignore: must_be_immutable
class CardMutasi extends StatelessWidget {
  CardMutasi({this.keterangan, this.tanggal, this.jumlah});
  final String keterangan;
  String tanggal;
  final int jumlah;
  bool isPositif = false;
  @override
  Widget build(BuildContext context) {
    DateTime parseDate =
        new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(tanggal);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd/MMMM/yyyy hh:mm a');
    var outputDate = outputFormat.format(inputDate);
    tanggal = outputDate;
    if (jumlah > 0) {
      isPositif = true;
    } else {
      isPositif = false;
    }
    return Card(
      elevation: 10,
      // shadowColor: Colors.blue,
      semanticContainer: false,
      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(children: <Widget>[
                isPositif == true
                    ? Icon(
                        Icons.move_to_inbox,
                        color: Colors.green,
                      )
                    : Icon(Icons.outbox_rounded, color: Colors.red),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width / 2 + 20,
                        child: Text(keterangan)),
                    SizedBox(height: 10),
                    Text(tanggal)
                  ],
                ),
              ]),
              Column(children: <Widget>[
                Text(
                  NumberFormat.currency(
                          locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                      .format(jumlah),
                  style:
                      TextStyle(color: isPositif ? Colors.green : Colors.red),
                )
              ])
            ],
          )),
    );
  }
}

// ignore: must_be_immutable
class CardNotif extends StatelessWidget {
  CardNotif({this.pesan, this.tanggal});
  final String pesan;
  String tanggal;
  @override
  Widget build(BuildContext context) {
    DateTime parseDate =
        new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(tanggal);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd/MMMM/yyyy hh:mm a');
    var outputDate = outputFormat.format(inputDate);
    tanggal = outputDate;
    return Card(
      elevation: 10,
      // shadowColor: Colors.blue,
      semanticContainer: false,
      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(children: <Widget>[
                Icon(Icons.notifications),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: Text(
                          pesan,
                          overflow: TextOverflow.ellipsis,
                        )),
                    SizedBox(height: 10),
                    Text(tanggal)
                  ],
                ),
              ]),
            ],
          )),
    );
  }
}

// ignore: must_be_immutable
class CardKomisi extends StatelessWidget {
  CardKomisi(
      {this.transaksi,
      this.idTransaksi,
      this.komisi,
      this.tanggal,
      this.isTukar});
  final String transaksi;
  final String idTransaksi;
  final int komisi;
  final int isTukar;
  String tanggal;
  @override
  Widget build(BuildContext context) {
    if (tanggal == null) {
    } else {
      DateTime parseDate =
          new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(tanggal);
      var inputDate = DateTime.parse(parseDate.toString());
      var outputFormat = DateFormat('dd/MMMM/yyyy hh:mm:ss');
      var outputDate = outputFormat.format(inputDate);
      tanggal = outputDate;
    }
    return GestureDetector(
        onTap: () {},
        child: Container(
            margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: Warna.warna(kuning), offset: Offset(0, 5))
                ]),
            // elevation: 10,
            // // shadowColor: Colors.blue,
            // semanticContainer: false,
            // margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
            // shape: RoundedRectangleBorder(
            //   side: BorderSide(color: Colors.white, width: 1),
            //   borderRadius: BorderRadius.circular(10),
            // ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: Text(transaksi,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          komisi == null
                              ? Text('RP. 0')
                              : Text(NumberFormat.currency(
                                      locale: 'id',
                                      decimalDigits: 0,
                                      symbol: 'Rp. ')
                                  .format(komisi))
                        ]),
                    SizedBox(height: 10),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(idTransaksi),
                          isTukar == 0
                              ? Text(tanggal ?? 'data hilang')
                              : Text(' Sudah Di Tukar',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red))
                        ])
                  ]),
            )));
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        child: Center(
          child: SpinKitWave(
            color: Warna.warna(biru),
          ),
        ));
  }
}

class Matahari extends StatelessWidget {
  Matahari(
      {this.top,
      this.bottom,
      this.left,
      this.right,
      this.height,
      this.width,
      this.color});
  final double top;
  final double bottom;
  final double left;
  final double right;
  final double height;
  final double width;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        height: height,
        width: width,
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: color, boxShadow: [
          BoxShadow(
              offset: Offset(0, 0),
              blurRadius: 10,
              spreadRadius: 10,
              color: Colors.yellow)
        ]),
      ),
    );
  }
}

class FormatUang {
  static formatUang(nominal) {
    int panjang = nominal.text.length;
    String clearStr;
    var regex = new RegExp(r'[^0-9]'); // hapus semua kecuali 0-9
    clearStr = nominal.text.replaceAll(regex, '');
    print('ini dari format uang');
    print(clearStr);
    if (panjang >= 4) {
      var split = clearStr.split(',');
      var sisa = split[0].length % 3;
      var rupiah = split[0].substring(0, sisa);
      var cekRibuan = split[0].substring(sisa).split('');
      // print(cekRibuan);
      String group = ''; // untuk menampung "000"
      List ribuan = []; // untuk menampung ["000", "000", ..dst]
      String fix = ''; // untuk menampung hasil akhir "1.000.000"
      for (var i = 0; i <= cekRibuan.length; i++) {
        // print(group.length);
        if (group.length == 3) {
          ribuan.add(group);
          group = '';
          if (i < cekRibuan.length) {
            // untuk input angka terakhir
            group = '$group${cekRibuan[i]}';
          }
        } else {
          group = '$group${cekRibuan[i]}';
          // print(group);
        }
      }
      sisa == 0 ? fix = ribuan.join(".") : fix = '$rupiah.${ribuan.join(".")}';
      return fix;
    }
  }
}

class Reseller {
  static getReseller(String nomorTujuan) async {
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = "reseller/getReseller";
    final params = null;
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());

    return await http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {"noTelp": nomorTujuan});
  }
}

class Format {
  static formatTanggal(tanggal) {
    DateTime parseDate =
        new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(tanggal);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd/MMMM/yyyy HH:mm:ss');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static formatUang(nominal) {
    return Text(
        NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: 'Rp ')
            .format(nominal),
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold));
  }

  static iconNetwork(ikon) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, bottom: 10, right: 20),
      height: 40.0,
      width: 40.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        image: DecorationImage(
          image: NetworkImage(ikon),
          fit: BoxFit.fill,
        ),
        // shape: BoxShape.circle,
      ),
    );
  }

  static iconAsset(ikon) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, bottom: 10, right: 20),
      height: 50.0,
      width: 50.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        image: DecorationImage(
          image: AssetImage(ikon),
          fit: BoxFit.fill,
        ),
        // shape: BoxShape.circle,
      ),
    );
  }
}

class Warna {
  static warna(int warna) {
    Map<int, Color> color = {
      50: Color.fromRGBO(136, 14, 79, .1),
      100: Color.fromRGBO(136, 14, 79, .2),
      200: Color.fromRGBO(136, 14, 79, .3),
      300: Color.fromRGBO(136, 14, 79, .4),
      400: Color.fromRGBO(136, 14, 79, .5),
      500: Color.fromRGBO(136, 14, 79, .6),
      600: Color.fromRGBO(136, 14, 79, .7),
      700: Color.fromRGBO(136, 14, 79, .8),
      800: Color.fromRGBO(136, 14, 79, .9),
      900: Color.fromRGBO(136, 14, 79, 1),
    };
    MaterialColor colorCustom = MaterialColor(warna, color);
    return colorCustom;
  }
}

class Pangkat extends CustomPainter {
  Pangkat({this.fill, this.height});
  final Color fill;
  final double height;
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = fill
      ..strokeWidth = 5
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, 100);
    path.lineTo(size.width / 2, height);
    path.lineTo(0, 100);
    path.lineTo(0, 0);
    // path.lineTo(size.width / 2, 0);
    // path.lineTo(0, size.height / 2);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class CustomPangkat extends CustomPainter {
  CustomPangkat({this.fill, this.height});
  final Color fill;
  final double height;
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = fill
      ..strokeWidth = 5
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, 10);
    path.lineTo(size.width / 2, height);
    path.lineTo(0, 10);
    path.lineTo(0, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class PangkatPendek extends StatelessWidget {
  PangkatPendek({this.height});
  final double height;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 10,
          child: CustomPaint(
            painter: CustomPangkat(fill: Warna.warna(kuning), height: height),
            size: Size(MediaQuery.of(context).size.width,
                100), // kalau ada child maka size akan mengikuti child nya
          ),
        ),
        CustomPaint(
            painter: CustomPangkat(fill: Warna.warna(biru), height: height),
            size: Size(MediaQuery.of(context).size.width, 110)),
      ],
    );
  }
}

BoxDecoration decoration = BoxDecoration(
    color: Warna.warna(biru),
    borderRadius: BorderRadius.circular(10),
    boxShadow: [BoxShadow(color: Warna.warna(kuning), offset: Offset(0, 5))]);

class ContactList {
  static pickContact() async {
    try {
      List<Contact> _contact;
      List<dynamic> phonebook = [];

      _contact = (await ContactsService.getContacts(
              withThumbnails: false, iOSLocalizedLabels: iOSLocalizedLabels))
          .toList();
      _contact.forEach((contact) {
        contact.phones.toSet().forEach((phone) {
          print(phone.value);
          print(contact.displayName ?? contact.givenName);
          if (phone.value.contains("-")) {
            var regExp = new RegExp(r'[^0-9]');
            String clrStr = phone.value.replaceAll(regExp, '');
            phonebook.add({
              "nama":
                  "${contact.displayName.toUpperCase() ?? contact.givenName.toLowerCase()}",
              "noTelp": "$clrStr"
            });
          } else if (phone.value.contains("+")) {
            String newNumber =
                "0${phone.value.substring(3, phone.value.length)}";
            phonebook.add({
              "nama":
                  "${contact.displayName.toUpperCase() ?? contact.givenName.toLowerCase()}",
              "noTelp": "$newNumber"
            });
          } else {
            phonebook.add({
              "nama":
                  "${contact.displayName.toUpperCase() ?? contact.givenName.toLowerCase()}",
              "noTelp": "${phone.value}"
            });
          }
        });
      });
      return phonebook;
    } catch (e) {
      print(e.toString());
    }
  }
}

// ignore: must_be_immutable
class SimpanNomor extends StatelessWidget {
  SimpanNomor({Key key, this.nomorBawaan, this.type}) : super(key: key);
  final String nomorBawaan;
  final String type;
  TextEditingController nomorTujuan = new TextEditingController();
  TextEditingController nama = new TextEditingController();

  simpan() {
    print(nomorBawaan);
    print(type);
    print(nama.text);
  }

  @override
  Widget build(BuildContext context) {
    nomorTujuan = TextEditingController(text: nomorBawaan ?? '');
    // nama = TextEditingController(text: nama ?? '');
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
          TextFormField(
            controller: nama,
            decoration: InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person)),
          ),
          ElevatedButton(
              onPressed: () {
                simpan();
              },
              child: Text('Simpan'))
        ],
      ),
    );
  }
}

// detail tagihan pasca bayar
class DetailTagihanPascaBayar extends StatelessWidget {
  DetailTagihanPascaBayar(
      {this.namaPelanggan,
      this.biller,
      this.angsuranKe,
      this.jumlahBulan,
      this.biayaAdmin,
      this.totalTagihan,
      this.jumlahTagihan,
      this.periode,
      this.standMeteran,
      this.jumlahPeserta,
      this.cabang,
      this.actions});
  final String namaPelanggan;
  final String biller;
  final String angsuranKe;
  final String jumlahBulan;
  final String biayaAdmin;
  final String totalTagihan;
  final String jumlahTagihan;
  final String periode;
  final String standMeteran;
  final String jumlahPeserta;
  final String cabang;
  final GestureDetector actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.all(10.0),
          height: 300,
          decoration: BoxDecoration(
              color: Warna.warna(biru),
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey, blurRadius: 3, offset: Offset(1, 3))
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Informasi Tagihan',
                      style: TextStyle(
                          color: Warna.warna(kuning),
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold)),
                  actions
                ],
              ),
              Divider(
                thickness: 2,
                color: Warna.warna(kuning),
              ),
              if (namaPelanggan != null)
                RincianString(
                    subTitle: 'Nama Pelanggan', valueSubTitle: namaPelanggan),
              if (biller != null)
                RincianString(subTitle: 'Biller', valueSubTitle: biller),
              if (angsuranKe != null)
                RincianString(
                    subTitle: 'Angsuran Ke ', valueSubTitle: angsuranKe),
              if (jumlahBulan != null)
                RincianString(
                    subTitle: 'Jumlah Bulan', valueSubTitle: jumlahBulan),
              if (periode != null)
                RincianString(subTitle: 'Periode', valueSubTitle: periode),
              if (standMeteran != null)
                RincianString(
                    subTitle: 'Stand Meteran', valueSubTitle: standMeteran),
              if (jumlahTagihan != null)
                Rincian(
                    subTitle: 'Jumlah Tagihan', valueSubTitle: jumlahTagihan),
              if (jumlahPeserta != null)
                RincianString(
                    subTitle: 'Jumlah Peserta', valueSubTitle: jumlahPeserta),
              if (biayaAdmin != null)
                Rincian(subTitle: 'Biaya Admin', valueSubTitle: biayaAdmin),
              if (cabang != null)
                RincianString(subTitle: 'Cabang', valueSubTitle: cabang),
              if (totalTagihan != null)
                Rincian(
                  subTitle: 'Total Tagihan',
                  valueSubTitle: totalTagihan,
                )
            ],
          ),
        ),
      ],
    );
  }
}

class Rincian extends StatelessWidget {
  Rincian({this.subTitle, this.valueSubTitle});
  final String subTitle;
  final String valueSubTitle;
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(subTitle,
              style: TextStyle(color: Warna.warna(kuning), fontSize: 12.0)),
          Text(
              NumberFormat.currency(
                      locale: 'id', decimalDigits: 0, symbol: 'Rp. ')
                  .format(int.parse(valueSubTitle)),
              style: TextStyle(color: Colors.white))
        ]);
  }
}

class RincianString extends StatelessWidget {
  RincianString({this.subTitle, this.valueSubTitle});
  final subTitle;
  final valueSubTitle;
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(subTitle,
              style: TextStyle(color: Warna.warna(kuning), fontSize: 12.0)),
          Text(valueSubTitle,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
        ]);
  }
}

class LoadingShowDialog {
  static loading(BuildContext context) {
    showDialog(
        // barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Loading();
        });
  }
}
