import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
// import 'qr_code_scanner.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'component.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'dart:async';

import 'dashboard.dart';

class ScanQrCode extends StatefulWidget {
  ScanQrCode({Key key}) : super(key: key);
  @override
  _ScanQrCodeState createState() => _ScanQrCodeState();
}

class _ScanQrCodeState extends State<ScanQrCode> {
  Barcode result;
  List data;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  TextEditingController nominalMarkup = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  LocalStorage storage = new LocalStorage('localstorage_app');
  dynamic res;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Funmobile'),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await controller?.toggleFlash();
              setState(() {});
            },
            icon: Icon(Icons.flash_auto),
          ),
          IconButton(
            onPressed: () async {
              await controller?.flipCamera();
              setState(() {});
            },
            icon: Icon(Icons.change_circle),
          )
        ],
      ),
      body: 
      Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          // Expanded(
          //   flex: 1,
          //   child: FittedBox(
          //     fit: BoxFit.contain,
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: <Widget>[
          //         // if (result != null)
          //         //   Text(
          //         //       'Barcode Type: ${describeEnum(result.format)}   Data: ${result.code}')
          //         // else
          //         //   Text('Scan a code'),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           children: <Widget>[
          //             Container(
          //               margin: EdgeInsets.all(8),
          //               child: ElevatedButton(
          //                   onPressed: () async {
          //                     await controller?.toggleFlash();
          //                     setState(() {});
          //                   },
          //                   child: FutureBuilder(
          //                     future: controller?.getFlashStatus(),
          //                     builder: (context, snapshot) {
          //                       return Text('Flash: ${snapshot.data}');
          //                     },
          //                   )),
          //             ),
          //             Container(
          //               margin: EdgeInsets.all(8),
          //               child: ElevatedButton(
          //                   onPressed: () async {
          //                     await controller?.flipCamera();
          //                     setState(() {});
          //                   },
          //                   child: FutureBuilder(
          //                     future: controller?.getCameraInfo(),
          //                     builder: (context, snapshot) {
          //                       if (snapshot.data != null) {
          //                         return Text(
          //                             'Camera facing ${describeEnum(snapshot.data)}');
          //                       } else {
          //                         return Text('loading');
          //                       }
          //                     },
          //                   )),
          //             )
          //           ],
          //         ),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           children: <Widget>[
          //             Container(
          //               margin: EdgeInsets.all(8),
          //               child: ElevatedButton(
          //                 onPressed: () async {
          //                   await controller?.pauseCamera();
          //                 },
          //                 child: Text('pause', style: TextStyle(fontSize: 20)),
          //               ),
          //             ),
          //             Container(
          //               margin: EdgeInsets.all(8),
          //               child: ElevatedButton(
          //                 onPressed: () async {
          //                   await controller?.resumeCamera();
          //                 },
          //                 child: Text('resume', style: TextStyle(fontSize: 20)),
          //               ),
          //             )
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 450.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }

  changeFormat() {
    String fix = FormatUang.formatUang(nominalMarkup);
    final val = TextSelection.collapsed(
        offset: fix.length); // to set cursor position at the end of the value
    setState(() {
      nominalMarkup.text = fix;
      nominalMarkup.selection =
          val; // to set cursor position at the end of the value
    });
  }

  loading() {
    showDialog(
        // barrierDismissible: false,
        context: this.context,
        builder: (BuildContext context) {
          return Loading();
        });
  }

  complete() {
    Navigator.pop(context);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Dashboard(
              selected: 0,
            )));
  }

  tambahSaldoDownline(String destiny, String pin) async {
    loading();
    final baseUrl = DotEnv.env['BASE_URL'];
    final path = "inbox/inboxbalancecross";
    final params = null;
    final url = Uri.http(baseUrl, path, params);
    debugPrint(url.toString());

    var response = await http.post(url, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "token": storage.getItem('token')
    }, body: {
      "destiny": destiny,
      "nominal": nominalMarkup.text,
      "pin": pin
    });
    if (response.statusCode == 200) {
      res = json.decode(response.body);
      if (res['rc'] == '01' || res['rc'] == '02') {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(res['pesan']),
        ));
      } else {
        print(res);
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('TRANSFER SALDO BERHASIL'),
                content: Text(res['pesan']),
              );
            });
        Timer(Duration(seconds: 3), complete);
      }
    } else {
      print(response.body);
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      // setState(() {
      result = scanData;
      // print(result.format);
      data = result.code.split('/');
      print(data);
      // });
      showDialog(
          // barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Tambah Saldo ${data[1]}'),
              content: Container(
                height: 120,
                child: Column(children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: nominalMarkup,
                    onChanged: (nominalMarkup) {
                      changeFormat();
                    },
                    decoration: InputDecoration(prefixText: 'Rp '),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Masukkan Pin Anda'),
                                    content: Form(
                                      key: formKey,
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 30),
                                          child: PinCodeTextField(
                                            appContext: context,
                                            // controller: pinReseller,
                                            keyboardType: TextInputType.number,
                                            length: 6,
                                            obscureText: true,
                                            obscuringCharacter: '*',
                                            cursorColor: Colors.indigo[400],
                                            // enableActiveFill: true,
                                            pinTheme: PinTheme(
                                              fieldHeight: 40,
                                              fieldWidth: 30,
                                              shape: PinCodeFieldShape.box,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              selectedColor: Colors.indigo[400],
                                              // activeFillColor: Colors.indigo[700] blm tau untuk apa
                                            ),
                                            validator: (variablenyabebas) {
                                              if (variablenyabebas.length < 6) {
                                                return "Must 6 digit";
                                              } else {
                                                return null;
                                              }
                                            },
                                            onChanged: (value) {},
                                            onCompleted: (v) {
                                              String pin = v;
                                              Navigator.pop(context);
                                              tambahSaldoDownline(data[2], pin);
                                            },
                                            // onTap: () {
                                            //   print("Pressed");
                                            // },
                                            // pastedTextStyle: TextStyle(
                                            //   color: Colors.yellow,
                                            //   fontWeight: FontWeight.bold,
                                            // ),
                                            // obscuringWidget: FlutterLogo(
                                            //   size: 24,
                                            // ),
                                            // blinkWhenObscuring: true,
                                            // animationType: AnimationType.fade,
                                            // animationDuration: Duration(milliseconds: 300),
                                            // // errorAnimationController: errorController,

                                            // boxShadows: [
                                            //   BoxShadow(
                                            //     offset: Offset(0, 1),
                                            //     color: Colors.black12,
                                            //     blurRadius: 10,
                                            //   )
                                            // ],

                                            // beforeTextPaste: (text) {
                                            //   print("Allowing to paste $text");
                                            //   //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                            //   //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                            //   return true;
                                            // },
                                          )),
                                    ),
                                  );
                                });
                          },
                          child: Text('Lanjutkan')),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Batal'))
                    ],
                  )
                ]),
              ),
            );
          });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
