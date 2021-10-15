import 'dart:io';
import 'dart:typed_data';
import 'package:android/history/preview.dart';
import 'package:android/history/previewMutasi.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../component.dart';
import '../listWarna.dart';
import '../routerName.dart';
import 'formatPrint.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class ChoosePrinter extends StatefulWidget {
  ChoosePrinter(
      {this.type,
      this.dataToko,
      this.data,
      this.ket,
      this.biaya,
      this.admin,
      this.denda,
      this.cetak,
      this.header,
      this.alamat});
  final String type;
  final dynamic dataToko;
  final dynamic data;
  final dynamic ket;
  final int biaya;
  final int admin;
  final int denda;
  final int cetak;
  final String header;
  final String alamat;
  @override
  _ChoosePrinterState createState() => _ChoosePrinterState();
}

class _ChoosePrinterState extends State<ChoosePrinter> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothDevice> _devices = [];
  List<BluetoothDevice> devices = [];
  BluetoothDevice deviceSelected;
  BluetoothDevice _device;
  bool _connected = false;
  String pathImage;
  FormatPrint testPrint;
  String _selectedPrinter;
  List<dynamic> perangkats = [];
  int selectedIndex;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initSavetoPath();
    testPrint = FormatPrint();
  }

  initSavetoPath() async {
    //read and write
    //image max 300px X 300px
    final filename = 'myLogo.jpg';
    var bytes = await rootBundle.load("image/funmo/myLogo.jpg");
    String dir = (await getApplicationDocumentsDirectory()).path;
    writeToFile(bytes, '$dir/$filename');
    setState(() {
      pathImage = '$dir/$filename';
    });
  }

  Future<void> initPlatformState() async {
    _connected = await bluetooth.isConnected;
    print(_connected);

    if (_connected) {
      await _disconnect();
    }
    try {
      devices = await bluetooth.getBondedDevices();
      print(devices);
      devices.forEach((element) {
        perangkats.add({
          "name": element.name,
          "address": element.address,
          "isConnected": element.connected,
          "type": element.type,
        });
      });
      print(perangkats);
    } on PlatformException {
      print('No Device Found'); // kalau error (tidak menemukan devices)
    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
          });
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });

    if (_connected) {
      setState(() {
        _connected = true;
      });
    }
  }

  complete() {
    if (widget.type == 'transaksi') {
      print('ini print struk transaksi');
      Navigator.popAndPushNamed(context, detailTransaksi,
          arguments: widget.data);
      // Navigator.of(context).push(
      //     MaterialPageRoute(builder: (context) => Preview(data: widget.data)));
    } else {
      print('ini print struk Mutasi');
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PreviewMutasi(data: widget.data)));
    }
  }

  cetak(BluetoothDevice _device) async {
    // print(_device);
    await bluetooth
        .connect(_device)
        .then((value) => {
              print('print sudah terhubung'),
              print(value.toString()),
              setState(() {
                selectedIndex = null;
              }),
              // if (widget.ket == null) {
              //   print('ket nilainya null')
              // } else {
              //   print('tidak jelas')
              // },
              if (widget.type == 'transaksi')
                testPrint.sample(
                    pathImage,
                    widget.data,
                    widget.ket,
                    widget.biaya,
                    widget.admin,
                    widget.denda,
                    widget.cetak,
                    widget.header,
                    widget.alamat,
                    widget.dataToko),
              if (widget.type == 'mutasi')
                testPrint.mutasi(
                  widget.data,
                ),
              Timer(Duration(seconds: 2), complete)
            })
        .catchError((error) {
      show('check printer power or printer name');
      setState(() {
        selectedIndex = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Pilih Printer'),
        ),
        body: perangkats.length > 0
            ? ListView.builder(
                itemCount: perangkats.length,
                itemBuilder: (c, i) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = i;
                      });
                      cetak(devices[i]);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              CircleAvatar(
                                  backgroundColor: Warna.warna(biru),
                                  radius: 25,
                                  child: Icon(
                                    Icons.print,
                                    color: Warna.warna(kuning),
                                    size: 30,
                                  )),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(perangkats[i]['name']),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(perangkats[i]['address']),
                                ],
                              ),
                            ],
                          ),
                          selectedIndex == i
                              ? SpinKitCircle(
                                  size: 20, color: Warna.warna(biru))
                              : Container()
                        ],
                      ),
                    ),
                  );
                })
            : null
        // Container(
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: ListView(
        //       children: <Widget>[
        //         Row(
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: <Widget>[
        //             SizedBox(
        //               width: 10,
        //             ),
        //             Text(
        //               'Device:',
        //               style: TextStyle(
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             ),
        //             SizedBox(
        //               width: 30,
        //             ),
        //             Expanded(
        //               child: DropdownButton(
        //                 items: _getDeviceItems(),
        //                 onChanged: (value) => setState(() {
        //                   _device = value;
        //                 }),
        //                 value: _device,
        //               ),
        //             ),
        //           ],
        //         ),
        //         SizedBox(
        //           height: 10,
        //         ),
        //         Row(
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           mainAxisAlignment: MainAxisAlignment.end,
        //           children: <Widget>[
        //             ElevatedButton(
        //               // color: Colors.brown,
        //               onPressed: () {
        //                 initPlatformState();
        //               },
        //               child: Text(
        //                 'Refresh',
        //                 style: TextStyle(color: Colors.white),
        //               ),
        //             ),
        //             SizedBox(
        //               width: 20,
        //             ),
        //             ElevatedButton(
        //               style: ButtonStyle(
        //                   backgroundColor: _connected
        //                       ? MaterialStateProperty.all<Color>(Colors.red)
        //                       : MaterialStateProperty.all<Color>(Colors.green)),
        //               onPressed: _connected ? _disconnect : _connect,
        //               child: Text(
        //                 _connected ? 'Disconnect' : 'Connect',
        //                 style: TextStyle(color: Colors.white),
        //               ),
        //             ),
        //           ],
        //         ),
        //         Padding(
        //           padding:
        //               const EdgeInsets.only(left: 10.0, right: 10.0, top: 50),
        //           child: ElevatedButton(
        //             // color: Colors.brown,
        //             onPressed: () {
        //               // print(_device);
        //               print(widget.dataToko);
        //               if (widget.ket == null) {
        //                 print('ket nilainya null');
        //               } else {
        //                 print('tidak jelas');
        //               }
        //               if (widget.type == 'transaksi')
        //                 testPrint.sample(
        //                     pathImage,
        //                     widget.data,
        //                     widget.ket,
        //                     widget.biaya,
        //                     widget.admin,
        //                     widget.denda,
        //                     widget.cetak,
        //                     widget.header,
        //                     widget.alamat,
        //                     widget.dataToko);
        //               if (widget.type == 'mutasi')
        //                 testPrint.mutasi(
        //                   widget.data,
        //                 );
        //             },
        //             child: Text('PRINT', style: TextStyle(color: Colors.white)),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        );
  }

  selectedPrinter(String device, BluetoothDevice _deviceSelected) {
    _selectedPrinter = device;
    _device = _deviceSelected;
    print('Ini print yang di pilih >>>>');
    print(_selectedPrinter);
    print(deviceSelected);
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devices.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devices.forEach((device) {
        items.add(DropdownMenuItem(
          // onTap: selectedPrinter(device.name, device),
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }

  void _connect() {
    if (_device == null) {
      show('No device selected.');
    } else {
      bluetooth.isConnected.then((isConnected) {
        if (!isConnected) {
          bluetooth.connect(_device).catchError((error) {
            setState(() => _connected = false);
          });
          setState(() => _connected = true);
        }
      });
    }
  }

  Future<void> _disconnect() async {
    await bluetooth.disconnect();
    setState(() => _connected = true);
  }

  //write to app path
  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: new TextStyle(color: Colors.white),
      ),
      duration: duration,
    ));
  }
}
