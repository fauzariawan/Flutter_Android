import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:intl/intl.dart';

import '../categoryOperator.dart';

class FormatPrint {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  sample(
      String pathImage,
      dynamic data,
      dynamic keterangan,
      int biaya, //
      int admin, // null
      int denda, // 0
      int cetak, // 0
      String header, // ada
      String alamat, // ada
      dynamic dataToko) async {
    String sn = data['sn'];
    String reff = keterangan['reff'];
    String namaToko = dataToko != null ? dataToko['nama_toko'] : null;
    String alamatToko = dataToko != null ? dataToko['alamat_toko'] : null;
    String token = keterangan['token'];
    String golongan = keterangan['golongan'];
    String daya = keterangan['daya'];
    String kwh = keterangan['kwh'];
    String namaProduk = data['produk']['nama'];
    String tujuan = data['tujuan'];
    String nama = keterangan['nama'];
    String biller = keterangan['biller'];
    String jumlahBulan = keterangan['jumlahBulan'];
    String ref = data['ref_id'];
    String tagihan = keterangan['tagihan'] ?? data['harga'].toString();
    String periode = keterangan['periode'];
    String stand = keterangan['stand'];
    String jumlahPeserta = keterangan['jumlahPeserta'];
    String cabang = keterangan['cabang'];
    String tarifDaya = keterangan['tarifDaya'];
    int total = biaya + admin + denda + cetak;

    print('ini data toko <<<<<<<<<<<<<<<<');
    print(dataToko);
    // print(data['harga']);
    // print(keterangan);
    // print(admin);
    // print(denda);
    // print(cetak);
    // print(header);
    // print(alamat);
    // print(tagihan);
    // print(sn);
    //SIZE
    // 0- normal size text
    // 1- only bold text
    // 2- bold with medium text
    // 3- bold with large text
    //ALIGN
    // 0- ESC_ALIGN_LEFT
    // 1- ESC_ALIGN_CENTER
    // 2- ESC_ALIGN_RIGHT

//     var response = await http.get("IMAGE_URL");
//     Uint8List bytes = response.bodyBytes;
    bluetooth.isConnected.then((isConnected) {
      if (isConnected) {
        DateTime now = DateTime.now();
        String getTgl = now.toString().substring(0, 10);
        List arrayTgl = getTgl.split("-");
        List newArray = [];
        newArray.add(arrayTgl[2]);
        newArray.add(arrayTgl[1]);
        newArray.add(arrayTgl[0]);
        String waktu = now.toString().substring(10, 19);
        String formatTgl = newArray.join("/");
        bluetooth.printNewLine();
        bluetooth.printCustom(namaToko == null ? "$header" : "$namaToko", 2, 1);
        bluetooth.printCustom(
            alamatToko == null ? "$alamat" : "$alamatToko", 0, 1);
        // bluetooth.printImage(pathImage); //path of your image/logo
        bluetooth.printCustom("", 1, 0);
        bluetooth.printCustom("$formatTgl $waktu", 1, 0);
        if (ref != null) bluetooth.printLeftRight("TRX ID", '$ref', 0);
        bluetooth.printCustom("-------------------------------", 1, 1);
        bluetooth.printCustom("Detail Transaksi", 1, 1);
        bluetooth.printCustom("", 1, 1);
        bluetooth.printLeftRight("Nama Produk", '$namaProduk', 0);
        bluetooth.printLeftRight("Tujuan", '$tujuan', 0);
        if (nama != null) bluetooth.printLeftRight("Nama", '$nama', 0);
        if (reff != null) bluetooth.printLeftRight("Reff", '$reff', 0);
        if (golongan != null)
          bluetooth.printLeftRight("Golongan", '$golongan', 0);
        if (daya != null) bluetooth.printLeftRight("Daya", '$daya', 0);
        if (kwh != null) bluetooth.printLeftRight("KWH", '$kwh', 0);
        if (jumlahPeserta != null)
          bluetooth.printLeftRight("Jumlah Peserta", '$jumlahPeserta', 0);
        if (cabang != null) bluetooth.printLeftRight("Cabang", '$cabang', 0);
        if (biller != null) bluetooth.printLeftRight("Biller", '$biller', 0);
        if (tarifDaya != null)
          bluetooth.printLeftRight("Tarif Daya", '$tarifDaya', 0);
        if (periode != null) bluetooth.printLeftRight("Periode", '$periode', 0);
        if (jumlahBulan != null)
          bluetooth.printLeftRight("Jumlah Bulan", '$jumlahBulan', 0);
        if (stand != null) bluetooth.printLeftRight("Stand", '$stand', 0);
        if (sn.contains('/') == false) bluetooth.printLeftRight("SN", "$sn", 0);
        if (tagihan != null)
          bluetooth.printLeftRight(
              data['produk']['kode_operator'] == 'ZWD'
                  ? 'Nominal'
                  : produkPpob.contains(data['produk']['kode_operator'])
                      ? "Tagihan"
                      : "Harga",
              NumberFormat.currency(
                      locale: 'id', symbol: 'Rp. ', decimalDigits: 0)
                  .format(biaya ?? int.parse(tagihan)),
              0);
        if (admin != null)
          bluetooth.printLeftRight(
              "Admin",
              NumberFormat.currency(
                      locale: 'id', symbol: 'Rp. ', decimalDigits: 0)
                  .format(admin),
              0);
        if (cetak != null)
          bluetooth.printLeftRight(
              "Biaya Cetak",
              NumberFormat.currency(
                      locale: 'id', symbol: 'Rp. ', decimalDigits: 0)
                  .format(cetak),
              0);
        bluetooth.printCustom("-------------------------------", 1, 1);
        if (total != null)
          bluetooth.printLeftRight(
              "Total",
              NumberFormat.currency(
                      locale: 'id', symbol: 'Rp. ', decimalDigits: 0)
                  .format(total),
              0);
        if (token != null) bluetooth.printCustom('$token', 2, 1);
        bluetooth.printCustom("-------------------------------", 1, 1);
        bluetooth.printCustom(
            "Struk Ini Merupakan Bukti Pembayaran Yang Sah", 0, 1);
        bluetooth.printCustom(
            "Tersedia Pulsa, Kuota All Operator, Token PLN, Bayar Listrik, PDAM, Telkom, Item Game, Dan Multi Pembayaran Lainnya",
            0,
            1);
        bluetooth.printCustom("", 1, 1);
        bluetooth.printCustom("", 1, 1);
        bluetooth.printCustom("", 1, 1);
        bluetooth.paperCut();
        bluetooth.paperCut();
        bluetooth.paperCut();

// //      bluetooth.printImageBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
// //         bluetooth.printNewLine();
// //         bluetooth.printNewLine();
// //         bluetooth.printLeftRight("LEFT", "RIGHT",0);
// //         bluetooth.printLeftRight("LEFT", "RIGHT",1);
// //         bluetooth.printNewLine();
// //         bluetooth.printLeftRight("LEFT", "RIGHT",2);
// //         bluetooth.printLeftRight("LEFT", "RIGHT",3);
// //         bluetooth.printLeftRight("LEFT", "RIGHT",4);
// //         String testString = " čĆžŽšŠ-H-ščđ";
// //         bluetooth.printCustom(testString, 1, 1, charset: "windows-1250");
// //         bluetooth.printLeftRight("Številka:", "18000001", 1, charset: "windows-1250");
// //         bluetooth.printCustom("Body left",1,0);
// //         bluetooth.printCustom("Body right",0,2);
// //         bluetooth.printNewLine();
// //         bluetooth.printCustom("Thank You",2,1);
// //         bluetooth.printNewLine();
// //         bluetooth.printQRcode("Insert Your Own Text to Generate", 200, 200, 1);
// //         bluetooth.printNewLine();
// //         bluetooth.printNewLine();
      }
    });
  }

  mutasi(dynamic data) async {
    int nominal = data['jumlah'].abs();
    int kode = data['kode'];
    String pengirim = data['pengirim'];
    String keterangan = data['keterangan'];
    String tanggal = data['tanggal'];
    bluetooth.isConnected.then((isConnected) {
      if (isConnected) {
        bluetooth.printNewLine();
        bluetooth.printCustom(
            NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                .format(nominal),
            2,
            1);
        bluetooth.printCustom("Transfer Berhasil", 0, 1);
        bluetooth.printCustom("$kode", 0, 1);
        bluetooth.printCustom("-------------------------------", 1, 1);
        bluetooth.printCustom("Rincian Transfer", 0, 1);
        bluetooth.printCustom("-------------------------------", 1, 1);
        bluetooth.printLeftRight("Nama", '$pengirim', 0);
        bluetooth.printLeftRight(
            "Nominal",
            NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                .format(nominal),
            0);
        bluetooth.printLeftRight("Sumber Dana", 'Saldo', 0);
        bluetooth.printLeftRight("Keterangan", '$keterangan', 0);
        bluetooth.printCustom("Transfer Via Funmobile", 0, 1);
        bluetooth.printCustom("$tanggal", 0, 1);
        bluetooth.printCustom("", 1, 1);
        bluetooth.printCustom("", 1, 1);
        bluetooth.printCustom("", 1, 1);
        bluetooth.paperCut();
        bluetooth.paperCut();
        bluetooth.paperCut();
      }
    });
  }
}
