import 'package:android/component.dart';
import 'package:android/listWarna.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

class DetailAlfamart extends StatefulWidget {
  const DetailAlfamart({Key key, this.data}) : super(key: key);
  final dynamic data;
  @override
  _DetailAlfamartState createState() => _DetailAlfamartState();
}

class _DetailAlfamartState extends State<DetailAlfamart> {
  String expiredTime;
  List lsExpiredTime; // untuk menampung expired time yang di split
  String _bwp; // Batas Waktu Pembayaran
  List _btp; // Batas Tanggal Pembayaran
  List reverseBtp;
  String btp;
  bool isExpired;
  DateTime now = DateTime.now().toUtc();
  // DateTime tanggalExpired;
  int endTime;
  external Duration get timeZoneOffset;

  void initState() {
    super.initState();
    expiredTime =
        widget.data['tiket_response']['expired_time'].substring(0, 23);
    print('ini expired time nya');
    print(expiredTime);
    // tanggalExpired =
    //     DateTime.parse(widget.data['tiket_response']['expired_time']).toUtc();
    lsExpiredTime = expiredTime.split('T');
    _btp = lsExpiredTime[0].split('-');
    reverseBtp = new List.from(_btp.reversed);
    btp = reverseBtp.join("/");
    print('<<<ini batas tanggal pembayaran>>>');
    print(_btp);
    String bwp = lsExpiredTime[1];
    _bwp = bwp.substring(0, 5);
    var jiffy4 = Jiffy(expiredTime);
    var jiffy5 = Jiffy(now);
    isExpired = jiffy4.diff(jiffy5, Units.SECOND).toString().contains(
        '-'); //now.isAfter(tanggalExpired);// kalau hasilnya minus berarti waktu nya sudah lewat
    print(isExpired);
    // Duration difference = tanggalExpired.difference(now);
    // final hasil = difference.inHours;
    // DateTime queryDate2 = DateTime.utc(
    //     now.year, now.month, now.day, now.hour, now.minute, now.second);
    // var timeleft = queryDate2.difference(now).inHours;
    // jiffy4.diff(jiffy5); // 86400000
    print('<<<ini selisih waktu nya>>>');
    print(jiffy4.diff(jiffy5, Units.SECOND));
    endTime = DateTime.now().millisecondsSinceEpoch +
        1000 * jiffy4.diff(jiffy5, Units.SECOND);
    print(endTime);

    // final diff_dy = tanggalExpired.difference(now).inDays;
    // final diff_hr = tanggalExpired.difference(now).inHours;
    // final diff_mn = tanggalExpired.difference(now).inMinutes;
    // final diff_sc = tanggalExpired
    //     .difference(now)
    //     .inSeconds; // mencari selisih antara dua waktu
    // print(tanggalExpired);
    // print(now);
    // print(diff_dy);
    // print(diff_hr);
    // print(diff_mn);
    // print(diff_sc);
    // int detik = diff_sc;
    // print(diff_dy);
    // print(diff_hr);
    // print(diff_mn);
    // print(diff_sc);
  }

  void onEnd() {
    setState(() {
      isExpired = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Detail Deposit'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: widget.data["kode_pembayaran"] == "QRIS"
                  ? Container()
                  : Row(
                      children: <Widget>[
                        ClipOval(
                          child: Image.asset(
                            'image/money.png',
                            width: 60,
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Nominal Yang Harus Anda Bayar (Rp)'),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                                NumberFormat.currency(
                                        locale: 'id',
                                        decimalDigits: 0,
                                        symbol: 'Rp ')
                                    .format(widget.data['tiket_response']
                                        ['total_amount']),
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold))
                            // Format.formatUang(
                            //     widget.data['tiket_response']['total_amount'])
                          ],
                        )
                      ],
                    ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Warna.warna(biru)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Batas Pembayaran',
                            style: TextStyle(color: Warna.warna(kuning))),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(btp,
                                style: TextStyle(color: Warna.warna(kuning))),
                            Text(' II ',
                                style: TextStyle(color: Warna.warna(kuning))),
                            Text('$_bwp WIB',
                                style: TextStyle(color: Warna.warna(kuning))),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    padding:
                        EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Warna.warna(biru)),
                    child: isExpired
                        ? Text(
                            'TIME OUT',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Warna.warna(kuning),
                              fontSize: 18,
                            ),
                          )
                        : Container(
                            child: Column(
                              children: [
                                Center(
                                  child: CountdownTimer(
                                    endTime: endTime,
                                    onEnd: onEnd,
                                    textStyle: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Warna.warna(kuning)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  )
                ],
              ),
            ),
            widget.data["kode_pembayaran"] == "QRIS"
                ? Container(
                    // margin: EdgeInsets.only(
                    //     top: 10, left: 10, bottom: 10, right: 20),
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        image: NetworkImage(
                            widget.data["tiket_response"]["image_qr"]),
                        fit: BoxFit.fill,
                      ),
                      // shape: BoxShape.circle,
                    ),
                  )
                : Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(
                            left: 10, top: 5, bottom: 5, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Status Pembayaran'),
                            widget.data['status'] == 'O'
                                ? Text('Menunggu Pembayaran',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold))
                                : widget.data['status'] == 'S'
                                    ? Text('Sudah Dibayar',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))
                                    : Text('Pembayaran Gagal',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Metode Pembayaran'),
                            Text(
                                widget.data['tiket_response']['payment_method'],
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Kode Pembayaran'),
                            Text(widget.data['tiket_response']['payment_code'],
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Kode Reff'),
                            Text(widget.data['tiket_response']['reff_id'],
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Status Tiket'),
                            Text('Online',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(
                            left: 10, top: 5, bottom: 5, right: 10),
                        margin: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: <Widget>[
                            Text('Detail Pembayaran',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Nominal'),
                                Format.formatUang(widget.data['jumlah'])
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Biaya Admin Funmo'),
                                Format.formatUang(0)
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                widget.data['tiket_response']
                                            ['payment_method'] ==
                                        'Alfamart'
                                    ? Text('Biaya Layanan Alfamart')
                                    : Text('Biaya Layanan Bank'),
                                Format.formatUang(widget.data['tiket_response']
                                            ['payment_method'] ==
                                        'Alfamart'
                                    ? 4000
                                    : 1500)
                              ],
                            ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Total Pembayaran'),
                                Format.formatUang(widget.data['tiket_response']
                                    ['total_amount'])
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  )
          ],
        ));
  }
}
