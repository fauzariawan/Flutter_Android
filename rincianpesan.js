// // RESPON PESAN UNTUK CEK TAGIHAN PLN
// [
//     RC:00 #4249 CPLN.126100030354 SUKSES. SN, 
//     Ref: A S R U L AM, 
//     TARIFDAYA:R1, 
//     1300, 
//     JMLBLN:1, 
//     PERIODE:202104, 
//     RP:216127, 
//     DENDA:0, 
//     ADMIN:2500, 
//     TOTALTAG:218627, 
//     STAND:5598-5734. 
//     Saldo 306,
//     286-0=306,
//     286 @2021-04-01 10:22:33
// ]

// // RESPON PESAN UNTUK CEK TAGIHAN PASCA BAYAR
// RC:00 #5421 CHALO.08116080804 SUKSES. SN
// /Ref: ANIXXXXXXXXXXXXXXXANI
// /RP:80974
// /BILLER:TELKOMSEL
// /JMLBLN:1
// /ADM:2500. Saldo 755,375-0=755,375 @2021-04-16 07:10:26

// RC:00 #5422 CHALO.08112815899 SUKSES. SN
// /Ref: ANIXXXXXXXXDAH
// /RP:112500
// /BILLER:TELKOMSEL
// /JMLBLN:1
// /ADM:2500. Saldo 755,375-0=755,375 @2021-04-16 07:16:30

// // cek pdam 
// [
//     RC:00 #5444 CPAMMDN.0425370001 SUKSES. SN, 
//     Ref: DIAN IRAWAN, 
//     RPTAG:74429, 
//     ADMIN:10000, 
//     TOTALTAG:84429, 
//     JMLBLN:04, 
//     PERIODE:202101,202102,202103,202104, 
//     STAND:0-2028. Saldo 755,375-0=755,375 @2021-04-17 05:37:40]

// // cek finance
// [RC:00 #5471 CFIFL.108001718119 SUKSES. SN, 
//     Ref: YOGA PITER SIRLANDES, 
//     RP:1414000, 
//     ANGSKE:022, 
//     PERIODE:APR21, 
//     ADMIN:5000, 108001718119. Saldo 755,375-0=755,375 @2021-04-19 02:36:29]

// // cek telkom
// [
//     RC:00 #5482 CTELKOM.131312138894 SUKSES. SN, 
//     Ref: DESA SUKAMANTRI HARUN, 
//     RP:287350, 
//     BILLER:TELKOM, 
//     PERIODE:202104, 
//     JMLBLN:1, 
//     ADM:3000, 
//     TAG:284350. Saldo 755,375-0=755,375 @2021-04-19 04:02:04]

// // cek gas

// [
//     RC:00 #5487 CPGN.031687628 SUKSES. SN, 
//     Ref: PATMAWATI SARI, 
//     RP:20000, 
//     PERIODE:0321, 
//     JMLBLN:1, 
//     ADMIN:3000, 031687628. Saldo 755,375-0=755,375 @2021-04-19 06:11:34]

// // cek Internet

// [
//     RC:00 #5490 CCBN.50104543 SUKSES. SN, 
//     Ref: SURYADI RAMADHAN, 
//     RP:221400, 
//     PERIODE:202103, 
//     JMLBLN:BLN, 
//     ADMIN:2500. Saldo 755,375-0=755,375 @2021-04-19 06:42:02]

// // response winpay Alfamart
// {
//     rc: '00',
//     rd: 'Transaksi Anda sedang dalam proses, Anda akan melakukan pembayaran menggunakan Alfamart, Silakan melakukan pembayaran sejumlah IDR 101.500-. Order ID Anda adalah 320004352. RAHASIA Dilarang menyebarkan ke ORANG Tdk DIKENAL',
//     request_time: '2021-04-22 09:14:32.275704',
//     data: {
//       reff_id: '320004352',
//       payment_code: '320004352',
//       order_id: 'TRX2266259E18E14E48E771',
//       request_key: '',
//       url_listener: 'https://funmo.herokuapp.com/merchant/listener',
//       payment_method: 'Alfamart',
//       payment_method_code: 'ALFAMART',
//       fee_admin: 0,
//       total_amount: 101500,
//       spi_status_url: 'https://secure-payment.winpay.id/guidance/index/alfamart?payid=430b5d8684d680b2b9151e1133dc8e53'
//     },
//     response_time: '2021-04-22 09:14:34.089298'
//   }

//   {
//       kode: 6558, 
//       tgl_entri: 2021-05-05T03:59:23.977Z, 
//       kode_produk: TM1, 
//       tujuan: 081212365845, 
//       kode_reseller: FUN0104, 
//       pengirim: +628116080804, 
//       tipe_pengirim: Y, 
//       harga: 2275, 
//       kode_inbox: 21052, 
//       status: 20, 
//       tgl_status: 2021-05-05T04:17:31.137Z, 
//       kode_modul: 311, 
//       kode_terminal: 1, 
//       ket_modul: null, 
//       harga_beli: 1775, 
//       kode_jawaban: 21054, 
//       saldo_awal: 755375, 
//       perintah: trx?product=TM1&qty=1&dest=081212365845&refID=6558&memberID=LMC001&sign=39BKT2KFvWm_bzeSlOgcpDEeDrw, 
//       counter: 1, 
//       counter2: 1, 
//       sn: 02316800000368935758, 
//       modul_proses: ,311,, 
//       kirim_ulang: 0, 
//       penerima: , 
//       qty: 1, 
//       kirim_info: 1, 
//       kode_area: , 
//       ref_id: 5867, 
//       params: , 
//       harga_beli2: 1775, 
//       is_voucher: null, 
//       komisi: 100, 
//       bill_set: null, 
//       bill: null, 
//       keterangan: null, 
//       poin: 2, 
//       hide_kiosk: null, 
//       unit: null, 
//       saldo_supplier: null, 
//       produk: {
//           kode: TM1, 
//           nama: Pulsa Telkomsel Denom 1K, 
//           harga_jual: 1875, 
//           harga_beli: 1775, 
//           stok: 0, 
//           aktif: 1, 
//           gangguan: 0, 
//           fisik: 0, 
//           kode_operator: TM, 
//           prefix_tujuan: null, 
//           nominal: 1, 
//           kosong: 0, 
//           kode_hlr: null, 
//           tanpa_kode: 0, 
//           harga_tetap: 0, 
//           kode_

// {
//     kode: 5497, 
//     //tgl_entri: 2021-04-19T06:56:05.317Z, 
//     kode_produk: CMNCPLAY, 
//     //tujuan: 0101800306, 
//     kode_reseller: FUN0104, 
//     pengirim: +628116080804, 
//     tipe_pengirim: Y, 
//     harga: 0, 
//     kode_inbox: 18706, 
//     //status: 40, 
//     //tgl_status: 2021-04-19T06:56:11.397Z, 
//     kode_modul: 309, 
//     kode_terminal: 1, 
//     ket_modul: null, 
//     harga_beli: 0, 
//     kode_jawaban: 18708, 
//     saldo_awal: 755375, 
//     perintah: trx?product=CMNCPLAY&qty=1&dest=0101800306&refID=5497&memberID=LMC001&sign=-Hoy3Haj5GegYudxfu2LfxSvJ00, 
//     counter: 1, 
//     counter2: 0, 
//     sn: null, 
//     modul_proses: ,309,, 
//     kirim_ulang: 0, 
//     penerima: , 
//     qty: 1, 
//     kirim_info: null, 
//     kode_area: , 
//     ref_id: 4283, 
//     params: , 
//     harga_beli2: 0, 
//     is_voucher: null, 
//     komisi: null, 
//     bill_set: null, 
//     bill: null, 
//     keterangan: TRANSAKSI TIDAK DAPAT DIPROSES,SILAHKAN CEK NOMOR TUJUAN, 
//     poin: null, 
//     hide_kiosk: null, 
//     unit: null, 
//     saldo_supplier: null, 
//     produk: {
//         kode: CMNCPLAY, 
//         //nama: CEK MNC PLAY, 
//         //harga_jual: 0, 
//         harga_beli: 0, 
//         stok: 0, 
//         aktif: 1, 
//         gangguan: 0, 
//         fisik: 0, 
//         kode_operator: INET,
//          prefix_tujuan: null, 
//          nominal: 0, 
//          kosong: 0, 
//          kode_hlr: null, 
//          tanpa_k