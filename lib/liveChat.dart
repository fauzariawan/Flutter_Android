import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'dart:convert';

import 'component.dart';
import 'listWarna.dart';

class LiveChat extends StatefulWidget {
  @override
  _LiveChatState createState() => _LiveChatState();
}

class _LiveChatState extends State<LiveChat> {
  TextEditingController nama = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController pesan = new TextEditingController();
  final _formKirimSaldo = GlobalKey<FormState>();
  LocalStorage storage = new LocalStorage('localstorage_app');
  List<dynamic> dataChat = [];
  bool isText = false;
  bool isLoading = false;

  void initState() {
    super.initState();
    callData();
  }

  callData() async {
    dynamic dataUser = storage.getItem('dataUser');
    final baseUrl = DotEnv.env['BASE_URL_LIVECHAT'];
    final path = 'liveChat/allChat';
    final params = null;
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());

    var response = await http.post(url, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    }, body: {
      "kode_reseller": dataUser['kode']
    });

    if (response.statusCode == 200) {
      setState(() {
        dataChat = json.decode(response.body);
        isLoading = false;
      });
      // print(dataChat);
    } else {
      print(response.body);
    }
  }

  // kirimPesan() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   dynamic dataUser = storage.getItem('dataUser');
  //   final baseUrl = DotEnv.env['BASE_URL_LIVECHAT'];
  //   final path = "liveChat";
  //   final params = null;
  //   final url = Uri.http(baseUrl, path, params);
  //   debugPrint(url.toString());

  //   var response = await http.post(url,
  //       headers: {"Content-Type": "application/x-www-form-urlencoded"},
  //       body: {"kode_reseller": dataUser['kode'], "pesan_reseller": text.text});

  //   if (response.statusCode == 200) {
  //     setState(() {
  //       text.text = '';
  //       isText = false;
  //     });
  //     callData();
  //   } else {
  //     print(response.body);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Live Chat Support'),
          centerTitle: true,
          elevation: 0,
        ),
        body: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: 100,
              color: Warna.warna(biru),
              child: Text(
                  'Mohon isi formulir dibawah ini dan kami akan membalasnya sesegera mungkin',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white)),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _formKirimSaldo,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: nama,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), hintText: "Nama"),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: email,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Alamat Email"),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      maxLength: null,
                      controller: pesan,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      decoration: InputDecoration(
                          helperMaxLines: 5,
                          border: OutlineInputBorder(),
                          hintText: "Pesan"),
                    )
                  ],
                ),
              ),
            )
          ],
        )
        // Stack(
        //   children: <Widget>[
        //     Positioned(
        //         bottom: 10.0,
        //         child: Container(
        //           width: MediaQuery.of(context).size.width,
        //           padding: EdgeInsets.all(10),
        //           child: Column(
        //             children: [
        //               dataChat.length == 0
        //                   ? Text('')
        //                   : ListView.builder(
        //                       physics: NeverScrollableScrollPhysics(),
        //                       shrinkWrap: true,
        //                       itemCount: dataChat.length,
        //                       itemBuilder: (context, i) {
        //                         return dataChat[i]['pesan_reseller'] == null
        //                             ? Padding(
        //                                 padding: const EdgeInsets.all(8.0),
        //                                 child: Row(
        //                                   children: [
        //                                     Container(
        //                                         width: MediaQuery.of(context)
        //                                                 .size
        //                                                 .width -
        //                                             50,
        //                                         child: Row(
        //                                           mainAxisSize: MainAxisSize
        //                                               .min, // membuat container parent menyesuaikan dengan content
        //                                           children: [
        //                                             Container(
        //                                                 padding: EdgeInsets.only(
        //                                                     top: 5,
        //                                                     bottom: 5,
        //                                                     left: 10.0,
        //                                                     right: 10.0),
        //                                                 decoration: BoxDecoration(
        //                                                     color: Colors.white,
        //                                                     borderRadius:
        //                                                         BorderRadius
        //                                                             .circular(10),
        //                                                     boxShadow: [
        //                                                       BoxShadow(
        //                                                           color: Colors
        //                                                               .grey[400],
        //                                                           blurRadius: 2,
        //                                                           offset: Offset(
        //                                                               2, 2))
        //                                                     ]),
        //                                                 child: Text(
        //                                                   dataChat[i]
        //                                                       ['jawaban_cs'],
        //                                                   style: TextStyle(
        //                                                       fontSize: 15),
        //                                                 )),
        //                                           ],
        //                                         )),
        //                                   ],
        //                                 ),
        //                               )
        //                             : Container(
        //                                 padding: EdgeInsets.only(
        //                                     top: 5,
        //                                     bottom: 5,
        //                                     left: 10.0,
        //                                     right: 10.0),
        //                                 decoration: BoxDecoration(
        //                                     color: Colors.green[100],
        //                                     borderRadius:
        //                                         BorderRadius.circular(10),
        //                                     boxShadow: [
        //                                       BoxShadow(
        //                                           color: Colors.grey[400],
        //                                           blurRadius: 2,
        //                                           offset: Offset(2, 2))
        //                                     ]),
        //                                 margin: EdgeInsets.only(
        //                                     left: 50, top: 3, bottom: 3),
        //                                 child: Text(dataChat[i]['pesan_reseller'],
        //                                     textAlign: TextAlign.right,
        //                                     style: TextStyle(fontSize: 15)),
        //                               );
        //                       }),
        //               isLoading
        //                   ? SpinKitWave()
        //                   : Container(
        //                       margin: EdgeInsets.only(top: 10),
        //                       child: TextFormField(
        //                         maxLength: 255,
        //                         maxLines: null,
        //                         controller: text,
        //                         onChanged: (text) {
        //                           if (text.isEmpty) {
        //                             setState(() {
        //                               isText = false;
        //                             });
        //                           } else {
        //                             setState(() {
        //                               isText = true;
        //                             });
        //                           }
        //                         }, // agar tulisan otomatis kebawah kalau sudah full
        //                         decoration: InputDecoration(
        //                           counterText:
        //                               '', // menghilangkan tampilan maxlength <<<<<<<
        //                           hintText: 'Type a message here',
        //                           suffixIcon: isText
        //                               ? GestureDetector(
        //                                   onTap: () {
        //                                     // kirimPesan();
        //                                   },
        //                                   child: Container(
        //                                       margin: EdgeInsets.only(right: 5),
        //                                       width: 50,
        //                                       decoration: BoxDecoration(
        //                                           color: Colors.teal[200],
        //                                           borderRadius:
        //                                               BorderRadius.circular(50)),
        //                                       child: Icon(Icons.send)),
        //                                 )
        //                               : Text(''),
        //                           border: OutlineInputBorder(
        //                             borderRadius: BorderRadius.circular(50),
        //                           ),
        //                         ),
        //                       ),
        //                     ),
        //             ],
        //           ),
        //         ))
        //   ],
        // ),
        );
  }
}
