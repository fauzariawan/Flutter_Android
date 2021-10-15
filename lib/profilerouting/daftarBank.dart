import 'package:android/profilerouting/withdrawsaldo.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../routerName.dart';

class DaftarBank extends StatefulWidget {
  DaftarBank({this.from});
  final String from;
  @override
  _DaftarBankState createState() => _DaftarBankState();
}

class _DaftarBankState extends State<DaftarBank> {
  LocalStorage storage = new LocalStorage('application_app');
  TextEditingController namaBank = new TextEditingController();
  final _formWithdrawSaldo = GlobalKey<FormState>();

  List<dynamic> daftarBank;
  List<dynamic> cadangan;

  void initState() {
    super.initState();
    daftarBank = storage.getItem('daftarBank');
    cadangan = storage.getItem('daftarBank');
    print(daftarBank);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Daftar Bank'),
        ),
        body: Column(
          children: [
            Form(
              key: _formWithdrawSaldo,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  child: TextFormField(
                    controller: namaBank,
                    onChanged: (namaBank) {
                      String tes = namaBank.toUpperCase();
                      List<dynamic> filter = cadangan
                          .where((bank) => bank['namaBank'].contains(tes))
                          .toList();
                      setState(() {
                        daftarBank = filter;
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
                  itemCount: daftarBank.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                      child: Container(
                        child: GestureDetector(
                          onTap: () {
                            print(daftarBank[i]['namaBank']);
                            print(daftarBank[i]['kodeBank']);
                            String selectedBank = daftarBank[i]['namaBank'];
                            String selectedCodeBank = daftarBank[i]['kodeBank'];
                            storage.setItem('namaBank', selectedBank);
                            storage.setItem('kodeBank', selectedCodeBank);
                            widget.from == 'kirim'
                                ? Navigator.popAndPushNamed(context, kirim,
                                    arguments: [null, 1])
                                : Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => WithdrawSaldo()));
                          },
                          child: daftarBank[i]['kodeBank'] == '000'
                              ? null
                              : daftarBank[i]['kodeBank'] == '999'
                                  ? null
                                  : Card(
                                      child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text(
                                        daftarBank[i]['namaBank'],
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
