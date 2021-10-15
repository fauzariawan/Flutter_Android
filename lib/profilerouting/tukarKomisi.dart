import 'package:android/component.dart';
import 'package:android/menuutama/konfirmasiPin.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
import '../listWarna.dart';

class TukarKomisi extends StatefulWidget {
  const TukarKomisi({Key key, this.jmlKomisi}) : super(key: key);
  final int jmlKomisi;

  @override
  _TukarKomisiState createState() => _TukarKomisiState();
}

class _TukarKomisiState extends State<TukarKomisi> {
  final _formPembayaran = GlobalKey<FormState>();
  TextEditingController nominal = TextEditingController();
  String _jmlKomisi;
  void initState() {
    changeFormat();
    super.initState();
  }

  changeFormat() {
    nominal = TextEditingController(text: widget.jmlKomisi.toString());
    print(nominal);
    String fix = FormatUang.formatUang(nominal);
    // final val = TextSelection.collapsed(
    //     offset: fix.length); // to set cursor position at the end of the value
    setState(() {
      _jmlKomisi = fix;
      // nominal.selection = val; // to set cursor position at the end of the value
    });
  }

  @override
  Widget build(BuildContext context) {
    nominal = TextEditingController(text: widget.jmlKomisi.toString().length >= 4 ? _jmlKomisi : widget.jmlKomisi.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text('Tukar Komisi'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: (MediaQuery.of(context).size.height / 2) / 2,
            color: Warna.warna(biru),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Tukar Komisi Menjadi Saldo Aktif',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Form(
              key: _formPembayaran,
              child: TextFormField(
                // inputFormatters: [DecimalTextInputFormatter()],
                keyboardType: TextInputType.number,
                readOnly: true,
                controller: nominal,
                validator: (nominal) {
                  if (nominal.isEmpty || nominal == '0') {
                    return 'Anda Tidak Memiliki Komisi Untuk di Tukar';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nominal',
                    prefixText: 'Rp. '),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_formPembayaran.currentState.validate()) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => KonfirmasiPin(
                      data: {"kode": "TukarKomisi", "nominal": nominal.text},
                    )));
          }
        },
        icon: Icon(Icons.navigate_next_rounded, color: Warna.warna(kuning)),
        label: Text(
          'Tukar',
          style: TextStyle(color: Warna.warna(kuning)),
        ),
        backgroundColor: Warna.warna(biru),
      ),
    );
  }
}
