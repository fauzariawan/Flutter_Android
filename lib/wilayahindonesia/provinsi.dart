import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../register.dart';

class Provinsi extends StatefulWidget {
  const Provinsi({Key key, this.kodeReseller}) : super(key: key);
  final String kodeReseller;
  @override
  _ProvinsiState createState() => _ProvinsiState();
}

class _ProvinsiState extends State<Provinsi> {
  final LocalStorage storage = new LocalStorage('localstorage_app');
  final TextEditingController provinsi = new TextEditingController();
  final _formProvinsiKey = GlobalKey<FormState>();

  List<dynamic> allProvinsi;
  List<dynamic> cadangan;

  @override
  void initState() {
    super.initState();
    allProvinsi = storage.getItem("allProvinsi");
    cadangan = storage.getItem("allProvinsi");
    print(allProvinsi);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Pilih Provinsi'),
        ),
        body: Column(
          children: [
            Form(
              key: _formProvinsiKey,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  child: TextFormField(
                    controller: provinsi,
                    onChanged: (provinsi) {
                      String tes = provinsi.toUpperCase();
                      List<dynamic> filter = cadangan
                          .where((provinsi) => provinsi['nama'].contains(tes))
                          .toList();
                      setState(() {
                        allProvinsi = filter;
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
                  itemCount: allProvinsi.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                      child: Container(
                        child: GestureDetector(
                          onTap: () {
                            print('berhasil');
                            String selectedProvinsi = allProvinsi[i]['nama'];
                            String selectedIdProvinsi = allProvinsi[i]['id'];
                            print(selectedProvinsi);
                            print(selectedIdProvinsi);
                            storage.setItem('provinsi', selectedProvinsi);
                            storage.setItem('IdProvinsi', selectedIdProvinsi);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Register(
                                    kodeReseller: widget.kodeReseller == null
                                        ? null
                                        : widget.kodeReseller)));
                          },
                          child: Card(
                              child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              allProvinsi[i]['nama'],
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
