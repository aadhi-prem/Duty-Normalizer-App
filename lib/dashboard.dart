import 'package:demoapp/BlockUnblock.dart';
import 'package:demoapp/add_main.dart';
import 'package:demoapp/delete.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'delete.dart';
import 'confirmpin.dart';

// class MainDashboard extends StatelessWidget {
//   const MainDashboard({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Dashboard();
//   }
// }

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
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
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 200) / 2;
    final double itemWidth = size.width / 2;



    showAlertDialog(BuildContext context) {
      // set up the buttons
      Widget cancelButton = TextButton(
        onPressed: () {
          Navigator.of(context).pop(); //dismiss dialog
        },
        child: Text("Cancel"),
      );
      Widget continueButton = TextButton(
        onPressed: () {
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

    var myWidget = Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Duty Normalizer",
        ),
        elevation: .1,
        backgroundColor: Color(0xff9381ff), //Color.fromRGBO(143, 148, 251, 1), //violet color
      ),
      /////////////////////////////////////////////
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: GridView.count(
          padding: const EdgeInsets.fromLTRB(1, 10, 1, 10),
          crossAxisCount: 2,
          childAspectRatio: (itemWidth / itemHeight),
          mainAxisSpacing: 5.0,
          children: <Widget>[
            InkWell(
              onTap: () => null,
              child: Container(
                decoration: BoxDecoration(
                  //color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.7),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Container(
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Image.asset(
                          'assets/Assign_duty.png',
                          height: 165,
                        ),
                        Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            'Allocate Duty',
                            style: TextStyle(
                                fontSize: 21,
                                fontFamily: 'Alkatra',
                                color: Colors.deepPurple[900]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  //color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.7),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Card(
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        'assets/Reallocate_duty.png',
                        height: 165,
                      ),
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          'Reallocate Duty',
                          style: TextStyle(
                              fontSize: 21,
                              fontFamily: 'Alkatra',
                              color: Colors.deepPurple[900]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () => null,
              child: Container(
                decoration: BoxDecoration(
                  //color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.7),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Card(
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        'assets/Duty_report_generation.png',
                        height: 165,
                      ),
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          'Duty Report',
                          style: TextStyle(
                              fontSize: 21,
                              fontFamily: 'Alkatra',
                              color: Colors.deepPurple[900]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () => null,
              child: Container(
                decoration: BoxDecoration(
                  //color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.7),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Card(
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        'assets/delete_duty.png',
                        height: 165,
                      ),
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          'Delete Duty',
                          style: TextStyle(
                              fontSize: 21,
                              fontFamily: 'Alkatra',
                              color: Colors.deepPurple[900]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Container(
            //   child: _widgetOptions.elementAt(_selectedIndex),
            // ),
          ],
        ),
      ),
      //////////////////////////////////////////////////////////////////

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
                  builder: (context) => DeletePage(),
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
                  builder: (context) => block(),
                ),
              );
          }
        },
      ),
    );
    return myWidget;
  }

//   Card makeDashboardItem(String title, String path) {
//     return Card(
//         elevation: 1.0,
//         margin: new EdgeInsets.all(8.0),
//         child: Container(
//           decoration: BoxDecoration(color: Colors.white.withOpacity(0.1)),
//           child: new InkWell(
//             onTap: () {},
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               mainAxisSize: MainAxisSize.min,
//               verticalDirection: VerticalDirection.down,
//               children: <Widget>[
//                 SizedBox(height: 20.0),
//                 Center(
//                     child: TextButton(child: FittedBox(
//                       child: Image.asset(path), fit: BoxFit.fill,),
//                       onPressed: null,)),
//                 //SizedBox(height: 7.0),
//                 new Center(
//                   child: new Text(title,
//                       style:
//                       new TextStyle(fontSize: 18.0, color: Colors.black)),
//                 )
//               ],
//             ),
//           ),
//         ));
//   }
}
