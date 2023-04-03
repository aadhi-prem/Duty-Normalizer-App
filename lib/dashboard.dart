
import 'package:flutter/material.dart';
import 'package:demoapp/BlockUnblock.dart';
import 'package:demoapp/add_main.dart';
import 'package:demoapp/delete.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'delete.dart';
import 'confirmpin.dart';

class CustomButton extends StatelessWidget {
  final String label;

  const CustomButton({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      width: 320,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(fontSize: 26,fontFamily: "Rubic"),
        ),
      ),
    );
  }
}



class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = -1;
  static const List<Widget> _widgetOptions = <Widget>[
    Text('Add'),
    Text('Delete'),
    Text('Reset'),
    Text('Block'),
  ];

  @override
  Widget build(BuildContext context) {

    showAlertDialog(BuildContext context) {
      // set up the buttons
      Widget cancelButton = TextButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
          // Navigator.pushReplacement(context, MaterialPageRoute(
          //   builder: (context) => Dashboard(),
          // ),); //dismiss dialog
        },
        child: Text("Cancel"),
      );
      Widget continueButton = TextButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => PinEntryPage(),
          ),); /////////////// add the enter pin function here
        },
        child: Text("Continue"),
      );
      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Alert"),
        content: Text(
            "Are you sure you want to reset work hours?"),
        actions: [
          cancelButton,
          continueButton,
        ],
      );
      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
      return MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              "Duty Normalizer",
            ),
            elevation: .1,
            backgroundColor: Color(
                0xff9381ff), //Color.fromRGBO(143, 148, 251, 1), //violet color
          ),
          body: Container(
            height: 700,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: <Widget>[
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 1),
                      CustomButton(label: 'Assign Duty'),
                      SizedBox(height: 35),
                      CustomButton(label: 'Reallocate Duty'),
                      SizedBox(height: 35),
                      CustomButton(label: 'Duty Report\n Generation'),
                      SizedBox(height: 35),
                      CustomButton(label: 'Delete Duty'),
                    ],
                  ),
                ),
                Positioned(
                  left: 30,
                  width: 80,
                  height: 150,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/light-1.png'))),
                  ),
                ),
                Positioned(
                  left: 140,
                  width: 80,
                  height: 120,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/light-2.png'))),
                  ),
                ),
                Positioned(
                  top: 95,
                  right: 20,
                  child: Transform.rotate(angle: 20 * (3.14 / 180),
                      child: Image.asset(
                        'assets/assigndemo.png', height: 110,)),
                ),
                Positioned(
                  top: 235,
                  left: 25,
                  child: Transform.rotate(angle: 340 * (3.14 / 180),
                      child: Image.asset(
                          'assets/reallocatedemo.png', height: 120)),
                ),
                Positioned(
                  top: 340,
                  right: 30,
                  child: Transform.rotate(angle: 25 * (3.14 / 180),
                      child: Image.asset('assets/reportdemo.png', height: 95)),
                ),
                Positioned(
                  top: 450,
                  left: 15,
                  child: Transform.rotate(angle: 340 * (3.14 / 180),
                      child: Image.asset('assets/deletedemo.png', height: 115)),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Color(0xff9381ff),
            //Color.fromRGBO(143, 148, 251, 1),
            items: const <BottomNavigationBarItem>[
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.home),
              //   label: "Home",
              //   // backgroundColor: Colors.yellow
              // ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: "Add",
                // backgroundColor: Colors.green
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.delete),
                label: "Delete",
                // backgroundColor: Colors.yellow
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.refresh),
                label: "Reset",
                // backgroundColor: Colors.yellow
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.block),
                label: "Block",

                // backgroundColor: Colors.blue,
              ),
            ],
            type: BottomNavigationBarType.fixed,
            fixedColor: Colors.deepPurple[900],
            // selectedItemColor: Colors.deepPurple[900],
            // unselectedItemColor: Colors.black45,
            iconSize: 40,
            elevation: 5,
            onTap: (int index) {
              setState(() {
                _selectedIndex = index;
              });
              switch (index) {
                case 0:
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Add(),
                    ),
                  );
                  break;
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DeletePage(dept: 'null', category: 'null',),
                    ),
                  );
                  break;
                case 2:
                  showAlertDialog(context);
                  break;
                case 3:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          block(dept: 'null', category: 'null',),
                    ),
                  );
              }
            },
          ),
        ),
      );
    }
  }



//     return const Placeholder();
//   }
// }
//
//
//
// class DemoDashstless extends StatelessWidget {
//   int _selectedIndex = -1;
//   const List<Widget> _widgetOptions = <Widget>[
//     Text('Add'),
//     Text('Delete'),
//     Text('Reset'),
//     Text('Block'),
//   ];
// }
//   @override
//   Widget build(BuildContext context) {
//
//     showAlertDialog(BuildContext context) {
//       // set up the buttons
//       Widget cancelButton = TextButton(
//         onPressed: () {
//           Navigator.of(context, rootNavigator: true).pop();
//           // Navigator.pushReplacement(context, MaterialPageRoute(
//           //   builder: (context) => Dashboard(),
//           // ),); //dismiss dialog
//         },
//         child: Text("Cancel"),
//       );
//       Widget continueButton = TextButton(
//         onPressed: () {
//           Navigator.of(context, rootNavigator: true).pop();
//           Navigator.push(context, MaterialPageRoute(
//             builder: (context) => PinEntryPage(),
//           ),); /////////////// add the enter pin function here
//         },
//         child: Text("Continue"),
//       );
//       // set up the AlertDialog
//       AlertDialog alert = AlertDialog(
//         title: Text("Alert"),
//         content: Text(
//             "Are you sure you want to reset work hours?"),
//         actions: [
//           cancelButton,
//           continueButton,
//         ],
//       );
//       // show the dialog
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return alert;
//         },
//       );
//       return MaterialApp(
//         home: Scaffold(
//           backgroundColor: Colors.white,
//           appBar: AppBar(
//             title: Text(
//               "Duty Normalizer",
//             ),
//             elevation: .1,
//             backgroundColor: Color(0xff9381ff), //Color.fromRGBO(143, 148, 251, 1), //violet color
//           ),
//           body: Container(
//             height: 700,
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/background.png'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//             child: Stack(
//               children: <Widget>[
//                 Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       SizedBox(height: 5),
//                       CustomButton(label: 'Assign Duty'),
//                       SizedBox(height: 30),
//                       CustomButton(label: 'Reallocate Duty'),
//                       SizedBox(height: 30),
//                       CustomButton(label: 'Duty Report\n Generation'),
//                       SizedBox(height: 30),
//                       CustomButton(label: 'Delete Duty'),
//                     ],
//                   ),
//                 ),
//                 Positioned(
//                   left: 30,
//                   width: 80,
//                   height: 160,
//                   child: Container(
//                     decoration: BoxDecoration(
//                         image: DecorationImage(
//                             image: AssetImage('assets/light-1.png'))),
//                   ),
//                 ),
//                 Positioned(
//                   left: 140,
//                   width: 80,
//                   height: 120,
//                   child: Container(
//                     decoration: BoxDecoration(
//                         image: DecorationImage(
//                             image: AssetImage('assets/light-2.png'))),
//                   ),
//                 ),
//                 Positioned(
//                   top: 105,
//                   right: 20,
//                   child: Transform.rotate(angle: 20 * (3.14 / 180),child: Image.asset('assets/assigndemo.png', height: 110,)),
//                 ),
//                 Positioned(
//                   top: 235,
//                   left: 25,
//                   child: Transform.rotate(angle: 340 * (3.14 / 180),child: Image.asset('assets/reallocatedemo.png', height: 120)),
//                 ),
//                 Positioned(
//                   top: 340,
//                   right: 30,
//                   child: Transform.rotate(angle: 25 * (3.14 / 180),child: Image.asset('assets/reportdemo.png', height: 95)),
//                 ),
//                 Positioned(
//                   top: 440,
//                   left: 20,
//                   child: Transform.rotate(angle: 340 * (3.14 / 180),child: Image.asset('assets/deletedemo.png', height: 115)),
//                 ),
//               ],
//             ),
//           ),
//           bottomNavigationBar: BottomNavigationBar(
//             backgroundColor: Color(0xff9381ff),
//             //Color.fromRGBO(143, 148, 251, 1),
//             items: const <BottomNavigationBarItem>[
//               // BottomNavigationBarItem(
//               //   icon: Icon(Icons.home),
//               //   label: "Home",
//               //   // backgroundColor: Colors.yellow
//               // ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.add),
//                 label: "Add",
//                 // backgroundColor: Colors.green
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.delete),
//                 label: "Delete",
//                 // backgroundColor: Colors.yellow
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.refresh),
//                 label: "Reset",
//                 // backgroundColor: Colors.yellow
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.block),
//                 label: "Block",
//
//                 // backgroundColor: Colors.blue,
//               ),
//             ],
//             type: BottomNavigationBarType.fixed,
//             fixedColor: Colors.deepPurple[900],
//             // selectedItemColor: Colors.deepPurple[900],
//             // unselectedItemColor: Colors.black45,
//             iconSize: 40,
//             elevation: 5,
//             onTap: (int index) {
//               setState(() {
//                 _selectedIndex = index;
//               });
//               switch (index) {
//                 case 0:
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => Add(),
//                     ),
//                   );
//                   break;
//                 case 1:
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => DeletePage(dept: 'null', category: 'null',),
//                     ),
//                   );
//                   break;
//                 case 2:
//                   showAlertDialog(context);
//                   break;
//                 case 3:
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => block(dept: 'null', category: 'null',),
//                     ),
//                   );
//               }
//             },
//           ),
//         ),
//       );
//     }
//
//     }
//

//     return MaterialApp(
//       home: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           title: Text(
//             "Duty Normalizer",
//           ),
//           elevation: .1,
//           backgroundColor: Color(0xff9381ff), //Color.fromRGBO(143, 148, 251, 1), //violet color
//         ),
//         body: Container(
//           height: 700,
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage('assets/background.png'),
//               fit: BoxFit.cover,
//             ),
//           ),
//           child: Stack(
//             children: <Widget>[
//               Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     SizedBox(height: 5),
//                     CustomButton(label: 'Assign Duty'),
//                     SizedBox(height: 30),
//                     CustomButton(label: 'Reallocate Duty'),
//                     SizedBox(height: 30),
//                     CustomButton(label: 'Duty Report\n Generation'),
//                     SizedBox(height: 30),
//                     CustomButton(label: 'Delete Duty'),
//                   ],
//                 ),
//               ),
//               Positioned(
//                 left: 30,
//                 width: 80,
//                 height: 160,
//                 child: Container(
//                   decoration: BoxDecoration(
//                       image: DecorationImage(
//                           image: AssetImage('assets/light-1.png'))),
//                 ),
//               ),
//               Positioned(
//                 left: 140,
//                 width: 80,
//                 height: 120,
//                 child: Container(
//                   decoration: BoxDecoration(
//                       image: DecorationImage(
//                           image: AssetImage('assets/light-2.png'))),
//                 ),
//               ),
//               Positioned(
//                 top: 105,
//                 right: 20,
//                 child: Transform.rotate(angle: 20 * (3.14 / 180),child: Image.asset('assets/assigndemo.png', height: 110,)),
//               ),
//               Positioned(
//                 top: 235,
//                 left: 25,
//                 child: Transform.rotate(angle: 340 * (3.14 / 180),child: Image.asset('assets/reallocatedemo.png', height: 120)),
//               ),
//               Positioned(
//                 top: 340,
//                 right: 30,
//                 child: Transform.rotate(angle: 25 * (3.14 / 180),child: Image.asset('assets/reportdemo.png', height: 95)),
//               ),
//               Positioned(
//                 top: 440,
//                 left: 20,
//                 child: Transform.rotate(angle: 340 * (3.14 / 180),child: Image.asset('assets/deletedemo.png', height: 115)),
//               ),
//             ],
//           ),
//         ),
//         bottomNavigationBar: BottomNavigationBar(
//           backgroundColor: Color(0xff9381ff),
//           //Color.fromRGBO(143, 148, 251, 1),
//           items: const <BottomNavigationBarItem>[
//             // BottomNavigationBarItem(
//             //   icon: Icon(Icons.home),
//             //   label: "Home",
//             //   // backgroundColor: Colors.yellow
//             // ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.add),
//               label: "Add",
//               // backgroundColor: Colors.green
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.delete),
//               label: "Delete",
//               // backgroundColor: Colors.yellow
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.refresh),
//               label: "Reset",
//               // backgroundColor: Colors.yellow
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.block),
//               label: "Block",
//
//               // backgroundColor: Colors.blue,
//             ),
//           ],
//           type: BottomNavigationBarType.fixed,
//           fixedColor: Colors.deepPurple[900],
//           // selectedItemColor: Colors.deepPurple[900],
//           // unselectedItemColor: Colors.black45,
//           iconSize: 40,
//           elevation: 5,
//           onTap: (int index) {
//             setState(() {
//               _selectedIndex = index;
//             });
//             switch (index) {
//               case 0:
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => Add(),
//                   ),
//                 );
//                 break;
//               case 1:
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => DeletePage(dept: 'null', category: 'null',),
//                   ),
//                 );
//                 break;
//               case 2:
//                 showAlertDialog(context);
//                 break;
//               case 3:
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => block(dept: 'null', category: 'null',),
//                   ),
//                 );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

