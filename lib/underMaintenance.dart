import 'package:flutter/material.dart';

class UnderMaintenance extends StatefulWidget {
  const UnderMaintenance({Key key}) : super(key: key);

  @override
  _UnderMaintenanceState createState() => _UnderMaintenanceState();
}

class _UnderMaintenanceState extends State<UnderMaintenance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Under maintenance'),
      // ),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(top: 10, left: 10, bottom: 10, right: 20),
          height: 400.0,
          width: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            image: DecorationImage(
              image: AssetImage('image/underMaintenance.jpg'),
              fit: BoxFit.fill,
            ),
            // shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
