import 'dart:async';

import 'package:android/profilerouting/customerservice.dart';
import 'package:android/profilerouting/komisi.dart';
import 'package:android/routerName.dart';
import 'package:android/underMaintenance.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'component.dart';
import 'dashboard.dart';
import 'detailIklan.dart';
import 'informasi.dart';
import 'kirim.dart';
import 'menuutama/daftarReward.dart';
import 'listWarna.dart';
import 'menuutama/dompetDigital/customer.dart';
import 'menuutama/dompetDigital/driver.dart';
import 'menuutama/topup.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MenuUtama extends StatefulWidget {
  MenuUtama({Key key, this.iklan});
  final bool iklan;
  @override
  _MenuUtamaState createState() => _MenuUtamaState();
}

class _MenuUtamaState extends State<MenuUtama>
    with SingleTickerProviderStateMixin {
  final LocalStorage storage = new LocalStorage('localstorage_app');
  dynamic dataUser = {"tes": "test"}; // untuk awal
  int selectedIndex;
  // int _currentIndex = 0;
  String token;
  final formKey = GlobalKey<FormState>();
  TextEditingController nominalMarkup = new TextEditingController();
  String strNoTelp;
  String strPin;
  dynamic res;
  FocusNode noTelp;
  FocusNode pin;
  List<dynamic> banner = [];
  List<dynamic> info = [];
  List<dynamic> reward = [];
  List<dynamic> dataIklan = [];
  TabController controller;
  int viewIklan;

  // untuk membuat animation laoding pada Container
  AnimationController _controller;
  Animation<Color> animationOne;
  Animation<Color> animationTwo;

  List<dynamic> menu = [
    {
      "title": "Pulsa",
      "picture": "image/funmo/icon/Pulsa.png",
      "routing": pulsa,
      "data": [null, null]
    },
    {
      "title": "Promo",
      "picture": "image/funmo/icon/promo.png",
      "routing": "/operatorPromo"
    },
    {
      "title": "Paket Data",
      "picture": "image/funmo/icon/paketdata.png",
      "routing": "/paketdata"
    },
    {
      "title": "Telp & SMS",
      "picture": "image/funmo/icon/paket telp dan sms.png",
      "routing": "/telpDanSms"
    },
    {
      "title": "PLN",
      "picture": "image/funmo/icon/pln pascabayar.png",
      "routing": "/pln"
    },
    {
      "title": "BPJS",
      "picture": "image/funmo/icon/bpjs.png",
      "routing": cekTagihan,
      "data": [
        null,
        {"kode": "CBPJS", "nama": "BPJS"}
      ],
    },
    {
      "title": "Finance",
      "picture": "image/funmo/icon/finance.png",
      "routing": finance,
      "data": {"kode": "FIN", "nama": "Finance", "kriteria": "cek"}
    },
    {
      "title": "Pasca Bayar",
      "picture": "image/funmo/icon/pascabayar.png",
      "routing": finance,
      "data": {"kode": "TELP", "nama": "Pasca Bayar"}
    },
    {
      "title": "PDAM",
      "picture": "image/funmo/icon/pdam.png",
      "routing": finance,
      "data": {"kode": "PAM", "nama": "PDAM", "kriteria": "cek"}
    },
    {
      "title": "TELKOM",
      "picture": "image/funmo/icon/telkom.png",
      "routing": telkom
    },
    {
      "title": "Gas Alam",
      "picture": "image/funmo/icon/gas.png",
      "routing": gasAlam
    },
    {
      "title": "Dompet Digital",
      "picture": "image/funmo/icon/ewallet.png",
      "routing": "dompetDigital",
    },
    // {
    //   "title": "Map",
    //   "picture": "image/funmo/icon/gps.png",
    //   "routing": map
    // },
    {
      "title": "Games",
      "picture": "image/funmo/icon/game.png",
      "routing": listOperator,
      "data": {"kode": "7", "nama": "Games", "routing": produkPromo}
    },
    {
      "title": "E-Money",
      "picture": "image/funmo/icon/emoney.png",
      "routing": listOperator,
      "data": {"kode": "5", "nama": "E-Money", "routing": produkPromo}
    },
    {
      "title": "Lainnya",
      "picture": "image/funmo/icon/other.png",
      "routing": lainnya
    },
  ];

  List<dynamic> menuLainnya = [
    {
      "title": "Roaming",
      "picture": "image/funmo/icon/roaming.png",
      "routing": listOperator,
      "data": {"kode": "9", "nama": "Roaming", "routing": produkPromo}
    },
    {
      "title": "Internet",
      "picture": "image/funmo/icon/tv.png",
      "routing": finance,
      "data": {"kode": "inet", "nama": "Internet", "kriteria": "cek"}
    },
    // {
    //   "title": "TV Prabayar",
    //   "picture": "image/funmo/icon/tv.png",
    //   "routing": listOperator,
    //   "data": {"kode": "12", "nama": "TV Prabayar", "routing": finance}
    // },
    {
      "title": "Pulsa Internasional",
      "picture": "image/funmo/icon/internasional.png",
      "routing": listOperator,
      "data": {
        "kode": "11",
        "nama": "Pulsa Internasional",
        "routing": produkPromo
      }
    },
    {
      "title": "PBB",
      "picture": "image/funmo/icon/pbb.png",
      "routing": finance,
      "data": {
        "kode": "pbb",
        "nama": "PBB",
        "routing": finance,
        "data": {"kode": "pbb", "nama": "Internet"}
      }
    },
    {
      "title": "Entertaiment",
      "picture": "image/funmo/icon/entertainment.png",
      "routing": listOperator,
      "data": {"kode": "8", "nama": "Entertaiment", "routing": produkPromo}
    },
  ];

  _response(String pesan) {
    showDialog(
        barrierDismissible: true,
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

  iklan() async {
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = "olahdata/promo";
    final params = null;
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());
    var response = await http.get(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"});
    if (response.statusCode == 200) {
      dataIklan = json.decode(response.body);
      if (dataIklan.length > 0) {
        if (await canLaunch(dataIklan[0]["img_flash"]))
          showDialog(
              barrierColor: Colors.black12,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  contentPadding: EdgeInsets.all(0),
                  content: CachedNetworkImage(
                    height: MediaQuery.of(context).size.width * 0.8,
                    width: MediaQuery.of(context).size.width * 0.8,
                    imageUrl: dataIklan[0]["img_flash"],
                    placeholder: (context, url) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 100, vertical:100),
                      child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  // Container(
                  //   height: MediaQuery.of(context).size.width * 0.8,
                  //   width: MediaQuery.of(context).size.width * 0.8,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(5),
                  //     image: DecorationImage(
                  //       image: NetworkImage(dataIklan[0]["img_flash"]),
                  //       fit: BoxFit.fill,
                  //     ),
                  //     // shape: BoxShape.circle,
                  //   ),
                  // ),
                  actions: <Widget>[
                    Center(
                        child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      DetailIklan(data: dataIklan[0])));
                            },
                            child: Text('Info Lebih Lanjut')))
                  ],
                );
              });
        else
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Text('Cannot Launch Url');
              });
      }
      print(dataIklan);
    } else {
      return null;
    }
  }

  Timer timer;

  tampilkanPromo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isTampil = prefs.containsKey('promo');
    print('apakah sudah tampil ? $isTampil');
    if (isTampil == false) {
      iklan();
      prefs.setBool("promo", true);
    }
  }
  // void onResume() {
  //   iklan();
  // }

  void initState() {
    super.initState();
    tampilkanPromo();
    loadData();
    _controller = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    animationOne =
        ColorTween(begin: Warna.warna(kuning), end: Warna.warna(biru))
            .animate(_controller);
    animationTwo =
        ColorTween(begin: Warna.warna(biru), end: Warna.warna(kuning))
            .animate(_controller);

    // untuk memulai animation
    _controller.repeat(
        max:
            1); // agar tidak ada error '_lifecycleState != _ElementLifecycle.defunct': is not true.
    _controller.forward();

    // untuk mengetahui setiap perubahan yang terjadi pada animasi
    _controller.addListener(() {
      if (_controller.status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (_controller.status == AnimationStatus.dismissed) {
        _controller.forward();
      }
      this.setState(() {});
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  loadData() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic fixDataUser = await callDataUser();
    print(fixDataUser);
    if (fixDataUser != null &&
        storage.getItem('banner') != null &&
        storage.getItem('info') != null &&
        storage.getItem('reward') != null) {
      print('banner, info, reward, diambil dari localstorage');
      setState(() {
        dataUser = fixDataUser;
        banner = json.decode(storage.getItem('banner'));
        info = json.decode(storage.getItem('info'));
        reward = json.decode(storage.getItem('reward'));
      });
    } else {
      List<dynamic> fixBanner = await callBanner();
      List<dynamic> fixInfo = await callInfo();
      List<dynamic> fixReward = await callReward();
      if (fixDataUser != null &&
          fixBanner != null &&
          fixInfo != null &&
          fixReward != null) {
        print('banner, info, reward, diambil dari database');
        setState(() {
          dataUser = fixDataUser; //json.decode(tesdataUser);
          banner = fixBanner;
          info = fixInfo;
          reward = fixReward;
        });
      }
    }
  }

  callDataUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = "reseller/getReseller";
    final params = null;
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());
    var response = await http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {"token": token});
    if (response.statusCode == 200) {
      prefs.setString('dataUser', response.body);
      storage.setItem('dataUser', response.body);
      dataUser = json.decode(response.body);
      return dataUser;
    } else {
      return null;
    }
  }

  callBanner() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = "olahdata/banner";
    final params = null;
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());
    var response = await http.get(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"});
    if (response.statusCode == 200) {
      // prefs.setString('banner', response.body);
      storage.setItem('banner', response.body);
      banner = json.decode(response.body);
      return banner;
    } else {
      return null;
    }
  }

  callInfo() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = "olahdata/info";
    final params = null;
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());

    var response = await http.get(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"});

    if (response.statusCode == 200) {
      // prefs.setString('info', response.body);
      storage.setItem('info', response.body);
      info = json.decode(response.body);
      return info;
    } else {
      return null;
    }
  }

  callReward() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = "reseller/reward";
    final params = null;
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());
    var response = await http.get(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"});
    if (response.statusCode == 200) {
      // prefs.setString('reward', response.body);
      storage.setItem('reward', response.body);
      reward = json.decode(response.body);
      return reward;
    } else {
      return null;
    }
  }

  // void dispose() {

  //   super.dispose();
  // }

  getCurrentLocation() async {}

  dompetDigital() {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          // side: BorderSide(color: Colors.white, width: 1),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        context: context,
        builder: (BuildContext context) {
          return DefaultTabController(
              length: 2,
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 150),
                decoration: BoxDecoration(
                  // color: colorPrimary,
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18.0),
                    topRight: Radius.circular(18.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Scaffold(
                    appBar: TabBar(
                        // labelColor: Warna.warna(kuning),
                        tabs: [
                          Tab(
                              icon:
                                  Icon(Icons.person, color: Warna.warna(biru)),
                              child: Text('Customer',
                                  style:
                                      TextStyle(color: Warna.warna(kuning)))),
                          Tab(
                              icon: Icon(Icons.drive_eta,
                                  color: Warna.warna(biru)),
                              child: Text('Driver',
                                  style: TextStyle(color: Warna.warna(kuning))))
                        ]),
                    body: TabBarView(
                      children: [
                        Customer(data: {'kriteria': "6c"}),
                        Driver(data: {'kriteria': "6d"})
                      ],
                    ),
                  ),
                ),
              ));
        });
  }

  _menuLainnya() {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          // side: BorderSide(color: Colors.white, width: 1),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        context: context,
        builder: (BuildContext context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2,
            // margin: EdgeInsets.only(top: 200),
            decoration: BoxDecoration(
              // color: colorPrimary,
              color: Colors.grey[50],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0),
              ),
            ),
            child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,
                    mainAxisExtent: 100),
                itemCount: menuLainnya.length,
                itemBuilder: (BuildContext context, i) {
                  return GestureDetector(
                    onTap: () {
                      // if (menuLainnya[i]['title'] == 'TV Pasca') {
                      //   Navigator.of(context).push(MaterialPageRoute(
                      //       builder: (context) => UnderMaintenance()));
                      // } else {
                      menuLainnya[i]['data'] == null
                          ? Navigator.pushNamed(
                              context, menuLainnya[i]['routing'])
                          : Navigator.pushNamed(
                              context, menuLainnya[i]['routing'],
                              arguments: menuLainnya[i]['data']);
                      // }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.asset(
                            menuLainnya[i]['picture'],
                            fit: BoxFit.fill,
                            width: 70,
                          ),
                        ),
                        Center(
                          child: Text(menuLainnya[i]['title'],
                              style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  color: Warna.warna(biru)),
                              textAlign: TextAlign.center),
                        ),
                      ],
                    ),
                  );
                }),
          );
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
    Navigator.pop(context);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Dashboard(
              selected: 0,
            )));
  }

  cekVerifikasiUser() async {
    print(dataUser['oid']);
    switch (dataUser['oid']) {
      case '02':
        _response('Data Yang Anda Kirim Sedang Kami Proses...');
        break;
      case '01':
        _response('Data Yang Anda Kirim Ditolak, Mohon Kirim Data Yang Benar');
        break;
      case '00':
        dompetDigital();
        break;
      default:
        _response(
            'Silahkan Verifikasi Data Anda Sebelum Menggunakan Layanan Dompet Digital !!!');
        break;
    }
  }

  tambahSaldoDownline(String destiny, String pin) async {
    loading();
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = "inbox/inboxbalancecross";
    final params = null;
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());

    var response = await http.post(url, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "token": storage.getItem('token')
    }, body: {
      "destiny": destiny,
      "nominal": nominalMarkup.text,
      "pin": pin
    });
    if (response.statusCode == 200) {
      res = json.decode(response.body);
      if (res['rc'] == '01' || res['rc'] == '02') {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(res['pesan']),
        ));
      } else {
        print(res);
        Navigator.pop(context);
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('TRANSFER SALDO BERHASIL'),
                content: Text(res['pesan']),
              );
            });
        Timer(Duration(seconds: 3), complete);
      }
    } else {
      print(response.body);
    }
  }

  changeFormat() {
    String fix = FormatUang.formatUang(nominalMarkup);
    final val = TextSelection.collapsed(
        offset: fix.length); // to set cursor position at the end of the value
    setState(() {
      nominalMarkup.text = 'Rp. $fix';
      nominalMarkup.selection =
          val; // to set cursor position at the end of the value
    });
  }

  bool get wantKeepAlive => true;

  // Future<bool> _hideGlow(OverscrollIndicatorNotification overscroll) {
  //   overscroll.disallowGlow();
  // }
  Future<void> refreshPage() async {
    await Future.delayed(Duration(milliseconds: 500));
    dynamic fixDataUser = await callDataUser();
    setState(() {
      dataUser = fixDataUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return Scaffold(
        body: NotificationListener<OverscrollIndicatorNotification>(
      // ignore: missing_return
      onNotification: (overscroll) {
        overscroll.disallowGlow();
      },
      child: RefreshIndicator(
        onRefresh: refreshPage,
        child: ListView(
          children: [
            Stack(
              children: [
                Positioned(
                  top: 10,
                  child: CustomPaint(
                    painter: Pangkat(fill: Warna.warna(kuning), height: 300),
                    size: Size(MediaQuery.of(context).size.width,
                        100), // kalau ada child maka size akan mengikuti child nya
                  ),
                ),
                CustomPaint(
                    painter: Pangkat(fill: Warna.warna(biru), height: 300),
                    size: Size(MediaQuery.of(context).size.width, 110)),
                dataUser['nama'] == null
                    ? ShaderMask(
                        shaderCallback: (rect) {
                          return LinearGradient(colors: [
                            animationOne.value,
                            animationTwo.value
                          ]).createShader(rect);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  width: MediaQuery.of(context).size.width / 4 +
                                      30,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: Colors.white,
                                  )),
                              SizedBox(height: 5),
                              Container(
                                  width: MediaQuery.of(context).size.width / 4 +
                                      50,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: Colors.white,
                                  )),
                              SizedBox(height: 5),
                              Container(
                                  width: MediaQuery.of(context).size.width / 6,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: Colors.white,
                                  )),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width / 2,
                                padding: EdgeInsets.only(left: 7),
                                child: dataUser['nama'] == null
                                    ? Container()
                                    : Text(
                                        dataUser['nama'],
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.white,
                                        ),
                                      )),
                            Container(
                              padding: EdgeInsets.only(left: 7),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    height: 40,
                                    child: Text(
                                      "Rp ",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  dataUser['saldo'] == null
                                      ? LoadData(
                                          ukuran: 20,
                                        )
                                      : Text(
                                          NumberFormat.currency(
                                                  locale: 'id',
                                                  symbol: '',
                                                  decimalDigits: 0)
                                              .format(
                                            dataUser['saldo'],
                                          ),
                                          style: TextStyle(
                                            fontSize: 40.0,
                                            fontWeight: FontWeight.bold,
                                            color: Warna.warna(kuning),
                                          ),
                                        )
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 7),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'Poin ',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                      dataUser['poin'] == null
                                          ? '0'
                                          : dataUser['poin'].toString(),
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Warna.warna(kuning),
                                      )),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Warna.warna(
                            kuning) /*Colors.grey.withOpacity(0.5)*/,
                        offset: Offset(0, 3),
                        blurRadius: 0)
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Topup()));
                      },
                      child: MenuBox(
                          str: "TopUp",
                          urlImage: 'image/funmo/icon/topup2.png')),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Kirim /*KirimSaldo*/ ()));
                      },
                      child: MenuBox(
                          str: "Kirim",
                          urlImage: 'image/funmo/icon/transfer.png')),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DaftarReward()));
                      },
                      child: MenuBox(
                          str: "Reward",
                          urlImage: 'image/funmo/icon/reward.png')),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Komisi()));
                      },
                      child: MenuBox(
                          str: "Komisi",
                          urlImage: 'image/funmo/icon/komisi.png')),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CustomerService()));
                      },
                      child: MenuBox(
                          str: "Bantuan", urlImage: 'image/funmo/icon/cs.png')),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[350],
                        offset: Offset(2, 3),
                        blurRadius: 10)
                  ]),
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: AnimationLimiter(
                child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing:
                          0, // memberikan jarang yang bawah dan atas
                      // crossAxisSpacing: 0,
                      mainAxisExtent:
                          MediaQuery.of(context).size.width > 500 ? 200 : 100,
                      // childAspectRatio: 1
                    ),
                    itemCount: menu.length,
                    itemBuilder: (BuildContext context, i) {
                      return AnimationConfiguration.staggeredGrid(
                        columnCount: menu.length,
                        position: i,
                        duration: const Duration(milliseconds: 500),
                        child: ScaleAnimation(
                          scale: 0.5,
                          child: FadeInAnimation(
                            child: GestureDetector(
                              onTap: () {
                                if (menu[i]['routing'] == 'dompetDigital') {
                                  cekVerifikasiUser();
                                } else if (menu[i]['routing'] == lainnya) {
                                  _menuLainnya();
                                } else {
                                  menu[i]['data'] == null
                                      ? Navigator.pushNamed(
                                          context, menu[i]['routing'])
                                      : Navigator.pushNamed(
                                          context, menu[i]['routing'],
                                          arguments: menu[i]['data']);
                                }
                              },
                              child: Column(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.asset(menu[i]['picture'],
                                        fit: BoxFit.fill,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    6 -
                                                5),
                                  ),
                                  Center(
                                    child: Text(menu[i]['title'],
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                            color: Warna.warna(biru)),
                                        textAlign: TextAlign.center),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
            banner.length == 0
                ? loadingBih(
                    firstColor: animationOne, secondColor: animationTwo)
                : CarouselSlider(
                    options: CarouselOptions(
                      aspectRatio: 20 / 8, // penggunaannya sama seperti height
                      viewportFraction: 0.8, // memberikan jarak antar image
                      initialPage:
                          1, // gambar yang pertama ditampilkan ketika load page
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 5),
                      autoPlayAnimationDuration: Duration(milliseconds: 1000),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      // onPageChanged: callbackFunction,
                      scrollDirection: Axis.horizontal,
                    ),
                    items: banner.map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                image: DecorationImage(
                                    image: NetworkImage(i['img_banner']),
                                    fit: BoxFit.cover)),
                          );
                        },
                      );
                    }).toList(),
                  ),
            Container(
              margin: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Info',
                      style: TextStyle(fontSize: 18, color: Warna.warna(biru))),
                  Text('Mengenal Lebih Jauh Aplikasi Funmobile',
                      style: TextStyle(fontSize: 15, color: Warna.warna(biru))),
                  SizedBox(height: 10),
                  info.length == 0
                      ? loadingBih(
                          firstColor: animationOne, secondColor: animationTwo)
                      : Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0, 5),
                                    blurRadius: 10)
                              ]),
                          child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: info.length,
                              itemBuilder: (context, i) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Informasi(data: info[i])));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Container(
                                          child: Row(children: <Widget>[
                                            info[i]['img_info'] == null
                                                ? Container(
                                                    width: 50,
                                                  )
                                                : ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                    child: Image.network(
                                                      info[i]['img_info'],
                                                      fit: BoxFit.cover,
                                                      width: 50,
                                                    ),
                                                  ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  info[i]['name_info'],
                                                  style: TextStyle(
                                                      color: Warna.warna(biru),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                ),
                                                SizedBox(height: 5),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          2 +
                                                      50,
                                                  child: info[i][
                                                              'content_info'] ==
                                                          null
                                                      ? Text(
                                                          info[i]['desc_info'])
                                                      : Text(
                                                          info[i]
                                                              ['content_info'],
                                                          textAlign:
                                                              TextAlign.justify,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 12)),
                                                )
                                              ],
                                            )
                                          ]),
                                        ),
                                        Icon(Icons.navigate_next_rounded,
                                            color: Warna.warna(biru))
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 10.0, bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Hadiah Unggulan',
                      style: TextStyle(fontSize: 18, color: Warna.warna(biru))),
                  Text('Reward Akan Di Berikan Ke Member Funmo',
                      style: TextStyle(fontSize: 15, color: Warna.warna(biru))),
                  SizedBox(height: 10),
                  reward.length == 0
                      ? loadingBih(
                          firstColor: animationOne, secondColor: animationTwo)
                      : CarouselSlider.builder(
                          itemCount: reward.length,
                          itemBuilder: itemBuilder,
                          options: options)
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }

  Widget itemBuilder(BuildContext context, int index, int realIndex) {
    return GestureDetector(
        onTap: () {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    'Tukar Reward',
                    style: TextStyle(
                        fontSize: 20,
                        color: Warna.warna(biru),
                        fontWeight: FontWeight.bold),
                  ),
                  content: Container(
                    height: MediaQuery.of(context).size.height / 2 - 100,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Nama',
                              style: TextStyle(
                                  fontSize: 12, color: Warna.warna(kuning))),
                          Text(reward[index]["nama"],
                              style: TextStyle(color: Warna.warna(biru))),
                          SizedBox(height: 10),
                          Text('Deskripsi',
                              style: TextStyle(
                                  fontSize: 12, color: Warna.warna(kuning))),
                          Text(reward[index]["hadiah_desc"]["h_desc"],
                              style: TextStyle(color: Warna.warna(biru))),
                          SizedBox(height: 10),
                          Text("Poin Dibutuhkan",
                              style: TextStyle(
                                  fontSize: 12, color: Warna.warna(kuning))),
                          Text(reward[index]["jml_poin"].toString(),
                              style: TextStyle(
                                  color: Warna.warna(biru),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20))
                        ]),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Tukarkan'),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Tutup'))
                  ],
                );
              });
        },
        child: Container(
          width: 130,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                  image: NetworkImage(reward[index]['hadiah_desc']['h_img']),
                  fit: BoxFit.cover)),
        ));
  }

  CarouselOptions options = CarouselOptions(
    autoPlay: true,
    enlargeCenterPage: true,
    viewportFraction: 0.4,
    aspectRatio: 2.0,
    initialPage: 2,
  );
}

class SlideMenu extends StatelessWidget {
  SlideMenu({this.str, this.icon, this.isSelected});
  final String str;
  final IconData icon;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(2.0),
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
      width: 70,
      decoration: BoxDecoration(
          color: isSelected ? Colors.indigo : Colors.indigo[200],
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: isSelected ? Colors.indigo[900] : Colors.indigo[400],
              offset: Offset(0, 2),
              // blurRadius: 2
            )
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Icon(
            icon,
            color: isSelected ? Colors.white : Colors.black,
          ),
          Text(
            str,
            style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.grey[200] : Colors.black),
          )
        ],
      ),
    );
  }
}

class LoadData extends StatelessWidget {
  const LoadData({Key key, this.ukuran}) : super(key: key);
  final double ukuran;
  @override
  Widget build(BuildContext context) {
    return SpinKitCircle(size: ukuran, color: Warna.warna(kuning));
  }
}

class MenuBox extends StatelessWidget {
  MenuBox({this.str, this.urlImage});
  final String str;
  final String urlImage;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(urlImage, fit: BoxFit.cover, width: 50, height: 50),
        Text(str,
            style: TextStyle(
                fontSize: 15,
                color: Warna.warna(biru),
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// ignore: camel_case_types
class loadingBih extends StatelessWidget {
  loadingBih({this.firstColor, this.secondColor});
  final Animation<Color> firstColor;
  final Animation<Color> secondColor;
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(colors: [firstColor.value, secondColor.value])
            .createShader(rect);
      },
      child: Container(
          margin: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white,
          )),
    );
  }
}
