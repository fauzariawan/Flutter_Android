import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import '../dashboard.dart';

class UbahToko extends StatefulWidget {
  const UbahToko({Key key}) : super(key: key);

  @override
  _UbahTokoState createState() => _UbahTokoState();
}

class _UbahTokoState extends State<UbahToko> {
  dynamic dataToko;
  dynamic dataUser;
  TextEditingController namaToko = new TextEditingController();
  TextEditingController alamatToko = new TextEditingController();
  LocalStorage storage = new LocalStorage('localstorage_app');
  final _formDataToko = GlobalKey<FormState>();
  String tipeToko;
  // dynamic tipeToko = {
  //   "1":"Grosir", "2":"Eceran", "3":"Warnet", "4":"Toko Handphone"
  // };

  // List<ListItem> _dropdownItems = [
  //   ListItem(1, "Grosir"),
  //   ListItem(2, "Eceran"),
  //   ListItem(3, "Warnet"),
  //   ListItem(4, "Toko Handphone")
  // ];
  // List<DropdownMenuItem<ListItem>> _dropdownMenuItems;
  // ListItem _selectedItem;
  // List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
  //   List<DropdownMenuItem<ListItem>> items = List();
  //   for (ListItem listItem in listItems) {
  //     items.add(
  //       DropdownMenuItem(
  //         child: Text(listItem.name),
  //         value: listItem,
  //       ),
  //     );
  //   }
  //   return items;
  // }

  void initState() {
    super.initState();
    // _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    // _selectedItem = _dropdownMenuItems[0].value;
    getDataToko();
  }

  getDataToko() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      dataUser = json.decode(prefs.getString("dataUser"));
      dataToko = dataUser['reseller_toko'];
      tipeToko = dataToko['tipe_toko'];
      namaToko = TextEditingController(
          text: dataToko != null ? dataToko['nama_toko'] : namaToko.text);
      alamatToko = TextEditingController(
          text: dataToko != null ? dataToko['alamat_toko'] : alamatToko.text);
    });
  }

  simpan() async {
    print(namaToko.text);
    print(alamatToko.text);
    print(tipeToko);
    final _baseUrl = DotEnv.env['BASE_URL'];
    final _path = "/reseller/rst";
    final _params = null; //{"q": "dart"}; /* untuk query */
    final _uri = Uri.http(_baseUrl, _path, _params);
    debugPrint(_uri.toString());

    var response = await http.post(_uri, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "token": storage.getItem('token')
    }, body: {
      "namaToko": namaToko.text,
      "alamatToko": alamatToko.text,
      "tipeToko": tipeToko,
    });

    if (response.statusCode == 200) {
      // print(response.body);
      dynamic res = json.decode(response.body);
      String pesan = res['pesan'];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(pesan),
      ));
    } else {
      // print(response.body);
      dynamic res = json.decode(response.body);
      String pesan = res['pesan'];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(pesan),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          centerTitle: true,
          // backgroundColor: Colors.blue,
          title: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Dashboard()));
                },
                child: Center(
                  child: Center(
                    child: Text(
                      'Ubah Toko',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Form(
          key: _formDataToko,
          child: Container(
            // height: MediaQuery.of(context).size.height / 2 - 100,
            margin: EdgeInsets.all(10),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  focusNode: FocusNode(canRequestFocus: false),
                  autocorrect: false,
                  controller: namaToko,
                  validator: (namaToko) {
                    if (namaToko.isEmpty) {
                      return 'Nama Toko Harus Diisi';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'Nama Toko', border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  focusNode: FocusNode(
                      canRequestFocus:
                          false), // This should prevent your TextField from requesting focus after clicking on the dropdown.
                  autocorrect: false,
                  controller: alamatToko,
                  validator: (alamatToko) {
                    if (alamatToko.isEmpty) {
                      return 'Alamat Toko Harus Diisi';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Alamat Toko'),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5))),
                  child: DropdownButton<String>(
                      // isDense: true,
                      // autofocus: true,
                      value: tipeToko,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 42,
                      underline: SizedBox(),
                      onChanged: (String newValue) {
                        FocusScope.of(context).requestFocus(
                            FocusNode()); // agar fokus tidak lari ke textfield
                        // setState(() {
                        tipeToko = newValue;
                        // });
                      },
                      items: <String>[
                        'Grosir',
                        'Eceran',
                        'Warnet',
                        'Toko Handphone'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(growable: false)),
                ),
                ElevatedButton(
                    onPressed: () {
                      simpan();
                    },
                    child: Text('Simpan'))
              ],
            ),
          ),
        ));
  }
}
// class ListItem {
//   int value;
//   String name;

//   ListItem(this.value, this.name);
// }
