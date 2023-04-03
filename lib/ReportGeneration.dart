import 'dart:ffi';

import 'DB_HELPER.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'DutyReport_Duty.dart';
import 'DutyReport_Individual.dart';

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
      ),
      body: Center(
        child: Column(
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
          ],
        ),
      ),
    );
  }
}



