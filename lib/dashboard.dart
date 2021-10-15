import 'package:android/scanQrCode.dart';
import 'package:flutter/material.dart';
import 'component.dart';
import 'history.dart' as history;
import 'history/TabMutasi.dart';
import 'listWarna.dart';
import 'liveChat.dart';
import 'notif.dart';
import './profile.dart' as profile;
import './menuutama.dart';
import 'package:localstorage/localstorage.dart';
import 'package:minimize_app/minimize_app.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key key, this.selected, this.iklan}) : super(key: key);
  final bool iklan;
  final int selected;
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  TextEditingController codeproduct = new TextEditingController();
  TextEditingController tujuan = new TextEditingController();
  LocalStorage storage = new LocalStorage('localstorage_app');
  IconData icon = Icons.home;
  String str = 'Home';
  dynamic decodeToken;
  int _selectedIndex = 0;
  bool cek;
  String info;
  TabController controller;
  bool promo = false;

  void initState() {
    controller = TabController(vsync: this, length: 3);
    widget.selected == null
        ? _selectedIndex = 0
        : _selectedIndex = widget.selected;
    super.initState();
  }

  void dispose() {
    controller.dispose();
    super.dispose();
  }

  static List<Widget> _widgetOptions = <Widget>[
    new MenuUtama(),
    new TabMutasi(),
    new history.History(),
    new profile.Profile()
  ];

  // ignore: missing_return
  Future<bool> _minimize() {
    if (_selectedIndex == 0) {
      return MinimizeApp.minimizeApp();
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Dashboard(
                selected: 0,
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _minimize,
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading:
                false, // menghilangkan button back bawaan flutter
            title: Text('Funmobile'),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Container(
                  width: 100.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      GestureDetector(
                          child: Icon(Icons.chat),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => LiveChat()));
                          }),
                      GestureDetector(
                          child: Icon(Icons.notifications),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Notif()));
                          }),
                    ],
                  ),
                ),
              )
            ],
          ),
          body: Center(
              child: _widgetOptions.elementAt(
                  _selectedIndex)), // untuk mengubah tampilan berdasarkan index yang di inginkan
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ScanQrCode()));
            },
            child: ClipOval(
              child: Image.asset('image/funmo/ICON BULAT FUNMO.png'),
            ),
            tooltip: 'Scan QR',
            backgroundColor: Warna.warna(biru),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniCenterDocked,
          bottomNavigationBar: BottomAppBar(
            color: Warna.warna(biru),
            shape: CircularNotchedRectangle(),
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 2 - 40,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedIndex = 0;
                              });
                            },
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(Icons.home,
                                      size: 30,
                                      color: _selectedIndex == 0
                                          ? Warna.warna(kuning)
                                          : Colors.white),
                                  Text(
                                    "Beranda",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedIndex = 1;
                              });
                            },
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(Icons.compare_arrows_outlined,
                                      size: 30,
                                      color: _selectedIndex == 1
                                          ? Warna.warna(kuning)
                                          : Colors.white),
                                  Text(
                                    "Mutasi",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ]),
                          ),
                        ),
                      ]),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2 - 40,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedIndex = 2;
                              });
                            },
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(Icons.history,
                                      size: 30,
                                      color: _selectedIndex == 2
                                          ? Warna.warna(kuning)
                                          : Colors.white),
                                  Text(
                                    "History",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedIndex = 3;
                              });
                            },
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(Icons.person,
                                      size: 30,
                                      color: _selectedIndex == 3
                                          ? Warna.warna(kuning)
                                          : Colors.white),
                                  Text(
                                    "Profile",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ]),
                          ),
                        ),
                      ]),
                ),
              ],
            ),
          )),
    );
  }
}

class Menu extends StatelessWidget {
  Menu({this.title, this.picture});
  final String title;
  final String picture;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Image.asset(
            picture,
            fit: BoxFit.cover,
          ),
        ),
        Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 10.0),
          ),
        ),
      ],
    );
  }
}
