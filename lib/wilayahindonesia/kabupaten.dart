import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../register.dart';

class Kabupaten extends StatefulWidget {
  const Kabupaten({Key key, this.kodeReseller}) : super(key: key);
  final String kodeReseller;
  @override
  _KabupatenState createState() => _KabupatenState();
}

class _KabupatenState extends State<Kabupaten> {
  final LocalStorage storage = new LocalStorage('localstorage_app');
  final TextEditingController kabupaten = new TextEditingController();
  final _formKabupatenKey = GlobalKey<FormState>();

  List<dynamic> allKabupaten;
  List<dynamic> cadangan;

  @override
  void initState() {
    super.initState();
    allKabupaten = storage.getItem("allKabupaten");
    cadangan = storage.getItem("allKabupaten");
    print(allKabupaten);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Pilih Kabupaten'),
        ),
        body: Column(
          children: [
            Form(
              key: _formKabupatenKey,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  child: TextFormField(
                    controller: kabupaten,
                    onChanged: (kabupaten) {
                      String tes = kabupaten.toUpperCase();
                      List<dynamic> filter = cadangan
                          .where((kabupaten) => kabupaten['nama'].contains(tes))
                          .toList();
                      setState(() {
                        allKabupaten = filter;
                      });
                    },
                    decoration: InputDecoration(suffixIcon: Icon(Icons.search)),
                  ),
                ),
              ),
            ),
            Expanded(
              // biar listview nya berada dibawah textformfield
              child: ListView.builder(
                  // physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: allKabupaten.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                      child: Container(
                        child: GestureDetector(
                          onTap: () {
                            String selectedKabupaten = allKabupaten[i]['nama'];
                            String selectedIdKabupaten = allKabupaten[i]['id'];
                            storage.setItem('kabupaten', selectedKabupaten);
                            storage.setItem('IdKabupaten', selectedIdKabupaten);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    Register(kodeReseller: widget.kodeReseller == null ? null : widget.kodeReseller)));
                          },
                          child: Card(
                              child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              allKabupaten[i]['nama'],
                              style: TextStyle(fontSize: 20.0),
                            ),
                          )),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ));
  }
}

// container dulu baru card untuk tampilan
