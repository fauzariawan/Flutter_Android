import "package:flutter/material.dart";

class QrImage extends StatefulWidget {
  QrImage({this.image});
  final String image;
  @override
  _QrImageState createState() => _QrImageState();
}

class _QrImageState extends State<QrImage> {
  @override
  void initState() {
    print('ini data nya <<<<<<<<<');
    print(widget.image);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Image"),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Image.network(widget.image),
      ),
    );
  }
}
