import 'reassign_main.dart';
import 'BlockUnblock.dart';
import 'ReportGeneration.dart';
import 'add_main.dart';
import 'reassign.dart';
import 'DeleteDuty.dart';
import 'package:demoapp/DB_HELPER.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'BlockUnblock.dart';
import 'DutyReport_Duty.dart';
import 'add_main.dart';
import 'assign.dart';
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
  int mtech=0,phd=0,fac=0,overall=0;    Map<String,dynamic>stats={};
  Future<void>calculate_stats()async{
    List<Map<String,dynamic>>m=[];
    m=await LocalDB().readDB("select * from Mtech");
    stats["Mtech_number"]=m.length;
    num countm=0;
    for(Map<String,dynamic>row in m){
      countm+=row["WorkHours"];
    }
    stats["Mtech_hours"]=countm;
    if(stats["Mtech_number"]!=0)
      stats["Mtech_avg"]=(stats["Mtech_hours"]/stats["Mtech_number"]).toStringAsFixed(2);
    else
      stats["Mtech_avg"]=0;
    m=await LocalDB().readDB("select * from Phd");
    stats["Phd_number"]=m.length;
    num countp=0;
    for(Map<String,dynamic>row in m){
      countp+=row["WorkHours"];
    }
    stats["Phd_hours"]=countp;
    if(stats["Phd_number"]!=0) {
      stats["Phd_avg"]=(stats["Phd_hours"]/stats["Phd_number"]).toStringAsFixed(2);
    } else {
      stats["Phd_avg"]=0;
    }
    m=await LocalDB().readDB("select * from Faculty");
    stats["Fac_number"]=m.length;
    num countf=0;
    for(Map<String,dynamic>row in m){
      countf+=row["WorkHours"];
    }
    stats["Faculty_hours"]=countf;
    if(stats["Fac_number"]!=0) {
      stats["Fac_avg"]=(stats["Faculty_hours"]/stats["Fac_number"]).toStringAsFixed(2);
    } else {
      stats["Fac_avg"]=0;
    }
    m=await LocalDB().readDB("select * from Mtech union select * from Phd union select * from Faculty");
    stats["Overall_number"]=m.length;
    stats["Overall_hours"]=countf+countm+countp;
    if(stats["Overall_number"]!=0) {
      stats["Overall_avg"]=(stats["Overall_hours"]/stats["Overall_number"]).toStringAsFixed(2);
    } else {
      stats["Overall_avg"]=0.00;
    }
  }
  @override
  @override
  void initState(){
    super.initState();
    calculate_stats();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 220) / 2;
    final double itemWidth = size.width / 2;

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
        content: SizedBox(
          height: 110,
          child: Column(
            children: [
              Text(
                "Are you sure you want to reset work hours?",style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),),
              SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning,
                    color: Colors.yellow,
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      "All details will be deleted by resetting. If required you can download the reports from \"Generate Reports\" and then proceed with the reset.",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
        backgroundColor: Color(
            0xff9381ff), //Color.fromRGBO(143, 148, 251, 1), //violet color
      ),
      /////////////////////////////////////////////
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        // child: GridView.count(
        //   padding: const EdgeInsets.fromLTRB(1, 10, 1, 10),
        //   crossAxisCount: 2,
        //   childAspectRatio: (itemWidth / itemHeight),
        //   mainAxisSpacing: 5.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              //   decoration: BoxDecoration(
              //   gradient: LinearGradient(
              //     begin: Alignment.topLeft,
              //     end: Alignment.bottomRight,
              //     colors: [Colors.blueAccent, Colors.deepPurple],
              //   ),
              // ),
              child:FutureBuilder(
                future: calculate_stats(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Container(
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          CarouselSlider(
                            options: CarouselOptions(
                              height: 200.0,
                              autoPlay: true,
                              enlargeCenterPage: true,
                              aspectRatio: 16 / 9,
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enableInfiniteScroll: true,
                            ),
                            items: [
                              makeSliderCard(
                                  Color(0xff8d99ae),
                                  Color(0xffedf2f4),
                                  "Overall Stats",
                                  "${stats["Overall_hours"]}",
                                  "${stats["Overall_avg"]}",
                                  "${stats["Overall_number"]}"),
                              makeSliderCard(
                                  Color(0xfffb8500),
                                  Color(0xffffd60a),
                                  "M.Tech",
                                  "${stats["Mtech_hours"]}",
                                  "${stats["Mtech_avg"]}",
                                  "${stats["Mtech_number"]}"),
                              makeSliderCard(
                                  Color(0xff8d99ae),
                                  Color(0xffedf2f4),
                                  "Ph.D",
                                  "${stats["Phd_hours"]}",
                                  "${stats["Phd_avg"]}",
                                  "${stats["Phd_number"]}"),
                              makeSliderCard(
                                  Color(0xfff72585),
                                  Color(0xffffb3c6),
                                  "Faculty",
                                  "${stats["Faculty_hours"]}",
                                  "${stats["Fac_avg"]}",
                                  "${stats["Fac_number"]}"),
                            ],
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),

            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AssignPage()), //AssignPage
                    );
                  },
                  child: Container(
                    width: 175,
                    //height: 155,
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            //SizedBox(height: 15,),
                            Image.asset(
                              'assets/assigndemo.png',
                              height: 90,
                            ),
                            Padding(
                              padding: EdgeInsets.all(12),
                              child: Text(
                                'Assign Duty',
                                style: TextStyle(
                                    fontSize: 16,
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
                      MaterialPageRoute(
                          builder: (context) => DutyReport1()), //DutyReport1
                    );
                  },
                  child: Container(
                    width: 175,
                    //height: 155,
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          //SizedBox(height: 15,),
                          Image.asset(
                            'assets/reallocatedemo.png',
                            height: 90,
                          ),
                          Padding(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              'Reallocate Duty',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'roboto',
                                  color: Colors.deepPurple[900]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ReportGenerationPage()), //ReportGenerationPage
                    );
                  },
                  child: Container(

                    width: 175,
                    //height: 155,
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          //SizedBox(height: 15,),
                          Image.asset(
                            'assets/reportdemo.png',
                            height: 90,
                          ),
                          Padding(
                            padding: EdgeInsets.all(
                              12,
                            ),
                            child: Center(
                              child: Text(
                                'Generate Report',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'roboto',
                                    color: Colors.deepPurple[900]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DeleteDutyPage()), //DeleteDutyPage
                    );
                  },
                  child: Container(
                    width: 175,
                    //height: 155,
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          //SizedBox(height: 15,),
                          Image.asset(
                            'assets/deletedemo.png',
                            height: 90,
                          ),
                          Padding(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              'Delete Duty',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'roboto',
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
          ],
        ),
      ),
      //////////////////////////////////////////////////////////////////

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xff9381ff),
        //Color.fromRGBO(143, 148, 251, 1),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add_alt_1_rounded),
            label: "Add Members",
            // backgroundColor: Colors.green
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_remove_alt_1_rounded),
            label: "Delete Member",
            // backgroundColor: Colors.yellow
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.refresh),
            label: "Reset Hours",
            // backgroundColor: Colors.yellow
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.block),
            label: "Block",

            // backgroundColor: Colors.blue,
          ),
        ],
        type: BottomNavigationBarType.fixed,
        //fixedColor: Colors.deepPurple[900],
        selectedItemColor: Colors.black54,
        unselectedItemColor: Colors.black54,
        selectedLabelStyle: TextStyle(fontSize: 13),
        unselectedLabelStyle: TextStyle(fontSize: 13),
        iconSize: 40,
        elevation: 5,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
          switch (index) {
            case 0:
              Navigator.push(
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
                  builder: (context) => DeletePage(dept: 'null', category: 'null',),
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
                  builder: (context) => block(dept: 'null', category: 'null',),
                ),
              );
          }
        },
      ),
    );
    return myWidget;
  }

  Container makeSliderCard(Color fromColor, Color toColor,String heading,String totalWH,String avgWH,String pplCount){
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        // color: Colors.blue,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [fromColor, toColor],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 8),
          child: Column(
            children: [
              Center(
                child: Text(heading,
                  style: TextStyle(
                      color: Color(0xff9381ff),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'roboto',
                      fontSize: 24
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        "Total Work hours: $totalWH",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Avg Work hours: $avgWH",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: null,
                    icon: Icon(Icons.people_alt_rounded,color: Colors.black,),
                    label: Text(pplCount,style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),),
                  ),
                ],
              )
            ],
          ),
        ),),
    );
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