import 'package:android/profilerouting/withdrawsaldo.dart';
import 'package:flutter/material.dart';
import 'menuutama/kirimSaldo.dart';

class Kirim extends StatefulWidget {
  const Kirim({Key key, this.selectedIndex, this.noTelp}) : super(key: key);
  final int selectedIndex;
  final dynamic noTelp;

  @override
  _KirimState createState() => _KirimState();
}

class _KirimState extends State<Kirim> with SingleTickerProviderStateMixin {
  TabController controller;

  void initState() {
    controller = new TabController(
        vsync: this, length: 2, initialIndex: widget.selectedIndex ?? 0);
    print('cek noTelp sudah ada ato blm');
    print(widget.noTelp);
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
        bottom: TabBar(controller: controller, tabs: <Widget>[
          Tab(
              icon: Icon(Icons.send_to_mobile, color: Colors.white),
              child:
                  Text('Kirim Saldo', style: TextStyle(color: Colors.white))),
          Tab(
              icon: Icon(Icons.money_rounded, color: Colors.white),
              child: Text('Withdraw', style: TextStyle(color: Colors.white))),
        ]),
      ),
      body: Container(
        color: Colors.white,
        child: TabBarView(
          controller: controller,
          children: [
            KirimSaldo(
              data: widget.noTelp ?? null, from:'kirim'
            ),
            WithdrawSaldo(from: 'kirim'),
          ],
        ),
      ),
    );
  }
}
