import 'package:flutter/material.dart';

class Map extends StatefulWidget {
  const Map({Key key}) : super(key: key);

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MAP'),
        centerTitle: true,),
      body: Center(child: Container(child: Text('MAP'),),),
    );
  }
}