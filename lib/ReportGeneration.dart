import 'dart:ffi';

import 'DB_HELPER.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'DutyReport_Duty.dart';
import 'DutyReport_Individual.dart';
import 'dashboard.dart';

class ReportGenerationPage extends StatelessWidget {
  const ReportGenerationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Duty Report Generation',
      home: ReportGeneration(),
    );
  }
}

class ReportGeneration extends StatefulWidget {
  const ReportGeneration({Key? key}) : super(key: key);

  @override
  State<ReportGeneration> createState() => _ReportGenerationState();
}

class _ReportGenerationState extends State<ReportGeneration> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Report Generation'),
        elevation: .1,
        backgroundColor: Color(0xff9381ff),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                      child: Container(
                        margin: EdgeInsets.only(top: 70),
                        child: Center(
                          child: Text(
                            "Report Generation",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DutyReport()),
                          );
                        },
                        child: Container(

                          width: 330,
                          // decoration: BoxDecoration(
                          //   //color: Colors.white,
                          //   //   gradient: LinearGradient(colors: [
                          //   //     Color(0xff9381ff),
                          //   //     Color.fromRGBO(143, 148, 251, .6),
                          //   //   ]),
                          //   borderRadius: BorderRadius.circular(16.0),
                          //   boxShadow: [
                          //     BoxShadow(
                          //       color: Colors.deepPurple.withOpacity(0.7),
                          //       spreadRadius: 2,
                          //       blurRadius: 7,
                          //       offset: Offset(0, 3),
                          //     ),
                          //   ],
                          // ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xff8338ec),
                                    Color(0xffc8b6ff),
                                  ],
                                  // Set your desired gradient colors
                                  begin: Alignment.topLeft,
                                  // Define the gradient start and end points
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Text(
                                      'Generate Report based on Duty',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'JosefinSans',
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => IndividualReport(dept: 'null', category: 'null',)),
                          );
                        },
                        child: Container(
                          width: 330,
                          // decoration: BoxDecoration(
                          //   //color: Colors.white,
                          //   //   gradient: LinearGradient(colors: [
                          //   //     Color(0xff9381ff),
                          //   //     Color.fromRGBO(143, 148, 251, .6),
                          //   //   ]),
                          //   borderRadius: BorderRadius.circular(16.0),
                          //   boxShadow: [
                          //     BoxShadow(
                          //       color: Colors.deepPurple.withOpacity(0.7),
                          //       spreadRadius: 2,
                          //       blurRadius: 7,
                          //       offset: Offset(0, 3),
                          //     ),
                          //   ],
                          // ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Container(

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xff8338ec),
                                    Color(0xffc8b6ff),
                                  ],
                                  // Set your desired gradient colors
                                  begin: Alignment.topLeft,
                                  // Define the gradient start and end points
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Text(
                                      'Generate Report on Individual',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'JosefinSans',
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton.icon(
                        icon: Icon(Icons.arrow_back),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xff9381ff),
                        ),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => Dashboard(),
                          //   ),
                          // );
                        },
                        label: Text('Back',),
                      ),

                      // ElevatedButton(
                      //   child: const Text('Add Students/Faculty in batches'),
                      //   onPressed: () {
                      //     Navigator.push(context, MaterialPageRoute(builder: (context)=>MyApp()),);
                      //   },
                      // ),
                      // ElevatedButton(
                      //   child: const Text('Add Student/Faculty individually'),
                      //   onPressed: () {
                      //     Navigator.push(context, MaterialPageRoute(builder: (context)=>const Add_indv()),);
                      //   },
                      // ),
                    ],
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}

