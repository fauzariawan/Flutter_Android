import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../component.dart';
import '../../routerName.dart';

class PaketNelpon extends StatefulWidget {
  PaketNelpon({this.data});
  final dynamic data;
  // data:{"title":"Paket Nelpon", "kriteria":"4", "kriteria2":"telpon", "description":"Khusu Pembelian Paket Nelpon"},
  @override
  _PaketNelponState createState() => _PaketNelponState();
}

class _PaketNelponState extends State<PaketNelpon> {
  List<dynamic> operatorTS = [];

  void initState() {
    super.initState();
    getOperator();
  }

  getOperator() async {
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = 'operator';
    final params = {
      "kriteria": widget.data['kriteria'],
      "kriteria2": widget.data['kriteria2']
    };
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());

    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        operatorTS = json.decode(response.body);
        operatorTS
            .map((e) => e['nama'] = e['nama'].substring(3, e['nama'].length))
            .toList();
      });
      print(operatorTS);
    } else {
      print('gagal');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.data['title']),
          centerTitle: true,
          elevation: 0,
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
          },
          child: ListView(
            children: [
              PangkatPendek(
                height: 100,
              ),
              AnimationLimiter(
                  child: Column(
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 1000),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    horizontalOffset: MediaQuery.of(context).size.width / 2,
                    child: FadeInAnimation(child: widget),
                  ),
                  children: [
                    operatorTS.length == 0
                        ? Container()
                        : AnimationLimiter(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: operatorTS.length,
                                itemBuilder: (context, i) {
                                  return AnimationConfiguration.staggeredList(
                                    position: i,
                                    duration:
                                        const Duration(milliseconds: 1000),
                                    child: SlideAnimation(
                                      verticalOffset: 200.0,
                                      child: FadeInAnimation(
                                        child: CardMenu(
                                          title: operatorTS[i]['nama'],
                                          description: widget.data['title'],
                                          data: operatorTS[i],
                                          route: produkPromo,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                  ],
                ),
              )),
            ],
          ),
        ));
  }
}
