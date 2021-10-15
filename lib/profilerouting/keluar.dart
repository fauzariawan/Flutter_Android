import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import '../dashboard.dart';

class Keluar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.blue,
          title: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  // SharedPreferences.Editor.clear().commit();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Dashboard()));
                },
                child: Center(
                  child: Center(
                    child: Text(
                      'Keluar',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Center(child: Text('Berhasil')));
  }
}
