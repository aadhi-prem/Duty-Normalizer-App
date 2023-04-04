import 'dart:ffi';

import 'DB_HELPER.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'DutyReport_Duty.dart';
import 'DutyReport_Individual.dart';
import 'dashboard.dart';

void main() => runApp(ReportGenerationPage());

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
        title: Text('Report Generation'),
        elevation: .1,
        backgroundColor: Color(0xff9381ff),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DutyReport()),
                  );
                },
                child: const Text(
                    'Generate Report on Duty'
                )),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => IndividualReport(dept: 'null', category: 'null',)),
                  );
                },
                child: Text(
                    'Generate Report on Individual'
                )),

            ElevatedButton.icon(
              icon: Icon(Icons.arrow_back),
              style: ElevatedButton.styleFrom(
                primary: Color(0xff9381ff),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Dashboard(),
                  ),
                );
              },
              label: Text('Back',style: TextStyle(color: Colors.white,fontSize: 18),),
            ),
          ],
        ),
      ),
    );
  }
}


