import "package:flutter/material.dart";
import 'component.dart';
import 'listWarna.dart';

class PhoneBook extends StatefulWidget {
  PhoneBook({this.data, this.routing, this.dataRouting});
  final List<dynamic> data;
  final String routing;
  final dynamic dataRouting;
  @override
  _PhoneBookState createState() => _PhoneBookState();
}

class _PhoneBookState extends State<PhoneBook> {
  TextEditingController findContact = new TextEditingController();
  List<dynamic> phonebook = [];
  List<dynamic> cadangan = [];
  bool isLoading = false;
  @override
  void initState() {
    setState(() {
      isLoading = true;
      phonebook = widget.data;
      cadangan = widget.data;
      isLoading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Pilih Kontak'),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(),
              child: TextFormField(
                controller: findContact,
                onChanged: (findContact) {
                  String tes = findContact.toUpperCase();
                  print(tes);
                  List<dynamic> filter = cadangan
                      .where((phone) => phone['nama'].contains(tes))
                      .toList();
                  setState(() {
                    phonebook = filter;
                  });
                },
                decoration: InputDecoration(
                    labelText: "Cari", suffixIcon: Icon(Icons.search)),
              ),
            ),
            Expanded(
              child: isLoading
                  ? Loading()
                  : phonebook.length != 0
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: phonebook.length,
                          itemBuilder: (context, i) {
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    widget.dataRouting != null
                                        ? Navigator.popAndPushNamed(
                                            context, widget.routing,
                                            arguments: [
                                                phonebook[i],
                                                widget.dataRouting
                                              ])
                                        : Navigator.popAndPushNamed(
                                            context, widget.routing,
                                            arguments: [phonebook[i], null]);
                                  },
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2 +
                                              10,
                                          child: Text(phonebook[i]["nama"],
                                              style: TextStyle(
                                                  color: Warna.warna(biru),
                                                  fontSize: 15)),
                                        ),
                                        Text(phonebook[i]["noTelp"],
                                            style: TextStyle(
                                                color: Warna.warna(biru),
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: Divider(color: Colors.grey))
                              ],
                            );
                          })
                      : Container(child: Text("Contact Tidak Ditemukan")),
            )
          ],
        ));
  }
}
