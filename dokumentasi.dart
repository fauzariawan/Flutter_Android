/// 08 / 03 / 2021
/// 
// class Register extends StatefulWidget {
//   @override
//   _RegisterState createState() => _RegisterState();
// }

// class _RegisterState extends State<Register> {
//   _register() async {
//     final _authority = "192.168.5.108:3000";
//     final _path = "/user";
//     final _params = null; //{"q": "dart"};
//     final _uri = Uri.http(_authority, _path, _params);
//     debugPrint(_uri.toString());
//     http
//         .get(
//       _uri,
//     )
//         .then((response) {
//       print(response.body);
//     }).catchError(throw ('error'));

//     // var status = response.body.contains('error');
//     // final _authority = "localhost:3000";
//     // final _path = "/user";
//     // final _params = null; //{"q": "dart"};
//     // final _uri = Uri.https(_authority, _path, _params);
//     // debugPrint(_uri.toString()); // untuk lihat uri nya udah pas ato blm
//     // var response = await http.get(
//     //   _uri,
//     //   headers: <String, String>{
//     //     'Content-Type': 'application/json',
//     //   },
//     // );
//     // if (response.statusCode == 200) {
//     //   print('berhasil');
//     // } else {
//     //   throw ('gagal');
//     // }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         child: Column(
//       children: [
//         ElevatedButton(
//           style: ButtonStyle(
//               padding: MaterialStateProperty.all(EdgeInsets.all(20)),
//               shape: MaterialStateProperty.all(RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(18.0))),
//               backgroundColor: MaterialStateProperty.all(Colors.green[700])),
//           child: Center(
//             child: Text('REGISTER',
//                 style: TextStyle(fontSize: 20.0, color: Colors.white)),
//           ),
//           onPressed: () {
//             // if (_formRegisterKey.currentState.validate()) {
//             _register();
//             // ScaffoldMessenger.of(context).showSnackBar(
//             //     SnackBar(content: Text('Processing Data')));
//             // }
//           },
//         ),
//       ],
//     ));
//   }
// }

  // Future<album> klo mau memberikan nilai pada class

  // Future _register() async {
  //   final http.Response response =
  //       await http.post('http://localhost:3000/user/register');
  //   if (response.statusCode == 200) {
  //     // If the server did return a 200 OK response,
  //     // then parse the JSON.
  //     // return Album.fromJson(jsonDecode(response.body));
  //     print(response.body);
  //   } else {
  //     // If the server did not return a 200 OK response,
  //     // then throw an exception.
  //     throw Exception('Failed to load album');
  //   }
  // }

  // SNACKBAR //
   // ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text('Processing Data')));


  //// SIRKULAR PROGRESS INSIDE TEXTFORMFIELD /////////////////////////////////
  // TextFormField(
  //       cursorColor: Colors.black,
  //       decoration: InputDecoration(
  //         prefixIcon: Icon(Icons.email),
  //         suffix: isLoading?CircularProgressIndicator():null
  //         errorMaxLines: 2,
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //         errorBorder: OutlineInputBorder(
  //           borderSide: BorderSide(
  //             width: 2,
  //           ),
  //         ),
  //       ),
  //       autocorrect: false,
  //       onChanged: (_) {},
  //       validator: (_) {},
  //     ),


  // Stack(
  //   children: <Widget>[
  //     TextFormField(
  //       cursorColor: Colors.black,
  //       decoration: InputDecoration(
  //         prefixIcon: Icon(Icons.email),
  //         errorMaxLines: 2,
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //         errorBorder: OutlineInputBorder(
  //           borderSide: BorderSide(
  //             width: 2,
  //           ),
  //         ),
  //       ),
  //       autocorrect: false,
  //       onChanged: (_) {},
  //       validator: (_) {},
  //     ),
  //     (state.isSubmitting)
  //         ? Positioned(
  //             top: 5,
  //             right: 5,
  //             child: Container(
  //               child: CircularProgressIndicator(),
  //             ),
  //           )
  //         : Container(),
  //   ],
  // ),

  // DRAWER
  // drawer: Drawer(
  //     child: Column(
  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //   children: [
  //     Text(token /*widget.token*/),
  //     Container(
  //       child: ElevatedButton(
  //         child: Text('Logout'),
  //         onPressed: () {
  //           Navigator.of(context).push(
  //               MaterialPageRoute(builder: (context) => HomePage()));
  //         },
  //       ),
  //     ),
  //     Container(
  //       child: ElevatedButton(
  //         child: Text('show token'),
  //         onPressed: () {
            
  //         },
  //       ),
  //     ),
  //   ],
  // )),

  /////////////////////// BOTTOM APP BAR ///////////////////////
  /// Flutter code sample for BottomAppBar

// This example shows the [BottomAppBar], which can be configured to have a notch using the
// [BottomAppBar.shape] property. This also includes an optional [FloatingActionButton], which illustrates
// the [FloatingActionButtonLocation]s in relation to the [BottomAppBar].

// import 'package:flutter/material.dart';

// void main() {
//   runApp(const BottomAppBarDemo());
// }

// class BottomAppBarDemo extends StatefulWidget {
//   const BottomAppBarDemo({Key? key}) : super(key: key);

//   @override
//   State createState() => _BottomAppBarDemoState();
// }

// class _BottomAppBarDemoState extends State<BottomAppBarDemo> {
//   bool _showFab = true;
//   bool _showNotch = true;
//   FloatingActionButtonLocation _fabLocation =
//       FloatingActionButtonLocation.endDocked;

//   void _onShowNotchChanged(bool value) {
//     setState(() {
//       _showNotch = value;
//     });
//   }

//   void _onShowFabChanged(bool value) {
//     setState(() {
//       _showFab = value;
//     });
//   }

//   void _onFabLocationChanged(FloatingActionButtonLocation? value) {
//     setState(() {
//       _fabLocation = value ?? FloatingActionButtonLocation.endDocked;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           title: const Text('Bottom App Bar Demo'),
//         ),
//         body: ListView(
//           padding: const EdgeInsets.only(bottom: 88),
//           children: <Widget>[
//             SwitchListTile(
//               title: const Text(
//                 'Floating Action Button',
//               ),
//               value: _showFab,
//               onChanged: _onShowFabChanged,
//             ),
//             SwitchListTile(
//               title: const Text('Notch'),
//               value: _showNotch,
//               onChanged: _onShowNotchChanged,
//             ),
//             const Padding(
//               padding: EdgeInsets.all(16),
//               child: Text('Floating action button position'),
//             ),
//             RadioListTile<FloatingActionButtonLocation>(
//               title: const Text('Docked - End'),
//               value: FloatingActionButtonLocation.endDocked,
//               groupValue: _fabLocation,
//               onChanged: _onFabLocationChanged,
//             ),
//             RadioListTile<FloatingActionButtonLocation>(
//               title: const Text('Docked - Center'),
//               value: FloatingActionButtonLocation.centerDocked,
//               groupValue: _fabLocation,
//               onChanged: _onFabLocationChanged,
//             ),
//             RadioListTile<FloatingActionButtonLocation>(
//               title: const Text('Floating - End'),
//               value: FloatingActionButtonLocation.endFloat,
//               groupValue: _fabLocation,
//               onChanged: _onFabLocationChanged,
//             ),
//             RadioListTile<FloatingActionButtonLocation>(
//               title: const Text('Floating - Center'),
//               value: FloatingActionButtonLocation.centerFloat,
//               groupValue: _fabLocation,
//               onChanged: _onFabLocationChanged,
//             ),
//           ],
//         ),
//         floatingActionButton: _showFab
//             ? FloatingActionButton(
//                 onPressed: () {},
//                 child: const Icon(Icons.add),
//                 tooltip: 'Create',
//               )
//             : null,
//         floatingActionButtonLocation: _fabLocation,
//         bottomNavigationBar: _DemoBottomAppBar(
//           fabLocation: _fabLocation,
//           shape: _showNotch ? const CircularNotchedRectangle() : null,
//         ),
//       ),
//     );
//   }
// }

// class _DemoBottomAppBar extends StatelessWidget {
//   const _DemoBottomAppBar({
//     this.fabLocation = FloatingActionButtonLocation.endDocked,
//     this.shape = const CircularNotchedRectangle(),
//   });

//   final FloatingActionButtonLocation fabLocation;
//   final NotchedShape? shape;

//   static final List<FloatingActionButtonLocation> centerLocations =
//       <FloatingActionButtonLocation>[
//     FloatingActionButtonLocation.centerDocked,
//     FloatingActionButtonLocation.centerFloat,
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return BottomAppBar(
//       shape: shape,
//       color: Colors.blue,
//       child: IconTheme(
//         data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
//         child: Row(
//           children: <Widget>[
//             IconButton(
//               tooltip: 'Open navigation menu',
//               icon: const Icon(Icons.menu),
//               onPressed: () {},
//             ),
//             if (centerLocations.contains(fabLocation)) const Spacer(),
//             IconButton(
//               tooltip: 'Search',
//               icon: const Icon(Icons.search),
//               onPressed: () {},
//             ),
//             IconButton(
//               tooltip: 'Favorite',
//               icon: const Icon(Icons.favorite),
//               onPressed: () {},
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


//////////////////////////////// REGULAR EXPRESSION ////////////////////////////////////////////////
// ^\d{0,2}(\.\d{1,2})?$ regEx untuk menerima onli number with decimL
// Your regex ^[0-9] matches anything beginning with a digit, including strings like "1A". To avoid a partial match, append a $ to the end: "^[0-9]*$" allow negativ " /^-?[0-9]*$/"
// RegExp regEx = RegExp(r'^[0-9]+$', caseSensitive: true, multiLine: true);