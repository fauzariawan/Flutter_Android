import 'package:android/menuutama/konfirmasiPin.dart';
import 'package:android/profile.dart';
import 'package:android/profilerouting/myqrcode.dart';
import 'package:android/profilerouting/profiledetail.dart';
import 'package:android/routerName.dart';
import 'package:flutter/material.dart';
import 'history/detailTransaksi.dart';
import 'kirim.dart';
import 'menuutama/cekTagihan.dart';
import 'menuutama/finance.dart';
import 'menuutama/gasAlam.dart';
import 'menuutama/kirimSaldo.dart';
import 'menuutama/lainnya/listOperator.dart';
import 'menuutama/produkPromo.dart';
import 'menuutama/pulsa.dart';
import 'menuutama/subPaketData/kuota.dart';
import 'menuutama/subTelpDanSms/subTelpDanSms.dart';
import 'menuutama/telkom.dart';
import 'menuutama/tesPembayaran.dart';
import 'menuutama/map.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case paketNelpon:
        var data = settings.arguments as dynamic;
        return MaterialPageRoute(builder: (_) => PaketNelpon(data: data));
      case produkPromo:
        var data = settings.arguments as List<dynamic>;
        var noTelp = data[0];
        var dataOperator = data[1];
        print('INI DATA DARI ROUTER');
        print(noTelp);
        print(dataOperator);
        return MaterialPageRoute(
            builder: (_) => ProdukPromo(data: dataOperator, noTelp: noTelp));
      case finance:
        var data = settings.arguments as dynamic;
        return MaterialPageRoute(builder: (_) => Finance(data: data));
      case cekTagihan:
        var data = settings.arguments as List<dynamic>;
        var nomor = data[0];
        var item = data[1];
        print(data);
        return MaterialPageRoute(
            builder: (_) => CekTagihan(data: item, nomor: nomor));
      case telkom:
        return MaterialPageRoute(builder: (_) => Telkom());
      case gasAlam:
        return MaterialPageRoute(builder: (_) => GasAlam());
      case listOperator:
        var data = settings.arguments as dynamic;
        return MaterialPageRoute(builder: (_) => ListOperator(data: data));
      case profileDetail:
        var data = settings.arguments as dynamic;
        return MaterialPageRoute(builder: (_) => ProfileDetail(data: data));
      case myQrcode:
        var data = settings.arguments as dynamic;
        return MaterialPageRoute(builder: (_) => MyQrcode(data: data));
      case tesPembayaran:
        var data = settings.arguments as dynamic;
        return MaterialPageRoute(builder: (_) => TesPembayaran(data: data));
      case pulsa:
        var data = settings.arguments as List<dynamic>;
        var noTelp = data[0];
        return MaterialPageRoute(builder: (_) => Pulsa(data: noTelp));
      case kirimSaldo:
        var data = settings.arguments as List<dynamic>;
        var noTelp = data[0];
        return MaterialPageRoute(builder: (_) => KirimSaldo(data: noTelp));
      case kuota:
        var data = settings.arguments as dynamic;
        return MaterialPageRoute(builder: (_) => Kuota(backupKodeTitle: data));
      case konfirmasiPin:
        var data = settings.arguments as dynamic;
        return MaterialPageRoute(builder: (_) => KonfirmasiPin(data: data));
      case detailTransaksi:
        var data = settings.arguments as dynamic;
        return MaterialPageRoute(
            builder: (_) => DetailTransaksi(
                  data: data,
                ));
      case profile:
        return MaterialPageRoute(builder: (_) => Profile());
      case map:
        return MaterialPageRoute(builder: (_) => Map());
      case kirim:
        var data = settings.arguments as List<dynamic>;
        var ind = data[1];
        var noTelp = data[0];
        return MaterialPageRoute(builder: (_) => Kirim(selectedIndex: ind, noTelp: noTelp));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
