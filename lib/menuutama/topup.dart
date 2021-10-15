import 'package:flutter/material.dart';

import '../routerName.dart';
import '../underMaintenance.dart';

class Topup extends StatefulWidget {
  @override
  _TopupState createState() => _TopupState();
}

class _TopupState extends State<Topup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Pilih Metode Pembayaran'),
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: const <StretchMode>[
              StretchMode.zoomBackground,
              StretchMode.blurBackground,
              StretchMode.fadeTitle,
            ],
          ),
        ),
        body: ListView(
          children: [
            Container(
                child: Column(
              children: <Widget>[
                Menu(
                    icon: Icons.comment_bank,
                    image: 'image/iconBank.png',
                    title: 'Bank',
                    description: 'Deposit Menggunakan Bank Transfer',
                    data: {"title": "BANK"}),
                Menu(
                    icon: Icons.wallet_membership,
                    image: 'image/iconEwallet.png',
                    title: 'Ewallet',
                    description:
                        'Deposit Menggunakan OVO, DANA, LINK AJA, GOPAY',
                    data: {"title": "E-WALLET"}),
                Menu(
                    icon: Icons.videocam_rounded,
                    image: 'image/iconVirtualAccount.png',
                    title: 'Virtual Account',
                    description:
                        'Tersedia Bank BNI, Mandiri, Artha Graha, Cimb Niaga (24 jam)',
                    data: {
                      "title": "VIRTUAL ACCOUNT",
                    }),
                Menu(
                    icon: Icons.shop,
                    image: 'image/iconAlfamart.png',
                    title: 'Alfamart',
                    description: 'Deposit Dengan Alfamart Otomatis',
                    data: {
                      "title": "ALFAMART",
                      "paymentChannelUrl":
                          "https://secure-payment.winpay.id/apiv2/ALFAMART"
                    }),
                Menu(
                    icon: Icons.shopping_bag,
                    image: 'image/iconIndomaret.png',
                    title: 'Indomaret',
                    description: 'Deposit Dengan Alfamart Otomatis',
                    data: {"title": "INDOMARET"}),
                // kelewatan tulisannya, blm tau cara membuat, kalau tulisan kepanjangan otomatis kebawah
                Menu(
                    icon: Icons.qr_code,
                    image: 'image/iconQris.png',
                    title: 'Qris',
                    description:
                        'Deposit Dengan Ewallet Dengan Scan Qrcode Otomatis Masuk, Tanpa Konfirmasi',
                    data: {
                      "title": "QR CODE",
                      "paymentChannelUrl":
                          "https://secure-payment.winpay.id/apiv2/QRISPAY"
                    })
              ],
            )),
          ],
        ));
  }
}

class Menu extends StatelessWidget {
  Menu({this.image, this.icon, this.title, this.description, this.route, this.data});
  final String image;
  final IconData icon;
  final String title;
  final String description;
  final String route;
  final dynamic data;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (title == 'Indomaret' || title == 'Ewallet') {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => UnderMaintenance()));
        } else {
          Navigator.pushNamed(context, tesPembayaran, arguments: data);
        }
      },
      child: Card(
        elevation: 5,
        // shadowColor: Colors.blue,
        semanticContainer: false,
        margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: image == null ? Icon(icon) : Image.asset(image, width: 40,),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(padding: EdgeInsets.all(3.0)),
                    Container(
                      width: MediaQuery.of(context).size.width / 2 + 70,
                      child: Text(
                        description,
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 10),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
