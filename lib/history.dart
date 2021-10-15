import 'package:android/history/tabHistory.dart';
import 'package:flutter/material.dart';
import 'history/tabDeposit.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> with SingleTickerProviderStateMixin {
  TabController controller;

  void initState() {
    controller = new TabController(vsync: this, length: 2);
    super.initState();
  }

  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        bottom: TabBar(
        controller: controller,
        tabs: <Widget>[
          Tab(
              icon: Icon(Icons.person, color: Colors.white),
              child: Text('Deposit', style: TextStyle(color: Colors.white))),
          Tab(
              icon: Icon(Icons.drive_eta, color: Colors.white),
              child: Text('Transaksi', style: TextStyle(color: Colors.white))),
        ]),
      ),
      body: Container(
        color: Colors.white,
        child: TabBarView(
          controller: controller,
            children: [
              TabDeposit(),
              TabHistory(),
            ],
            ),
      ),
    );
  }
}
