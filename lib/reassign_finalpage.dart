import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:demoapp/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:async';
import 'package:path/path.dart';


class finalpage extends StatelessWidget {
  List<Map<String,dynamic>>m=[];
  String? duty_name;
  finalpage({required this.m, required this.duty_name});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Reassigned Duty',
      home: finalreass(m,duty_name),
    );
  }
}

class finalreass extends StatefulWidget {
//   const Delete({Key? key}) : super(key: key);

  List<Map<String,dynamic>>m=[];
  String? duty_name;
  finalreass(this.m,this.duty_name);

  @override
  State<finalreass> createState() => finalState(m,duty_name);
}

class finalState extends State<finalreass> {

  List<Map<String,dynamic>>m=[];
  String? duty_name;
  finalState(this.m,this.duty_name);
// Open the database and store the reference.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff9381ff),
        title: const Text('Reallocate Student/Faculty'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: m.isNotEmpty
                  ? ListView.builder(
                itemCount: m.length,
                itemBuilder: (context, index) => Container(
                  height: 60,
                  child: Card(
                    key: ValueKey(m[index]["ID"]),
                    color: Color(0xff9381ff),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('  ${m[index]["ID"]} '),
                          Text(' ${m[index]["Name"]} '),
                          Text(' ${m[index]["DEPARTMENT"]} '),
                        ],
                      ),
                    ),
                  ),
                ),
              )
                  : const Text(
                'No results found',
                style: TextStyle(fontSize: 24,color: Color(0xffff595e),),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // SizedBox(width: 32,),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff0077b6),//0xff0077b6
                  ),
                  onPressed: () async {
                    await download(m,duty_name!);
                  },
                  label: Text('Download',style: TextStyle(fontSize: 17),),
                  icon: Icon(Icons.download_sharp),
                ),
                // SizedBox(width: 50,),
                Container(
                  width: 140,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xff9381ff),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>Dashboard()),
                      );
                    },
                    child: Text('Done',style: TextStyle(fontSize: 17),),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Future<void> download(List<Map<String,dynamic>> m, String name) async {
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
    Uint8List pdf= await createPdf(l,name);
    await downloadPdf(pdf);
    debugPrint("downloaded");
  }

  Future<Uint8List> createPdf(List<List<String>> data,String name) async{
    final pdf = pw.Document();
    final tableHeaders = ['ID', 'Name', 'PhoneNo', 'Email'];
    var tableData=data;
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
            pw.Text('REALLOCATED DUTY REPORT', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold) ,textAlign: pw.TextAlign.center,
            ),
            pw.SizedBox(height: 15),


            pw.Text('DUTY NAME: $name', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)
            ),
            pw.SizedBox(height: 15),

            // pw.Text('DEPARTMENT: $dept', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)
            // ),
            // pw.SizedBox(height: 15),

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