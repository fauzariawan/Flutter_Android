import 'package:android/loadingloginpage.dart';
// import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
// import 'package:flutter_udid/flutter_udid.dart';
import "package:flutter/material.dart";
// import 'package:flutter/services.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:localstorage/localstorage.dart'; // untuk menyimpan data dilocalstorage
import 'package:minimize_app/minimize_app.dart';
import 'component.dart';
import 'listWarna.dart';
// import 'lupaPin.dart';
import 'login.dart';
import 'menuutama/paketData.dart';
import 'menuutama/subPaketData/dataInjek.dart';
import 'menuutama/telpDanSms.dart';
import 'register.dart';
import 'dashboard.dart';
// import 'pilihMethodOtp.dart';
import './profilerouting/rewards.dart';
import './profilerouting/customerservice.dart';
import './profilerouting/gantipin.dart';
import './profilerouting/ubahtoko.dart';
import './profilerouting/tentangaplikasi.dart';
import './profilerouting/perbaruikonten.dart';
import './profilerouting/keluar.dart';
import './profilerouting/withdrawsaldo.dart';
import './menuutama/operatorPromo.dart';
import './menuutama/pln.dart';
import 'router.dart';
// import 'package:permission_handler/permission_handler.dart'; // untuk access phone contact
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLogedIn = prefs.containsKey('token');
  await DotEnv.load(fileName: ".env");
  runApp(new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        indicatorColor: Warna.warna(kuning), // untuk merubah warna dibawah tab
        primarySwatch: Warna.warna(biru),
        textTheme: TextTheme(
          button: TextStyle(fontSize: 14.0),
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          // headline6: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(
            fontSize: 14.0,
          ),
        ),
      ),
      home: isLogedIn ? LoadingLoginPage() : HomePage(),
      onGenerateRoute: Routers.generateRoute,
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => HomePage(),
        '/register': (BuildContext context) => Register(
              kodeReseller: null,
            ),
        '/dashboard': (BuildContext context) => Dashboard(),
        '/rewards': (BuildContext context) => Rewards(),
        '/customerservice': (BuildContext context) => CustomerService(),
        '/gantipin': (BuildContext context) => GantiPin(),
        '/ubahtoko': (BuildContext context) => UbahToko(),
        '/tentangaplikasi': (BuildContext context) => TentangAplikasi(),
        '/perbaruikontent': (BuildContext context) => PerbaruiKonten(),
        '/keluar': (BuildContext context) => Keluar(),
        '/withdrawsaldo': (BuildContext context) => WithdrawSaldo(),
        '/operatorPromo': (BuildContext context) => OperatorPromo(),
        '/pln': (BuildContext context) => Pln(),
        '/paketdata': (BuildContext context) => PaketData(),
        '/paketDataInjek': (BuildContext context) => DataInjek(),
        '/telpDanSms': (BuildContext context) => TelpDanSms()
      }));
}

const iOSLocalizedLabels = false;

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<bool> _exit() {
    return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Are you sure?'),
              content: Text('Do you want to exit an App'),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                ElevatedButton(
                  child: Text('Yes'),
                  onPressed: () {
                    Navigator.pop(context);
                    return MinimizeApp.minimizeApp();
                  },
                )
              ],
            );
          },
        ) ??
        false;
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _exit,
      child: Scaffold(
        body: Stack(
          children: [
            ListView(
              children: <Widget>[
                Container(
                  // margin: EdgeInsets.only(top: 10, left: 10, bottom: 10, right: 20),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width + 50,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('image/halamanUtama.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 40, right: 40),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                      child: Text('Login'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(left: 40, right: 40),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        side: BorderSide(color: Warna.warna(biru), width: 2),
                        primary: Colors.white,
                        shape: StadiumBorder()),
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Register()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                      child: Text('Daftar Sekarang',
                          style: TextStyle(color: Warna.warna(biru))),
                    ),
                  ),
                ),
              ],
            ),
            if (MediaQuery.of(context).size.width < 500)
              Positioned(
                  bottom: 10,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Butuh Bantuan ? '),
                          InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => CustomerService()));
                              },
                              child: Text('Hubungi Kami',
                                  style: TextStyle(color: Warna.warna(biru))))
                        ],
                      ))))
          ],
        ),
      ),
    );
  }
}
