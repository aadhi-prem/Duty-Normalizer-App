import 'dart:ffi';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
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
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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
      // debugPrint("$results");
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
                    child: Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('  ${results[index]["ID"]} '),
                          Text(' ${results[index]["Name"]} '),
                          Text(' ${results[index]["PhoneNo"]} '),
                          Text(' ${results[index]["Email"]}'),
                        ],
                      ),
                    ),
                  ),
                ),
              )
                  : const Text(
                'Loading results',
                style: TextStyle(fontSize: 24),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom( primary: Color(0xffff595e),),
                  onPressed: () async {

                    await download(results,name!,mtech,phd,faculty,dept!);
                  },
                  label: const Text('Print',style: TextStyle(fontSize: 17),),
                  icon: Icon(Icons.print),
                ),
                SizedBox(width: 40,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom( primary: Color(0xff0077b6),),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Dashboard()),
                    ); },
                  child: const Text('Done',style: TextStyle(fontSize: 17),),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> download(List<Map<String,dynamic>> m, String name,int mtech,int phd, int faculty, String dept) async {
    debugPrint("IN DOWNLOAD");
    List<List<String>> l=[];
    for(Map<String,dynamic>r in m){
      debugPrint("${r["Name"]}");
      List<String> a=[];
      a.add(r["ID"]);
      a.add(r["Name"]);
      // a.add(r["DEPARTMENT"]);
      a.add(r["PhoneNo"]);
      a.add(r["Email"]);
      l.add(a);
    }

    Uint8List pdf= await createPdf(l,name,mtech,phd,faculty,dept) as Uint8List;
    await downloadPdf(pdf);
    debugPrint("downloaded");
  }

  Future<Uint8List> createPdf(List<List<String>> data,String name,int mtech, int phd, int faculty,String dept) async{
    final pdf = pw.Document();
    final tableHeaders = ['ID', 'Name', 'PhoneNo', 'Email'];

    var tableData=data;
    // pdf.addPage(pw.Page(
    // build: (context) => pw.Table.fromTextArray(
    // headers: tableHeaders,
    // data: tableData,
    // ),
    // ));

    // // Split the data into chunks of 10 rows each
    // const chunkSize = 15;
    // final chunks = <List<List<String>>>[];
    // for (var i = 0; i < data.length; i += chunkSize) {
    //   final end = (i + chunkSize < data.length) ? i + chunkSize : data.length;
    //   chunks.add(data.sublist(i, end));
    // }
    // // Create a new page for each chunk of data
    // for (var chunk in chunks) {
    //   pdf.addPage(pw.Page(
    //     build: (context) => pw.Table.fromTextArray(
    //       headers: tableHeaders,
    //       data: chunk,
    //       cellAlignment: pw.Alignment.centerLeft,
    //       cellStyle: const pw.TextStyle(fontSize: 10),
    //      // cellDecoration: cellDecoration,
    //     ),
    //   ));
    // }

    // Create a table for each chunk of data
    const chunkSize = 15;
    final chunks = <List<List<String>>>[];
    for (var i = 0; i < data.length; i += chunkSize) {
      final end = (i + chunkSize < data.length) ? i + chunkSize : data.length;
      chunks.add(data.sublist(i, end));
    }
    for (var chunk in chunks) {
      pdf.addPage(pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('DUTY REPORT', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold) ,textAlign: pw.TextAlign.center,
            ),
            pw.SizedBox(height: 15),


            pw.Text('DUTY NAME: $name', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)
            ),
            pw.SizedBox(height: 15),

            pw.Text('DEPARTMENT: $dept', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)
            ),
            pw.SizedBox(height: 15),

            // pw.Text('NUMBER OF MTECH: $mtech    NUMBER OF P.HD.: $phd    NUMBER OF FACULTY: $faculty ', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)
            // ),
            // pw.SizedBox(height: 15),

            pw.Table.fromTextArray(
              headers: tableHeaders,
              data: chunk,
              cellAlignment: pw.Alignment.centerLeft,
              cellStyle: const pw.TextStyle(fontSize: 10),
              cellHeight: 15,
              // cellDecoration: cellDecoration,
            ),
          ],
        ),
      ));
    }

    return pdf.save();
  }

  Future<void> downloadPdf(Uint8List pdf) async {
    // Save the PDF file to the local file system
    Directory tempDirectory = await getTemporaryDirectory();
    String tempPath = tempDirectory.path;
    File file = File('$tempPath/data.pdf');
    await file.writeAsBytes(pdf);
    // Open the PDF file using the open_file package
    await OpenFile.open(file.path);
  }



}