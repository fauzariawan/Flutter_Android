import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../register.dart';

class Kecamatan extends StatefulWidget {
  const Kecamatan({Key key, this.kodeReseller}) : super(key: key);
  final String kodeReseller;
  @override
  _KecamatanState createState() => _KecamatanState();
}

class _KecamatanState extends State<Kecamatan> {
  final LocalStorage storage = new LocalStorage('localstorage_app');
  final TextEditingController kecamatan = new TextEditingController();
  final _formKecamatanKey = GlobalKey<FormState>();

  List<dynamic> allKecamatan;
  List<dynamic> cadangan;

  @override
  void initState() {
    super.initState();
    allKecamatan = storage.getItem("allKecamatan");
    cadangan = storage.getItem("allKecamatan");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Pilih Kecamatan'),
        ),
        body: Column(
          children: [
            Form(
              key: _formKecamatanKey,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  child: TextFormField(
                    controller: kecamatan,
                    onChanged: (kecamatan) {
                      String tes = kecamatan.toUpperCase();
                      List<dynamic> filter = cadangan
                          .where((kecamatan) => kecamatan['nama'].contains(tes))
                          .toList();
                      setState(() {
                        allKecamatan = filter;
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
                  itemCount: allKecamatan.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                      child: Container(
                        child: GestureDetector(
                          onTap: () {
                            String selectedKecamatan = allKecamatan[i]['nama'];
                            String selectedIdKecamatan = allKecamatan[i]['id'];
                            storage.setItem('kecamatan', selectedKecamatan);
                            storage.setItem('IdKecamatan', selectedIdKecamatan);
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
                              allKecamatan[i]['nama'],
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
