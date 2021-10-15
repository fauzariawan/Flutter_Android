import 'package:flutter/material.dart';

import 'component.dart';
import 'listWarna.dart';

class Informasi extends StatefulWidget {
  const Informasi({this.data});
  final dynamic data;

  @override
  _InformasiState createState() => _InformasiState();
}

class _InformasiState extends State<Informasi> {
  void initState() {
    super.initState();
    print(widget.data['desc_info']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informasi'),
        centerTitle: true,
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        },
        child: ListView(
          children: <Widget>[
            widget.data['img_info'] == null
                ? Container()
                : Image.network(widget.data['img_info'], fit: BoxFit.cover),
            SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Text(
                  widget.data['name_info'],
                  style: TextStyle(fontSize: 18, color: Warna.warna(biru)),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: widget.data['content_info'] == null
                        ? Text(widget.data['desc_info'])
                        : Text(
                            widget.data['content_info'],
                            textAlign: TextAlign.justify,
                          ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
