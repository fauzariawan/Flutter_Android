import 'package:flutter/material.dart';

class RiwayatPenukaranHadiah extends StatefulWidget {
  const RiwayatPenukaranHadiah({ Key key }) : super(key: key);

  @override
  _RiwayatPenukaranHadiahState createState() => _RiwayatPenukaranHadiahState();
}

class _RiwayatPenukaranHadiahState extends State<RiwayatPenukaranHadiah> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Penukaran'),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Icon(Icons.change_circle_outlined, size: 100),
        ),
      ),
    );
  }
}