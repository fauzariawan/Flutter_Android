import 'package:android/profilerouting/komisi.dart';
import 'package:android/routerName.dart';
import 'package:android/underMaintenance.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import './main.dart';
import './profilerouting/downline.dart';
import 'component.dart';
import 'listWarna.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() {
    return ProfileState();
  }
}

class ProfileState extends State<Profile> with TickerProviderStateMixin {
  LocalStorage storage = new LocalStorage('localstorage_app');
  dynamic dataUser;
  AnimationController _controller;
  Animation<Color> animationOne;
  Animation<Color> animationTwo;

  void initState() {
    super.initState();
    callDataUser();
    _controller = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    animationOne =
        ColorTween(begin: Warna.warna(kuning), end: Warna.warna(biru))
            .animate(_controller);
    animationTwo =
        ColorTween(begin: Warna.warna(biru), end: Warna.warna(kuning))
            .animate(_controller);

    // untuk memulai animation
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

  callDataUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      dataUser = json.decode(prefs.getString("dataUser"));
      print(dataUser['reseller_data']);
    });
  }

  List<String> itemMenu = <String>[
    'Profile Detail',
    'My Qrcode',
    'Withdraw Saldo',
    'Customer Service',
    'Ganti PIN',
    'Ubah Toko',
    'Tentang Aplikasi',
  ];

  final List<IconData> itemIcon = [
    Icons.person,
    Icons.phone,
    Icons.money,
    Icons.room_service,
    Icons.security_rounded,
    Icons.shop,
    Icons.book,
  ];

  final List<String> itemRouter = [
    profileDetail,
    myQrcode,
    '/withdrawsaldo',
    '/customerservice',
    '/gantipin',
    '/ubahtoko',
    '/tentangaplikasi',
  ];

  exit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = storage.getItem('token');
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = "reseller/logout";
    final params = null;
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());
    var response = await http.post(url, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "token": token
    }, body: {
      "kode_reseller": dataUser['kode'],
      "device_id": prefs.getString("device_id")
    });
    if (response.statusCode == 200) {
      prefs.clear();
      storage.clear();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(milliseconds: 2000),
          content: Container(
            child: Text('Gagal Logout'),
          )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
              height: 250.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Warna.warna(biru), Colors.white]),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey,
                //     offset: Offset(0.0, 1.0), //(x,y)
                //     blurRadius: 6.0,
                //   ),
                // ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          children: [
                            ClipOval(
                                child: Image.asset('image/user.png',
                                    width: 100.0, height: 100.0)),
                            if (dataUser != null && dataUser['oid'] == '00')
                              Positioned(
                                  right: 20,
                                  child: Icon(Icons.verified_user,
                                      size: 20.0,
                                      color: Colors.greenAccent[400]))
                          ],
                        ),
                        SizedBox(width: 20),
                        dataUser == null
                            ? ShaderMask(
                                shaderCallback: (rect) {
                                  return LinearGradient(colors: [
                                    animationOne.value,
                                    animationTwo.value
                                  ]).createShader(rect);
                                },
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    4 +
                                                30,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          color: Colors.white,
                                        )),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    4 +
                                                30,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          color: Colors.white,
                                        )),
                                  ],
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(dataUser['nama'],
                                      style: TextStyle(
                                          fontFamily: 'Lato-Black',
                                          color: Warna.warna(kuning),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(dataUser['kode'],
                                      style: TextStyle(
                                          fontFamily: 'Lato-Black',
                                          color: Warna.warna(kuning),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                      '0${dataUser['pengirim'][0]['pengirim'].substring(3, dataUser['pengirim'][0]['pengirim'].length)}',
                                      style: TextStyle(
                                          fontFamily: 'Lato-Black',
                                          color: Warna.warna(kuning),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ],
                              )
                      ],
                    ),
                    // Divider(
                    //   thickness: 2,
                    //   color: Colors.grey[400],
                    // ),
                    Row(children: <Widget>[
                      Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[100],
                              ),
                              height: 60,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Center(child: Text('Saldo')),
                                  Center(
                                      child: dataUser == null
                                          ? Text('Rp 0')
                                          : Format.formatUang(
                                              dataUser['saldo']))
                                ],
                              ))),
                      SizedBox(width: 10),
                      Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[100],
                              ),
                              height: 60,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Center(child: Text('Poin')),
                                  Center(
                                      child: Text(dataUser == null
                                          ? '0'
                                          : dataUser['poin'].toString() ==
                                                  'null'
                                              ? '0'
                                              : dataUser['poin'].toString()))
                                ],
                              ))),
                      SizedBox(width: 10),
                    ])
                  ],
                ),
              )
              // Center(
              //   child: Column(
              //     children: <Widget>[
              //       Stack(
              //         children: [
              //           Padding(
              //               padding: const EdgeInsets.all(8.0),
              //               child: ClipOval(
              //                   child: Image.asset('image/user.png',
              //                       width: 120.0, height: 120.0))),
              //           if (dataUser != null && dataUser['oid'] == '00')
              //             Positioned(
              //                 right: 20,
              //                 child: Icon(Icons.verified_user,
              //                     size: 20.0, color: Colors.greenAccent[400]))
              //         ],
              //       ),
              //       dataUser == null
              //           ? ShaderMask(
              //               shaderCallback: (rect) {
              //                 return LinearGradient(colors: [
              //                   animationOne.value,
              //                   animationTwo.value
              //                 ]).createShader(rect);
              //               },
              //               child: Column(
              //                 children: <Widget>[
              //                   Container(
              //                       width: MediaQuery.of(context).size.width /
              //                               4 +
              //                           30,
              //                       height: 20,
              //                       decoration: BoxDecoration(
              //                         borderRadius:
              //                             BorderRadius.circular(5.0),
              //                         color: Colors.white,
              //                       )),
              //                   SizedBox(
              //                     height: 5,
              //                   ),
              //                   Container(
              //                       width: MediaQuery.of(context).size.width /
              //                               4 +
              //                           30,
              //                       height: 20,
              //                       decoration: BoxDecoration(
              //                         borderRadius:
              //                             BorderRadius.circular(5.0),
              //                         color: Colors.white,
              //                       )),
              //                 ],
              //               ),
              //             )
              //           : Column(
              //               children: <Widget>[
              //                 Text(dataUser['nama'],
              //                     style: TextStyle(
              //                       fontSize: 20.0,
              //                     )),
              //                 SizedBox(
              //                   height: 5,
              //                 ),
              //                 Text(
              //                   dataUser['kode'],
              //                   style: TextStyle(fontSize: 15),
              //                 ),
              //                 SizedBox(
              //                   height: 5,
              //                 ),
              //                 Text(dataUser['pengirim'][0]['pengirim'])
              //               ],
              //             )
              //     ],
              //   ),
              // ),
              ),
          Container(
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              padding: EdgeInsets.only(top: 10),
              height: 100.0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 10.0), //(x,y)
                      blurRadius: 10.0,
                    )
                  ],
                  borderRadius: BorderRadius.circular(20.0)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox(
                        child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Komisi()));
                            },
                            child: Icon(Icons.chat,
                                size: 40.0, color: Colors.blue),
                          ),
                        ),
                        Text('Komisi')
                      ],
                    )),
                    SizedBox(
                        child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Downline()));
                            },
                            child: Icon(Icons.verified_user,
                                size: 40.0, color: Colors.blue),
                          ),
                        ),
                        Text('Downline')
                      ],
                    )),
                    SizedBox(
                        child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UnderMaintenance()));
                      },
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.share,
                                size: 40.0, color: Colors.blue),
                          ),
                          Text('Invite')
                        ],
                      ),
                    )),
                  ])),
          Container(
              margin: const EdgeInsets.only(top: 20.0, bottom: 25.0),
              decoration: BoxDecoration(
                color: Colors.white,
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey,
                //     offset: Offset(0.0, 5.0), //(x,y)
                //     blurRadius: 5.0,
                //   )
                // ],
                // borderRadius: BorderRadius.circular(20.0)
              ),
              child: Column(
                children: [
                  ListView.builder(
                    physics:
                        NeverScrollableScrollPhysics(), // biar bisa di scroll
                    shrinkWrap: true, // biar bisa tampil list view nya
                    itemCount: itemMenu.length,
                    itemBuilder: (context, i) {
                      return MenuProfile(
                          teks: itemMenu[i],
                          icon: itemIcon[i],
                          router: itemRouter[i],
                          data: dataUser);
                    },
                  ),
                  Container(
                      child: Column(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Warning !!!'),
                                  content:
                                      Text(' Apakah Anda Yakin Ingin Keluar'),
                                  actions: <Widget>[
                                    ElevatedButton(
                                        onPressed: () {
                                          exit();
                                        },
                                        child: Text('Yes')),
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('No'))
                                  ],
                                );
                              });
                        },
                        child: Container(
                            decoration: BoxDecoration(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Icon(Icons.exit_to_app,
                                          size: 30.0, color: Colors.blue[900]),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20.0),
                                        child: Text('Keluar'),
                                      ),
                                    ]),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Icon(
                                    Icons.navigate_next_rounded,
                                    color: Warna.warna(biru),
                                  ),
                                )
                              ],
                            )),
                      ),
                    ),
                    const Divider(
                      color: Colors.grey,
                      height: 0,
                      thickness: 0.3,
                      indent: 5,
                      endIndent: 30,
                    ),
                  ]))
                ],
              )),
        ],
      ),
    );
  }
}

class MenuProfile extends StatelessWidget {
  MenuProfile({this.teks, this.icon, this.router, this.data});

  final IconData icon;
  final String teks;
  final String router;
  final dynamic data;

  Widget build(BuildContext context) {
    return new Container(
        child: Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: GestureDetector(
          onTap: () {
            if (data == null) {
            } else {
              Navigator.pushNamed(context, router, arguments: data);
            }
          },
          child: Container(
              decoration: BoxDecoration(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(icon, size: 30.0, color: Colors.blue[900]),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(teks),
                        ),
                      ]),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Icon(Icons.navigate_next_rounded,
                        color: Warna.warna(biru)),
                  )
                ],
              )),
        ),
      ),
      const Divider(
        color: Colors.grey,
        height: 0,
        thickness: 0.3,
        indent: 5,
        endIndent: 30,
      ),
    ]));
  }
}
