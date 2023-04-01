// import 'package:flutter/material.dart';
// import 'dashboard.dart';
// import 'loginnew.dart';
//
// void main() {
//   const primaryColor = Colors.deepPurpleAccent;
//   runApp(MaterialApp(
//     theme: ThemeData(
//       primaryColor: primaryColor,
//       appBarTheme: AppBarTheme(
//         iconTheme: IconThemeData(color: Colors.black),
//         color: Colors.deepPurpleAccent, //<-- SEE HERE
//       ),
//     ),
//     home: HomePage(),
//   ));
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Center( child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           TextButton(
//             style: TextButton.styleFrom(backgroundColor: Color.fromRGBO(143, 148, 251, 1),padding: EdgeInsets.all(15)),
//             onPressed: null,
//             child: Text("Allocate duty",style: TextStyle(color: Colors.black87,fontSize: 18),),
//           ),
//           TextButton(
//             style: TextButton.styleFrom(backgroundColor: Color.fromRGBO(143, 148, 251, 1),padding: EdgeInsets.all(10)),
//             onPressed: null,
//             child: Text("Reallocate duty",style: TextStyle(color: Colors.black87,fontSize: 18),),
//           ),
//           TextButton(
//             style: TextButton.styleFrom(backgroundColor:Color.fromRGBO(143, 148, 251, 1),padding: EdgeInsets.all(10)),
//             onPressed: null,
//             child: Text("Add Students/Faculties",style: TextStyle(color: Colors.black87,fontSize: 18),),
//           ),
//         ],
//       ),),
//     );
//   }
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Duty Normalizer"),
//       ),
//       body: MyHomePage(),
//
//     );
//   }
// }
//
//
//
//
// // import 'package:flutter/material.dart';
// //
// // void main() => runApp(MyApp());
//
// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Flutter Card Grid',
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //       ),
// //       // home: MyHomePage(title: 'Flutter Card Grid'),
// //       home: Dashboard(),
// //     );
// //   }
// // }
// //
// // class MyHomePage extends StatefulWidget {
// //   MyHomePage({Key? key, required this.title}) : super(key: key);
// //   final String title;
// //
// //   @override
// //   _MyHomePageState createState() => _MyHomePageState();
// // }
// //
// // class _MyHomePageState extends State<MyHomePage> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(widget.title),
// //       ),
// //       body: GridView.count(
// //         crossAxisCount: 2,
// //         children: <Widget>[
// //           Card(
// //             child: Column(
// //               children: <Widget>[
// //                 Image.network('https://picsum.photos/300/200?image=0'),
// //                 Padding(
// //                   padding: EdgeInsets.all(16.0),
// //                   child: Text('Card 1'),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           Card(
// //             child: Column(
// //               children: <Widget>[
// //                 Image.network('https://picsum.photos/300/200?image=1'),
// //                 Padding(
// //                   padding: EdgeInsets.all(16.0),
// //                   child: Text('Card 2'),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           Card(
// //             child: Column(
// //               children: <Widget>[
// //                 Image.network('https://picsum.photos/300/200?image=2'),
// //                 Padding(
// //                   padding: EdgeInsets.all(16.0),
// //                   child: Text('Card 3'),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           Card(
// //             child: Column(
// //               children: <Widget>[
// //                 Image.network('https://picsum.photos/300/200?image=3'),
// //                 Padding(
// //                   padding: EdgeInsets.all(16.0),
// //                   child: Text('Card 4'),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// import 'package:day12_login/Animation/FadeAnimation.dart';
import 'package:flutter/material.dart';
import 'dashboard.dart';

void main() => runApp(MyApp());

class loginnew extends StatefulWidget {
  const loginnew({Key? key}) : super(key: key);

  @override
  State<loginnew> createState() => _loginnewState();
}

class _loginnewState extends State<loginnew> {
  String _pin = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/background.png'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        width: 80,
                        height: 200,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/light-1.png'))),
                        ),
                      ),
                      Positioned(
                        left: 140,
                        width: 80,
                        height: 150,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/light-2.png'))),
                        ),
                      ),
                      Positioned(
                        right: 40,
                        top: 40,
                        width: 80,
                        height: 150,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/clock.png'))),
                        ),
                      ),
                      Positioned(
                        child: Container(
                          margin: EdgeInsets.only(top: 50),
                          child: Center(
                            child: Text(
                              "Duty Normalizer",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(143, 148, 251, .2),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 10))
                            ]),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                obscureText: true,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Enter your PIN",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                                onChanged: (value) {
                                  setState(() {
                                    _pin = value;
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),

                      TextButton(
                        onPressed: _onSubmit,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(143, 148, 251, 1),
                                Color.fromRGBO(143, 148, 251, .6),
                              ])),
                          child: Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 19,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 70,
                      ),

                      // Text(
                      //   "Forgot Key?",
                      //   style: TextStyle(
                      //       color: Color.fromRGBO(143, 148, 251, 1)),
                      // ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void _onSubmit() {
    if (_pin == "1234") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('ERROR'),
          content: Text('INCORRECT PASSWORD!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: loginnew());
  }
}
