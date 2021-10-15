// import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'component.dart';
import 'dashboard.dart';
import 'listWarna.dart';

class LoadingLoginPage extends StatefulWidget {
  @override
  _LoadingLoginPageState createState() => _LoadingLoginPageState();
}

class _LoadingLoginPageState extends State<LoadingLoginPage> {
  LocalStorage storage = new LocalStorage('localstorage_app');

  void complete() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Dashboard(selected: 0, iklan: true)));
  }

  void changeStatusPromo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("promo");
  }

  void initState() {
    super.initState();
    changeStatusPromo();
    Timer(Duration(seconds: 2), complete);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage('image/funmo/icon/loadingPage.png'),
              fit: BoxFit.fill,
            ),
          ),
          // child: Column(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: <Widget>[
          //       Loading(),
          //       Container(
          //         padding: EdgeInsets.only(left: 20, right: 20, top: 50),
          //         child: Image.asset('image/funmo/iconnobackground.png'),
          //       ),
          //       Container(
          //           margin: EdgeInsets.only(bottom: 50),
          //           child: Text(
          //             'Vers. 2.0',
          //             style: TextStyle(
          //                 fontWeight: FontWeight.bold, color: Warna.warna(biru)),
          //           ))
          //     ],
          // ),
        ),
        Positioned(
          top: 100,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: SpinKitWave(
                color: Warna.warna(kuning),
              ),
            ),
          ),
        )
      ],
    ));
  }
}
