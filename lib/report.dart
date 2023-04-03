import 'dart:ffi';
import 'dart:math';
import 'package:flutter/material.dart';
import 'DB_HELPER.dart';
import 'dashboard.dart';
//import 'blankpage.dart';
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'filter_delete.dart';

class ReportPage extends StatelessWidget {
  // const DeletePage({Key? key}) : super(key: key);

  int mtech=0,phd=0,faculty=0,hours=0;String? dept,name;
  ReportPage({required this.mtech, required this.phd,required this.faculty,required this.dept,required this.hours,required this.name});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Search',
      home: Report(mtech,phd,faculty,dept,hours,name),
    );
  }
}

class Report extends StatefulWidget {
//   const Delete({Key? key}) : super(key: key);

  int mtech=0,phd=0,faculty=0,hours=0; String? dept,name;
  Report(this.mtech, this.phd,this.faculty,this.dept,this.hours,this.name);
  @override
  State<Report> createState() => ReportState(mtech,phd,faculty,dept,hours,name);
}

class ReportState extends State<Report> {

  int mtech=0,phd=0,faculty=0,hours=0;String? dept,name;
  ReportState(this.mtech, this.phd,this.faculty,this.dept,this.hours,this.name);

  List<Map<String,dynamic>>m=[];
  List<Map<String,dynamic>>results=[];
  void initState(){
    super.initState();
   start();

  }
  Future<void> start() async {
    await LocalDB().executeDB("INSERT into Duty values ('$name',$hours);");
    List<Map<String, dynamic>> randomValues3 = [];
    List<Map<String, dynamic>> randomValues2 = [];
    List<Map<String, dynamic>> randomValues = [];
    if (dept != null) {
      randomValues = List.from(await LocalDB().readDB(
          "SELECT * FROM Mtech WHERE DEPARTMENT='$dept' and Status='Unblocked' order by WorkHours,RANDOM() LIMIT $mtech;"));
      for (Map<String, dynamic>row in randomValues) {
        String r = row["ID"];
        int w = row["WorkHours"];
        w += hours;
        await LocalDB().executeDB(
            "UPDATE Mtech set WorkHours=$w where ID='$r';");
        await LocalDB().executeDB(
            "INSERT into DutyDetails values ('$r','$name');");
      }
      debugPrint("$randomValues");
      randomValues2 = List.from(await LocalDB().readDB(
          "SELECT * FROM PhD WHERE DEPARTMENT='$dept' and Status='Unblocked' order by WorkHours,RANDOM() LIMIT $phd;"));
      for (Map<String, dynamic>row in randomValues2) {
        String r = row["ID"];
        int w = row["WorkHours"];
        w += hours;
        await LocalDB().executeDB(
            "UPDATE PhD set WorkHours=$w where ID='$r';");
        await LocalDB().executeDB(
            "INSERT into DutyDetails values ('$r','$name');");
      }
      randomValues3 = List.from(await LocalDB().readDB(
          "SELECT * FROM Faculty WHERE DEPARTMENT='$dept' and Status='Unblocked' order by WorkHours,RANDOM() LIMIT $faculty"));
      for (Map<String, dynamic>row in randomValues3) {
        String r = row["ID"];
        int w = row["WorkHours"];
        w += hours;
        await LocalDB().executeDB(
            "UPDATE Faculty set WorkHours=$w where ID='$r';");
        await LocalDB().executeDB(
            "INSERT into DutyDetails values ('$r','$name');");
      }
      results = [...randomValues, ...randomValues2, ...randomValues3];
      setState(() {
        results = results;
      });
      debugPrint("$results");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff9381ff),
        title: const Text('Duty Assigned'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [

            Expanded(
              child: results.isNotEmpty
                  ? ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) => Card(
                  key: ValueKey(results[index]["id"]),
                  color: Color(0xff9381ff),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('${results[index]["ID"]} '),
                        Text(' ${results[index]["Name"]} '),
                        Text(' ${results[index]["DEPARTMENT"]} '),
                        Text(' ${results[index]["WorkHours"]+hours} '),
                      ],
                    ),
                  ),
                ),
              )
                  : const Text(
                'No results found',
                style: TextStyle(fontSize: 24),
              ),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom( primary: Color(0xffff595e),),
              onPressed: () {  },
              child: const Text('Print',style: TextStyle(fontSize: 17),),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom( primary: Color(0xffff595e),),
              onPressed: () {
                Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Dashboard()),
              ); },
              child: const Text('Done',style: TextStyle(fontSize: 17),),
            )
          ],
        ),
      ),
    );
  }
}
