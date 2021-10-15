import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../register.dart';

class Kelurahan extends StatefulWidget {
  const Kelurahan({Key key, this.kodeReseller}) : super(key: key);
  final String kodeReseller;
  @override
  _KelurahanState createState() => _KelurahanState();
}

class _KelurahanState extends State<Kelurahan> {
  final LocalStorage storage = new LocalStorage('localstorage_app');
  final TextEditingController kelurahan = new TextEditingController();
  final _formKelurahanKey = GlobalKey<FormState>();

  List<dynamic> allKelurahan;
  List<dynamic> cadangan;

  @override
  void initState() {
    super.initState();
    allKelurahan = storage.getItem("allKelurahan");
    cadangan = storage.getItem("allKelurahan");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Pilih Kelurahan'),
        ),
        body: Column(
          children: [
            Form(
              key: _formKelurahanKey,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  child: TextFormField(
                    controller: kelurahan,
                    onChanged: (kelurahan) {
                      String tes = kelurahan.toUpperCase();
                      List<dynamic> filter = cadangan
                          .where((kelurahan) => kelurahan['nama'].contains(tes))
                          .toList();
                      setState(() {
                        allKelurahan = filter;
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
                  itemCount: allKelurahan.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                      child: Container(
                        child: GestureDetector(
                          onTap: () {
                            String selectedKelurahan = allKelurahan[i]['nama'];
                            String selectedIdKelurahan = allKelurahan[i]['id'];
                            storage.setItem('kelurahan', selectedKelurahan);
                            storage.setItem('IdKelurahan', selectedIdKelurahan);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    Register(kodeReseller: widget.kodeReseller == null ? null : widget.kodeReseller)));
                          },
                          child: Card(
                              child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              allKelurahan[i]['nama'],
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
