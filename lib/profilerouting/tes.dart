import 'package:flutter/material.dart';

class Tes extends StatefulWidget {
  const Tes({ Key key }) : super(key: key);

  @override
  _TesState createState() => _TesState();
}

class _TesState extends State<Tes> {
  final _formWithdraw = GlobalKey<FormState>();
  TextEditingController namaBank = TextEditingController();
  TextEditingController noRek = TextEditingController();
  TextEditingController nominal = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          child: Form(
            key: _formWithdraw,
            child: Column(
              children: [
                TextFormField(
                  controller: namaBank,
                  decoration: InputDecoration(
                      labelText: 'Bank Tujuan', border: OutlineInputBorder()),
                ),
                Padding(padding: EdgeInsets.all(8)),
                TextFormField(
                  controller: noRek,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Nomor Rekening Tujuan',
                      border: OutlineInputBorder()),
                ),
                Padding(padding: EdgeInsets.all(8)),
                TextFormField(
                  controller: nominal,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      counterText: 'Minimal Withdraw Rp. 50.000',
                      labelText: 'Nominal',
                      border: OutlineInputBorder(),
                      prefixText: 'Rp. '),
                )
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
              onPressed: () {
                if (_formWithdraw.currentState.validate()) {
                  // cek();
                }
              },
              child: Text('Withdraw')),
        )
      ],
    );
  }
}